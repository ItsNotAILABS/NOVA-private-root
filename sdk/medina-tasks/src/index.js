/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-tasks — TASK SCHEDULING AND EXECUTION SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides task management:
 *   - Task creation and scheduling
 *   - Sequential and parallel execution
 *   - Dependencies and workflows
 *   - Progress tracking
 *   - Error handling and retries
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const TASK_STATUS = {
  PENDING: 'PENDING',
  QUEUED: 'QUEUED',
  RUNNING: 'RUNNING',
  PAUSED: 'PAUSED',
  COMPLETED: 'COMPLETED',
  FAILED: 'FAILED',
  CANCELLED: 'CANCELLED',
};

const TASK_PRIORITY = {
  CRITICAL: 1.0,
  HIGH: PHI_INV,           // ~0.618
  NORMAL: PHI_INV * PHI_INV, // ~0.382
  LOW: 0.2,
  BACKGROUND: 0.1,
};

const TASK_TYPES = {
  SIMPLE: 'SIMPLE',           // Single action
  SEQUENTIAL: 'SEQUENTIAL',   // Steps in order
  PARALLEL: 'PARALLEL',       // Steps in parallel
  WORKFLOW: 'WORKFLOW',       // Complex with dependencies
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — TASK CLASS
// ═══════════════════════════════════════════════════════════════════════════════

class Task {
  constructor(config) {
    this.id = config.id || `task_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.name = config.name || 'Unnamed Task';
    this.description = config.description || '';
    this.type = config.type || TASK_TYPES.SIMPLE;
    this.priority = config.priority || TASK_PRIORITY.NORMAL;
    this.handler = config.handler;
    this.steps = config.steps || [];
    this.dependencies = config.dependencies || [];
    
    this.status = TASK_STATUS.PENDING;
    this.progress = 0;
    this.result = null;
    this.error = null;
    this.retries = 0;
    this.maxRetries = config.maxRetries || 3;
    
    this.createdAt = Date.now();
    this.queuedAt = null;
    this.startedAt = null;
    this.completedAt = null;
    
    this._listeners = [];
  }
  
  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────
  
  queue() {
    this.status = TASK_STATUS.QUEUED;
    this.queuedAt = Date.now();
    this._notify('queued');
  }
  
  start() {
    this.status = TASK_STATUS.RUNNING;
    this.startedAt = Date.now();
    this._notify('started');
  }
  
  pause() {
    if (this.status === TASK_STATUS.RUNNING) {
      this.status = TASK_STATUS.PAUSED;
      this._notify('paused');
    }
  }
  
  resume() {
    if (this.status === TASK_STATUS.PAUSED) {
      this.status = TASK_STATUS.RUNNING;
      this._notify('resumed');
    }
  }
  
  complete(result) {
    this.status = TASK_STATUS.COMPLETED;
    this.progress = 1.0;
    this.result = result;
    this.completedAt = Date.now();
    this._notify('completed', result);
  }
  
  fail(error) {
    this.error = error;
    if (this.retries < this.maxRetries) {
      this.retries++;
      this.status = TASK_STATUS.QUEUED;
      this._notify('retrying', { attempt: this.retries, error });
    } else {
      this.status = TASK_STATUS.FAILED;
      this.completedAt = Date.now();
      this._notify('failed', error);
    }
  }
  
  cancel() {
    this.status = TASK_STATUS.CANCELLED;
    this.completedAt = Date.now();
    this._notify('cancelled');
  }
  
  updateProgress(progress) {
    this.progress = Math.min(1.0, Math.max(0, progress));
    this._notify('progress', this.progress);
  }
  
  // ─────────────────────────────────────────────────────────────────────────────
  // EVENTS
  // ─────────────────────────────────────────────────────────────────────────────
  
  on(event, callback) {
    this._listeners.push({ event, callback });
  }
  
  _notify(event, data = null) {
    for (const listener of this._listeners) {
      if (listener.event === event || listener.event === '*') {
        listener.callback(this, data);
      }
    }
  }
  
  // ─────────────────────────────────────────────────────────────────────────────
  // STATE
  // ─────────────────────────────────────────────────────────────────────────────
  
  toJSON() {
    return {
      id: this.id,
      name: this.name,
      description: this.description,
      type: this.type,
      priority: this.priority,
      status: this.status,
      progress: this.progress,
      retries: this.retries,
      createdAt: this.createdAt,
      queuedAt: this.queuedAt,
      startedAt: this.startedAt,
      completedAt: this.completedAt,
      duration: this.completedAt && this.startedAt 
        ? this.completedAt - this.startedAt 
        : null,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — TASK QUEUE
// ═══════════════════════════════════════════════════════════════════════════════

class TaskQueue {
  constructor(config = {}) {
    this._queue = [];
    this._maxSize = config.maxSize || 512;
    this._processing = false;
    this._concurrency = config.concurrency || 1;
    this._running = new Set();
  }
  
  /**
   * Add task to queue
   */
  enqueue(task) {
    if (this._queue.length >= this._maxSize) {
      throw new Error('Task queue is full');
    }
    
    task.queue();
    this._queue.push(task);
    
    // Sort by priority
    this._queue.sort((a, b) => b.priority - a.priority);
    
    // Try to process
    this._processNext();
    
    return task;
  }
  
  /**
   * Process next task
   */
  async _processNext() {
    if (this._running.size >= this._concurrency) return;
    
    const task = this._queue.find(t => 
      t.status === TASK_STATUS.QUEUED && 
      this._dependenciesSatisfied(t)
    );
    
    if (!task) return;
    
    this._running.add(task.id);
    task.start();
    
    try {
      const result = await this._executeTask(task);
      task.complete(result);
    } catch (error) {
      task.fail(error);
    } finally {
      this._running.delete(task.id);
      this._processNext();
    }
  }
  
  /**
   * Execute a task based on its type
   */
  async _executeTask(task) {
    switch (task.type) {
      case TASK_TYPES.SIMPLE:
        return task.handler ? await task.handler(task) : null;
        
      case TASK_TYPES.SEQUENTIAL:
        return this._executeSequential(task);
        
      case TASK_TYPES.PARALLEL:
        return this._executeParallel(task);
        
      case TASK_TYPES.WORKFLOW:
        return this._executeWorkflow(task);
        
      default:
        throw new Error(`Unknown task type: ${task.type}`);
    }
  }
  
  async _executeSequential(task) {
    const results = [];
    
    for (let i = 0; i < task.steps.length; i++) {
      const step = task.steps[i];
      const result = await step.handler({ task, stepIndex: i, previousResults: results });
      results.push(result);
      task.updateProgress((i + 1) / task.steps.length);
    }
    
    return results;
  }
  
  async _executeParallel(task) {
    const promises = task.steps.map((step, i) => 
      step.handler({ task, stepIndex: i })
    );
    
    const results = await Promise.all(promises);
    task.updateProgress(1.0);
    
    return results;
  }
  
  async _executeWorkflow(task) {
    // Build dependency graph
    const completed = new Map();
    const pending = [...task.steps];
    
    while (pending.length > 0) {
      const ready = pending.filter(step => 
        (step.dependencies || []).every(dep => completed.has(dep))
      );
      
      if (ready.length === 0 && pending.length > 0) {
        throw new Error('Workflow has unresolvable dependencies');
      }
      
      // Execute ready steps in parallel
      const results = await Promise.all(
        ready.map(step => step.handler({ task, completed }))
      );
      
      // Mark as completed
      ready.forEach((step, i) => {
        completed.set(step.id, results[i]);
        const idx = pending.indexOf(step);
        pending.splice(idx, 1);
      });
      
      task.updateProgress((task.steps.length - pending.length) / task.steps.length);
    }
    
    return Object.fromEntries(completed);
  }
  
  _dependenciesSatisfied(task) {
    return task.dependencies.every(depId => {
      const dep = this._queue.find(t => t.id === depId);
      return !dep || dep.status === TASK_STATUS.COMPLETED;
    });
  }
  
  /**
   * Get task by ID
   */
  get(taskId) {
    return this._queue.find(t => t.id === taskId);
  }
  
  /**
   * Cancel a task
   */
  cancel(taskId) {
    const task = this.get(taskId);
    if (task) {
      task.cancel();
    }
  }
  
  /**
   * Get queue state
   */
  getState() {
    return {
      size: this._queue.length,
      maxSize: this._maxSize,
      concurrency: this._concurrency,
      running: this._running.size,
      pending: this._queue.filter(t => t.status === TASK_STATUS.PENDING).length,
      queued: this._queue.filter(t => t.status === TASK_STATUS.QUEUED).length,
      completed: this._queue.filter(t => t.status === TASK_STATUS.COMPLETED).length,
      failed: this._queue.filter(t => t.status === TASK_STATUS.FAILED).length,
    };
  }
  
  /**
   * Get all tasks
   */
  getTasks() {
    return this._queue.map(t => t.toJSON());
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — TASK SCHEDULER
// ═══════════════════════════════════════════════════════════════════════════════

class TaskScheduler {
  constructor() {
    this._scheduled = new Map();
    this._intervals = new Map();
    this._taskQueue = new TaskQueue({ concurrency: 3 });
  }
  
  /**
   * Schedule a task to run once at a specific time
   */
  scheduleAt(task, datetime) {
    const delay = datetime.getTime() - Date.now();
    if (delay < 0) {
      throw new Error('Cannot schedule task in the past');
    }
    
    const timeoutId = setTimeout(() => {
      this._taskQueue.enqueue(task);
      this._scheduled.delete(task.id);
    }, delay);
    
    this._scheduled.set(task.id, { task, timeoutId, type: 'once', scheduledFor: datetime });
    
    return task.id;
  }
  
  /**
   * Schedule a task to run after a delay
   */
  scheduleAfter(task, delayMs) {
    const timeoutId = setTimeout(() => {
      this._taskQueue.enqueue(task);
      this._scheduled.delete(task.id);
    }, delayMs);
    
    this._scheduled.set(task.id, { 
      task, 
      timeoutId, 
      type: 'once', 
      scheduledFor: new Date(Date.now() + delayMs) 
    });
    
    return task.id;
  }
  
  /**
   * Schedule a recurring task
   */
  scheduleRecurring(taskFactory, intervalMs, options = {}) {
    const id = `recurring_${Date.now()}`;
    
    const runTask = () => {
      const task = taskFactory();
      task.id = `${id}_${Date.now()}`;
      this._taskQueue.enqueue(task);
    };
    
    // Run immediately if specified
    if (options.immediate) {
      runTask();
    }
    
    const intervalId = setInterval(runTask, intervalMs);
    
    this._intervals.set(id, { 
      intervalId, 
      intervalMs, 
      taskFactory,
      startedAt: Date.now(),
    });
    
    return id;
  }
  
  /**
   * Cancel a scheduled task
   */
  cancel(taskId) {
    // Check one-time scheduled
    if (this._scheduled.has(taskId)) {
      const { timeoutId } = this._scheduled.get(taskId);
      clearTimeout(timeoutId);
      this._scheduled.delete(taskId);
      return true;
    }
    
    // Check recurring
    if (this._intervals.has(taskId)) {
      const { intervalId } = this._intervals.get(taskId);
      clearInterval(intervalId);
      this._intervals.delete(taskId);
      return true;
    }
    
    return false;
  }
  
  /**
   * Get scheduler state
   */
  getState() {
    return {
      scheduled: Array.from(this._scheduled.values()).map(s => ({
        taskId: s.task.id,
        type: s.type,
        scheduledFor: s.scheduledFor,
      })),
      recurring: Array.from(this._intervals.entries()).map(([id, r]) => ({
        id,
        intervalMs: r.intervalMs,
        startedAt: r.startedAt,
      })),
      queue: this._taskQueue.getState(),
    };
  }
  
  getQueue() {
    return this._taskQueue;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — WORKFLOW BUILDER
// ═══════════════════════════════════════════════════════════════════════════════

class WorkflowBuilder {
  constructor(name) {
    this._name = name;
    this._steps = [];
    this._currentStepId = 0;
  }
  
  /**
   * Add a step
   */
  step(name, handler, options = {}) {
    const stepId = `step_${this._currentStepId++}`;
    this._steps.push({
      id: stepId,
      name,
      handler,
      dependencies: options.dependencies || [],
    });
    return this;
  }
  
  /**
   * Add a step that depends on previous step
   */
  then(name, handler) {
    const prevStep = this._steps[this._steps.length - 1];
    return this.step(name, handler, {
      dependencies: prevStep ? [prevStep.id] : [],
    });
  }
  
  /**
   * Add parallel steps
   */
  parallel(steps) {
    const dependencies = this._steps.length > 0 
      ? [this._steps[this._steps.length - 1].id] 
      : [];
    
    for (const step of steps) {
      this._steps.push({
        id: `step_${this._currentStepId++}`,
        name: step.name,
        handler: step.handler,
        dependencies,
      });
    }
    return this;
  }
  
  /**
   * Build the workflow task
   */
  build() {
    return new Task({
      name: this._name,
      type: TASK_TYPES.WORKFLOW,
      steps: this._steps,
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — GLOBAL TASK MANAGER
// ═══════════════════════════════════════════════════════════════════════════════

class TaskManager {
  constructor() {
    this.scheduler = new TaskScheduler();
    this._taskHistory = [];
    this._maxHistory = 100;
  }
  
  /**
   * Create and enqueue a simple task
   */
  run(name, handler, options = {}) {
    const task = new Task({
      name,
      handler,
      priority: options.priority || TASK_PRIORITY.NORMAL,
      maxRetries: options.maxRetries,
    });
    
    task.on('completed', () => this._addToHistory(task));
    task.on('failed', () => this._addToHistory(task));
    
    return this.scheduler.getQueue().enqueue(task);
  }
  
  /**
   * Run tasks in sequence
   */
  runSequential(name, steps) {
    const task = new Task({
      name,
      type: TASK_TYPES.SEQUENTIAL,
      steps: steps.map((s, i) => ({
        id: `step_${i}`,
        name: s.name,
        handler: s.handler,
      })),
    });
    
    task.on('completed', () => this._addToHistory(task));
    task.on('failed', () => this._addToHistory(task));
    
    return this.scheduler.getQueue().enqueue(task);
  }
  
  /**
   * Run tasks in parallel
   */
  runParallel(name, steps) {
    const task = new Task({
      name,
      type: TASK_TYPES.PARALLEL,
      steps: steps.map((s, i) => ({
        id: `step_${i}`,
        name: s.name,
        handler: s.handler,
      })),
    });
    
    task.on('completed', () => this._addToHistory(task));
    task.on('failed', () => this._addToHistory(task));
    
    return this.scheduler.getQueue().enqueue(task);
  }
  
  /**
   * Create a workflow
   */
  workflow(name) {
    return new WorkflowBuilder(name);
  }
  
  /**
   * Run a workflow
   */
  runWorkflow(workflow) {
    const task = workflow.build();
    
    task.on('completed', () => this._addToHistory(task));
    task.on('failed', () => this._addToHistory(task));
    
    return this.scheduler.getQueue().enqueue(task);
  }
  
  /**
   * Schedule a task
   */
  schedule(task, schedule) {
    if (schedule.at) {
      return this.scheduler.scheduleAt(task, schedule.at);
    } else if (schedule.after) {
      return this.scheduler.scheduleAfter(task, schedule.after);
    } else if (schedule.every) {
      return this.scheduler.scheduleRecurring(() => new Task(task), schedule.every, {
        immediate: schedule.immediate,
      });
    }
    throw new Error('Invalid schedule');
  }
  
  /**
   * Cancel a task
   */
  cancel(taskId) {
    return this.scheduler.cancel(taskId) || 
           (this.scheduler.getQueue().cancel(taskId), true);
  }
  
  _addToHistory(task) {
    this._taskHistory.push(task.toJSON());
    if (this._taskHistory.length > this._maxHistory) {
      this._taskHistory.shift();
    }
  }
  
  getState() {
    return {
      scheduler: this.scheduler.getState(),
      historySize: this._taskHistory.length,
    };
  }
  
  getHistory() {
    return [...this._taskHistory];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — GLOBAL INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

const globalTasks = new TaskManager();

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function runTask(name, handler, options = {}) {
  return globalTasks.run(name, handler, options);
}

function runSequential(name, steps) {
  return globalTasks.runSequential(name, steps);
}

function runParallel(name, steps) {
  return globalTasks.runParallel(name, steps);
}

function createWorkflow(name) {
  return globalTasks.workflow(name);
}

function scheduleTask(task, schedule) {
  return globalTasks.schedule(task, schedule);
}

function cancelTask(taskId) {
  return globalTasks.cancel(taskId);
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  TASK_STATUS,
  TASK_PRIORITY,
  TASK_TYPES,
  
  // Classes
  Task,
  TaskQueue,
  TaskScheduler,
  WorkflowBuilder,
  TaskManager,
  
  // Global instance
  globalTasks,
  
  // Helper functions
  runTask,
  runSequential,
  runParallel,
  createWorkflow,
  scheduleTask,
  cancelTask,
};

export default {
  TASK_STATUS,
  TASK_PRIORITY,
  TASK_TYPES,
  TaskManager,
  globalTasks,
  runTask,
  runSequential,
  runParallel,
  createWorkflow,
  scheduleTask,
  cancelTask,
};
