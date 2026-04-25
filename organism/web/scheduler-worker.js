/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Scheduler Worker (GOK-SCHEDULER-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-SCHEDULER-001
 * Kernel Family:  TASK_SCHEDULER
 * Architecture:   Priority Queue × Cron Parser × Dependency Graph × φ-Backoff
 *
 * Task scheduling engine with φ-weighted priority queue, cron expression
 * parsing, dependency-aware execution ordering, exponential backoff with
 * phi-based multiplier, and configurable concurrency limits.
 *
 * Features:
 *   • Priority queue with φ-weighted scoring
 *   • Cron expression parsing (min hr dom mon dow)
 *   • Task dependency chains (B waits for A)
 *   • Exponential backoff with φ-based multiplier
 *   • Configurable max concurrency limits
 *   • Retry tracking with max-retry enforcement
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'schedule', task }
 *   Main → Worker: { type: 'cancel', taskId }
 *   Main → Worker: { type: 'list-pending' }
 *   Main → Worker: { type: 'list-running' }
 *   Main → Worker: { type: 'complete', taskId, result }
 *   Main → Worker: { type: 'fail', taskId, error }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'task-scheduled', taskId }
 *   Worker → Main: { type: 'task-ready', taskId, task }
 *   Worker → Main: { type: 'task-completed', taskId }
 *   Worker → Main: { type: 'task-failed', taskId, retrying }
 *   Worker → Main: { type: 'task-cancelled', taskId }
 *   Worker → Main: { type: 'pending-list', tasks }
 *   Worker → Main: { type: 'running-list', tasks }
 *   Worker → Main: { type: 'heartbeat', ... }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */


/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var KERNEL_ID      = 'GOK-SCHEDULER-001';
var KERNEL_FAMILY  = 'TASK_SCHEDULER';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;

var MAX_CONCURRENCY = 8;
var MAX_RETRIES     = 5;
var BASE_BACKOFF_MS = 1000;
var nextTaskId      = 1;


/* ════════════════════════════════════════════════════════════════
   TASK QUEUES
   ════════════════════════════════════════════════════════════════ */

var pendingQueue   = [];   // sorted by effective priority
var runningTasks   = {};   // taskId → task
var completedTasks = {};   // taskId → result
var taskIndex      = {};   // taskId → task reference (all states)
var cronTasks      = [];   // recurring cron tasks


/* ════════════════════════════════════════════════════════════════
   CRON EXPRESSION PARSER — "min hr dom mon dow"
   ════════════════════════════════════════════════════════════════ */

function parseCronField(field, min, max) {
  if (field === '*') {
    var all = [];
    for (var i = min; i <= max; i++) all.push(i);
    return all;
  }
  var values = [];
  var parts = field.split(',');
  for (var p = 0; p < parts.length; p++) {
    var part = parts[p];
    // Step syntax: */n or m-n/s
    var stepParts = part.split('/');
    var step = stepParts.length > 1 ? parseInt(stepParts[1], 10) : 1;
    var range = stepParts[0];

    if (range === '*') {
      for (var s = min; s <= max; s += step) values.push(s);
    } else if (range.indexOf('-') > -1) {
      var bounds = range.split('-');
      var lo = parseInt(bounds[0], 10);
      var hi = parseInt(bounds[1], 10);
      for (var r = lo; r <= hi; r += step) values.push(r);
    } else {
      values.push(parseInt(range, 10));
    }
  }
  return values;
}

function parseCron(expr) {
  var fields = String(expr).trim().split(/\s+/);
  if (fields.length < 5) return null;
  return {
    minutes:  parseCronField(fields[0], 0, 59),
    hours:    parseCronField(fields[1], 0, 23),
    days:     parseCronField(fields[2], 1, 31),
    months:   parseCronField(fields[3], 1, 12),
    weekdays: parseCronField(fields[4], 0, 6),
  };
}

function cronMatches(cronDef, date) {
  if (!cronDef) return false;
  return cronDef.minutes.indexOf(date.getMinutes()) > -1
      && cronDef.hours.indexOf(date.getHours()) > -1
      && cronDef.days.indexOf(date.getDate()) > -1
      && cronDef.months.indexOf(date.getMonth() + 1) > -1
      && cronDef.weekdays.indexOf(date.getDay()) > -1;
}


/* ════════════════════════════════════════════════════════════════
   φ-WEIGHTED PRIORITY SCORING
   ════════════════════════════════════════════════════════════════ */

function computeEffectivePriority(task) {
  var base = typeof task.priority === 'number' ? task.priority : 5;
  var ageFactor = (Date.now() - task.createdAt) / 60000;  // minutes waiting
  // Higher base priority + age bonus, scaled by φ
  return (base * PHI) + (ageFactor * PHI_INV);
}

function sortPendingQueue() {
  pendingQueue.sort(function(a, b) {
    return computeEffectivePriority(b) - computeEffectivePriority(a);
  });
}


/* ════════════════════════════════════════════════════════════════
   DEPENDENCY CHECK
   ════════════════════════════════════════════════════════════════ */

function areDependenciesMet(task) {
  if (!task.dependencies || task.dependencies.length === 0) return true;
  for (var d = 0; d < task.dependencies.length; d++) {
    var depId = task.dependencies[d];
    if (!completedTasks[depId]) return false;
  }
  return true;
}


/* ════════════════════════════════════════════════════════════════
   SCHEDULE / CANCEL
   ════════════════════════════════════════════════════════════════ */

function scheduleTask(descriptor) {
  var taskId = 'task-' + (nextTaskId++);
  var task = {
    id: taskId,
    name: descriptor.name || taskId,
    payload: descriptor.payload || null,
    priority: typeof descriptor.priority === 'number' ? descriptor.priority : 5,
    dependencies: descriptor.dependencies || [],
    cron: descriptor.cron || null,
    cronDef: descriptor.cron ? parseCron(descriptor.cron) : null,
    maxRetries: typeof descriptor.maxRetries === 'number' ? descriptor.maxRetries : MAX_RETRIES,
    retryCount: 0,
    nextRetryAt: 0,
    status: 'pending',
    createdAt: Date.now(),
    startedAt: null,
    completedAt: null,
    result: null,
    error: null,
  };
  taskIndex[taskId] = task;

  if (task.cronDef) {
    cronTasks.push(task);
  }

  pendingQueue.push(task);
  sortPendingQueue();
  return task;
}

function cancelTask(taskId) {
  var task = taskIndex[taskId];
  if (!task) return false;

  if (task.status === 'pending') {
    for (var i = pendingQueue.length - 1; i >= 0; i--) {
      if (pendingQueue[i].id === taskId) {
        pendingQueue.splice(i, 1);
        break;
      }
    }
  }
  if (task.status === 'running') {
    delete runningTasks[taskId];
  }
  task.status = 'cancelled';
  return true;
}


/* ════════════════════════════════════════════════════════════════
   COMPLETE / FAIL
   ════════════════════════════════════════════════════════════════ */

function completeTask(taskId, result) {
  var task = taskIndex[taskId];
  if (!task) return null;
  task.status = 'completed';
  task.completedAt = Date.now();
  task.result = result;
  delete runningTasks[taskId];
  completedTasks[taskId] = { result: result, completedAt: task.completedAt };
  return task;
}

function failTask(taskId, error) {
  var task = taskIndex[taskId];
  if (!task) return null;
  task.error = error;
  delete runningTasks[taskId];

  // Retry with φ-based exponential backoff
  if (task.retryCount < task.maxRetries) {
    task.retryCount++;
    var backoff = BASE_BACKOFF_MS * Math.pow(PHI, task.retryCount);
    task.nextRetryAt = Date.now() + backoff;
    task.status = 'pending';
    pendingQueue.push(task);
    sortPendingQueue();
    return { task: task, retrying: true, nextRetryMs: backoff };
  }

  task.status = 'failed';
  return { task: task, retrying: false };
}


/* ════════════════════════════════════════════════════════════════
   DISPATCH ENGINE — promote pending → running
   ════════════════════════════════════════════════════════════════ */

function dispatchReady() {
  var now = Date.now();
  var runCount = Object.keys(runningTasks).length;
  var dispatched = [];

  for (var i = pendingQueue.length - 1; i >= 0 && runCount < MAX_CONCURRENCY; i--) {
    var task = pendingQueue[i];

    // Skip if waiting for retry window
    if (task.nextRetryAt && now < task.nextRetryAt) continue;
    // Skip if dependencies not met
    if (!areDependenciesMet(task)) continue;

    // Promote to running
    pendingQueue.splice(i, 1);
    task.status = 'running';
    task.startedAt = now;
    runningTasks[task.id] = task;
    runCount++;
    dispatched.push(task);
  }

  // Notify main thread of ready tasks
  for (var d = 0; d < dispatched.length; d++) {
    self.postMessage({
      type: 'task-ready',
      taskId: dispatched[d].id,
      task: {
        id: dispatched[d].id,
        name: dispatched[d].name,
        payload: dispatched[d].payload,
        priority: dispatched[d].priority,
        retryCount: dispatched[d].retryCount,
      },
      kernelId: KERNEL_ID,
    });
  }

  return dispatched.length;
}


/* ════════════════════════════════════════════════════════════════
   CRON TICK — check recurring tasks
   ════════════════════════════════════════════════════════════════ */

var lastCronMinute = -1;

function cronTick() {
  var now = new Date();
  var currentMinute = now.getMinutes();
  if (currentMinute === lastCronMinute) return;
  lastCronMinute = currentMinute;

  for (var c = 0; c < cronTasks.length; c++) {
    var ct = cronTasks[c];
    if (ct.status === 'cancelled') continue;
    if (cronMatches(ct.cronDef, now)) {
      // Schedule a new instance
      scheduleTask({
        name: ct.name + '@' + now.toISOString(),
        payload: ct.payload,
        priority: ct.priority,
        dependencies: [],
        maxRetries: ct.maxRetries,
      });
    }
  }
}


/* ════════════════════════════════════════════════════════════════
   LIST HELPERS
   ════════════════════════════════════════════════════════════════ */

function taskSummary(task) {
  return {
    id: task.id,
    name: task.name,
    priority: task.priority,
    effectivePriority: computeEffectivePriority(task),
    status: task.status,
    retryCount: task.retryCount,
    createdAt: task.createdAt,
    startedAt: task.startedAt,
    dependencies: task.dependencies,
  };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'schedule': {
      var task = scheduleTask(msg.task || msg);
      self.postMessage({
        type: 'task-scheduled',
        taskId: task.id,
        name: task.name,
        priority: task.priority,
        pendingCount: pendingQueue.length,
        kernelId: KERNEL_ID,
      });
      // Try to dispatch immediately
      dispatchReady();
      break;
    }

    case 'cancel': {
      var cancelled = cancelTask(msg.taskId);
      self.postMessage({
        type: 'task-cancelled',
        taskId: msg.taskId,
        success: cancelled,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'list-pending': {
      var pending = [];
      for (var p = 0; p < pendingQueue.length; p++) {
        pending.push(taskSummary(pendingQueue[p]));
      }
      self.postMessage({
        type: 'pending-list',
        tasks: pending,
        count: pending.length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'list-running': {
      var runIds = Object.keys(runningTasks);
      var runList = [];
      for (var r = 0; r < runIds.length; r++) {
        runList.push(taskSummary(runningTasks[runIds[r]]));
      }
      self.postMessage({
        type: 'running-list',
        tasks: runList,
        count: runList.length,
        maxConcurrency: MAX_CONCURRENCY,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'complete': {
      var completed = completeTask(msg.taskId, msg.result);
      if (completed) {
        self.postMessage({
          type: 'task-completed',
          taskId: completed.id,
          name: completed.name,
          duration: completed.completedAt - completed.startedAt,
          kernelId: KERNEL_ID,
        });
        // Check if any pending tasks now have deps met
        dispatchReady();
      }
      break;
    }

    case 'fail': {
      var failed = failTask(msg.taskId, msg.error);
      if (failed) {
        self.postMessage({
          type: 'task-failed',
          taskId: failed.task.id,
          name: failed.task.name,
          retrying: failed.retrying,
          retryCount: failed.task.retryCount,
          maxRetries: failed.task.maxRetries,
          error: msg.error,
          kernelId: KERNEL_ID,
        });
      }
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'scheduler-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        pendingCount: pendingQueue.length,
        runningCount: Object.keys(runningTasks).length,
        completedCount: Object.keys(completedTasks).length,
        cronCount: cronTasks.length,
        maxConcurrency: MAX_CONCURRENCY,
        nextTaskId: nextTaskId,
        beat: beatCount,
        phase: kernelPhase,
        phi: PHI,
      });
      break;
    }

    case 'stop': {
      running = false;
      clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
    }
  }
};


/* ════════════════════════════════════════════════════════════════
   φ-COUPLED HEARTBEAT — 873ms Kuramoto pulse
   ════════════════════════════════════════════════════════════════ */

var _hbi = setInterval(function() {
  if (!running) return;
  beatCount++;
  kernelPhase += PHI_INV;
  if (kernelPhase > 2 * Math.PI) kernelPhase -= 2 * Math.PI;

  // Dispatch ready tasks each beat
  dispatchReady();
  // Check cron schedules
  cronTick();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    pendingCount: pendingQueue.length,
    runningCount: Object.keys(runningTasks).length,
  });
}, HEARTBEAT);
