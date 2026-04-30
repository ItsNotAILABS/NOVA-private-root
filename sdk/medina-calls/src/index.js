/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-calls — WRITE OPERATIONS SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK handles all WRITE/MUTATION operations:
 *   - Internal calls (AI to AI, AI to backend)
 *   - External calls (User to AI, User to backend)
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;

const CALL_TYPES = {
  INTERNAL: 'INTERNAL',     // AI talking to itself or other AIs
  EXTERNAL: 'EXTERNAL',     // User/app calling the system
  CANISTER: 'CANISTER',     // Call to ICP canister
  SERVICE: 'SERVICE',       // Call to external service
};

const CALL_STATUS = {
  PENDING: 'PENDING',
  IN_PROGRESS: 'IN_PROGRESS',
  COMPLETED: 'COMPLETED',
  FAILED: 'FAILED',
  RETRYING: 'RETRYING',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — CALL RECORD
// ═══════════════════════════════════════════════════════════════════════════════

class CallRecord {
  constructor(type, method, args, source, target) {
    this.id = `call_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.type = type;
    this.method = method;
    this.args = args;
    this.source = source;
    this.target = target;
    this.status = CALL_STATUS.PENDING;
    this.createdAt = Date.now();
    this.startedAt = null;
    this.completedAt = null;
    this.result = null;
    this.error = null;
    this.retries = 0;
    this.maxRetries = 3;
  }
  
  start() {
    this.status = CALL_STATUS.IN_PROGRESS;
    this.startedAt = Date.now();
  }
  
  complete(result) {
    this.status = CALL_STATUS.COMPLETED;
    this.completedAt = Date.now();
    this.result = result;
  }
  
  fail(error) {
    this.error = error;
    if (this.retries < this.maxRetries) {
      this.status = CALL_STATUS.RETRYING;
      this.retries++;
    } else {
      this.status = CALL_STATUS.FAILED;
      this.completedAt = Date.now();
    }
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      method: this.method,
      source: this.source,
      target: this.target,
      status: this.status,
      createdAt: this.createdAt,
      startedAt: this.startedAt,
      completedAt: this.completedAt,
      duration: this.completedAt && this.startedAt 
        ? this.completedAt - this.startedAt 
        : null,
      retries: this.retries,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — CALL QUEUE
// ═══════════════════════════════════════════════════════════════════════════════

class CallQueue {
  constructor(maxSize = 512) {
    this._queue = [];
    this._maxSize = maxSize;
    this._processing = false;
    this._handlers = new Map();
  }
  
  /**
   * Register a handler for a method
   */
  registerHandler(method, handler) {
    this._handlers.set(method, handler);
  }
  
  /**
   * Enqueue a call
   */
  enqueue(call) {
    if (this._queue.length >= this._maxSize) {
      // Ring buffer behavior — drop oldest
      this._queue.shift();
    }
    this._queue.push(call);
    this._processNext();
    return call;
  }
  
  /**
   * Process next call in queue
   */
  async _processNext() {
    if (this._processing || this._queue.length === 0) return;
    
    this._processing = true;
    
    const call = this._queue.find(c => c.status === CALL_STATUS.PENDING);
    if (!call) {
      this._processing = false;
      return;
    }
    
    call.start();
    
    try {
      const handler = this._handlers.get(call.method);
      if (handler) {
        const result = await handler(...call.args);
        call.complete(result);
      } else {
        call.fail(new Error(`No handler for method: ${call.method}`));
      }
    } catch (error) {
      call.fail(error);
    }
    
    this._processing = false;
    
    // Process next
    setTimeout(() => this._processNext(), 1);
  }
  
  /**
   * Get queue state
   */
  getState() {
    return {
      size: this._queue.length,
      maxSize: this._maxSize,
      pending: this._queue.filter(c => c.status === CALL_STATUS.PENDING).length,
      inProgress: this._queue.filter(c => c.status === CALL_STATUS.IN_PROGRESS).length,
      completed: this._queue.filter(c => c.status === CALL_STATUS.COMPLETED).length,
      failed: this._queue.filter(c => c.status === CALL_STATUS.FAILED).length,
    };
  }
  
  /**
   * Get all calls
   */
  getCalls() {
    return this._queue.map(c => c.toJSON());
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — INTERNAL CALL INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════
// These are calls AIs make to themselves or other AIs

class InternalCalls {
  constructor() {
    this._queue = new CallQueue();
    this._subscribers = new Map();
  }
  
  /**
   * Make an internal call
   */
  call(method, args = [], source = 'self', target = 'self') {
    const call = new CallRecord(
      CALL_TYPES.INTERNAL,
      method,
      args,
      source,
      target
    );
    
    // Notify subscribers
    this._notifySubscribers(method, args);
    
    return this._queue.enqueue(call);
  }
  
  /**
   * Register handler
   */
  registerHandler(method, handler) {
    this._queue.registerHandler(method, handler);
  }
  
  /**
   * Subscribe to method calls
   */
  subscribe(method, callback) {
    if (!this._subscribers.has(method)) {
      this._subscribers.set(method, []);
    }
    this._subscribers.get(method).push(callback);
  }
  
  _notifySubscribers(method, args) {
    if (this._subscribers.has(method)) {
      for (const callback of this._subscribers.get(method)) {
        try {
          callback(...args);
        } catch (e) {
          console.error(`[InternalCalls] Subscriber error: ${e.message}`);
        }
      }
    }
  }
  
  getState() {
    return this._queue.getState();
  }
  
  getCalls() {
    return this._queue.getCalls();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EXTERNAL CALL INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════
// These are calls users/apps make to the system

class ExternalCalls {
  constructor() {
    this._queue = new CallQueue();
    this._authRequired = new Set();
    this._rateLimits = new Map();
    this._callCounts = new Map();
  }
  
  /**
   * Make an external call
   */
  call(method, args = [], source = 'user') {
    // Check rate limit
    if (!this._checkRateLimit(source, method)) {
      throw new Error(`Rate limit exceeded for ${method}`);
    }
    
    const call = new CallRecord(
      CALL_TYPES.EXTERNAL,
      method,
      args,
      source,
      'system'
    );
    
    return this._queue.enqueue(call);
  }
  
  /**
   * Register handler
   */
  registerHandler(method, handler, options = {}) {
    this._queue.registerHandler(method, handler);
    
    if (options.authRequired) {
      this._authRequired.add(method);
    }
    
    if (options.rateLimit) {
      this._rateLimits.set(method, options.rateLimit);
    }
  }
  
  /**
   * Check rate limit
   */
  _checkRateLimit(source, method) {
    const limit = this._rateLimits.get(method);
    if (!limit) return true;
    
    const key = `${source}:${method}`;
    const count = this._callCounts.get(key) || 0;
    
    if (count >= limit.maxCalls) {
      return false;
    }
    
    this._callCounts.set(key, count + 1);
    
    // Reset after window
    setTimeout(() => {
      this._callCounts.set(key, 0);
    }, limit.windowMs);
    
    return true;
  }
  
  getState() {
    return this._queue.getState();
  }
  
  getCalls() {
    return this._queue.getCalls();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — CANISTER CALLS (ICP)
// ═══════════════════════════════════════════════════════════════════════════════

class CanisterCalls {
  constructor() {
    this._queue = new CallQueue();
    this._canisters = new Map();
  }
  
  /**
   * Register a canister
   */
  registerCanister(canisterId, actor) {
    this._canisters.set(canisterId, actor);
  }
  
  /**
   * Call a canister method
   */
  async call(canisterId, method, args = []) {
    const call = new CallRecord(
      CALL_TYPES.CANISTER,
      method,
      args,
      'sdk',
      canisterId
    );
    
    call.start();
    
    try {
      const actor = this._canisters.get(canisterId);
      if (!actor) {
        throw new Error(`Canister not registered: ${canisterId}`);
      }
      
      const result = await actor[method](...args);
      call.complete(result);
      return result;
    } catch (error) {
      call.fail(error);
      throw error;
    }
  }
  
  getState() {
    return {
      registeredCanisters: this._canisters.size,
      ...this._queue.getState(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — GLOBAL CALLS MANAGER
// ═══════════════════════════════════════════════════════════════════════════════

class CallsManager {
  constructor() {
    this.internal = new InternalCalls();
    this.external = new ExternalCalls();
    this.canister = new CanisterCalls();
    this._allCalls = [];
  }
  
  /**
   * Make internal call
   */
  _internal(method, ...args) {
    const call = this.internal.call(method, args);
    this._allCalls.push(call);
    return call;
  }
  
  /**
   * Make external call
   */
  _external(method, ...args) {
    const call = this.external.call(method, args);
    this._allCalls.push(call);
    return call;
  }
  
  /**
   * Make canister call
   */
  async _canister(canisterId, method, ...args) {
    return this.canister.call(canisterId, method, args);
  }
  
  getState() {
    return {
      internal: this.internal.getState(),
      external: this.external.getState(),
      canister: this.canister.getState(),
      totalCalls: this._allCalls.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — GLOBAL INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

const globalCalls = new CallsManager();

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function internalCall(method, ...args) {
  return globalCalls._internal(method, ...args);
}

function externalCall(method, ...args) {
  return globalCalls._external(method, ...args);
}

async function canisterCall(canisterId, method, ...args) {
  return globalCalls._canister(canisterId, method, ...args);
}

function registerInternalHandler(method, handler) {
  globalCalls.internal.registerHandler(method, handler);
}

function registerExternalHandler(method, handler, options = {}) {
  globalCalls.external.registerHandler(method, handler, options);
}

function registerCanister(canisterId, actor) {
  globalCalls.canister.registerCanister(canisterId, actor);
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  CALL_TYPES,
  CALL_STATUS,
  
  // Classes
  CallRecord,
  CallQueue,
  InternalCalls,
  ExternalCalls,
  CanisterCalls,
  CallsManager,
  
  // Global instance
  globalCalls,
  
  // Helper functions
  internalCall,
  externalCall,
  canisterCall,
  registerInternalHandler,
  registerExternalHandler,
  registerCanister,
};

export default {
  CALL_TYPES,
  CALL_STATUS,
  CallsManager,
  globalCalls,
  internalCall,
  externalCall,
  canisterCall,
  registerInternalHandler,
  registerExternalHandler,
  registerCanister,
};
