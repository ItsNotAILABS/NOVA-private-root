/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-queries — READ OPERATIONS SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK handles all READ/QUERY operations:
 *   - Internal queries (AI querying its own state)
 *   - External queries (User querying the system)
 *   - Canister queries (Read from ICP canisters)
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

import { PHI, PHI_INV, createEntityId } from '../../medina-core/src/index.js';

const QUERY_TYPES = {
  INTERNAL: 'INTERNAL',     // AI querying itself
  EXTERNAL: 'EXTERNAL',     // User querying the system
  CANISTER: 'CANISTER',     // Query to ICP canister
  CACHE: 'CACHE',           // Query from cache
};

const QUERY_STATUS = {
  PENDING: 'PENDING',
  EXECUTING: 'EXECUTING',
  COMPLETED: 'COMPLETED',
  FAILED: 'FAILED',
  CACHED: 'CACHED',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — QUERY RECORD
// ═══════════════════════════════════════════════════════════════════════════════

class QueryRecord {
  constructor(type, path, params, source) {
    this.id = createEntityId('query');
    this.type = type;
    this.path = path;
    this.params = params;
    this.source = source;
    this.status = QUERY_STATUS.PENDING;
    this.createdAt = Date.now();
    this.executedAt = null;
    this.completedAt = null;
    this.result = null;
    this.error = null;
    this.cached = false;
    this.ttl = 60000; // 1 minute default TTL
  }
  
  execute() {
    this.status = QUERY_STATUS.EXECUTING;
    this.executedAt = Date.now();
  }
  
  complete(result, cached = false) {
    this.status = cached ? QUERY_STATUS.CACHED : QUERY_STATUS.COMPLETED;
    this.completedAt = Date.now();
    this.result = result;
    this.cached = cached;
  }
  
  fail(error) {
    this.status = QUERY_STATUS.FAILED;
    this.completedAt = Date.now();
    this.error = error;
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      path: this.path,
      source: this.source,
      status: this.status,
      createdAt: this.createdAt,
      executedAt: this.executedAt,
      completedAt: this.completedAt,
      duration: this.completedAt && this.executedAt 
        ? this.completedAt - this.executedAt 
        : null,
      cached: this.cached,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — QUERY CACHE
// ═══════════════════════════════════════════════════════════════════════════════

class QueryCache {
  constructor(maxSize = 1000) {
    this._cache = new Map();
    this._maxSize = maxSize;
    this._hits = 0;
    this._misses = 0;
  }
  
  /**
   * Get from cache
   */
  get(key) {
    const entry = this._cache.get(key);
    
    if (!entry) {
      this._misses++;
      return null;
    }
    
    // Check TTL
    if (Date.now() > entry.expiresAt) {
      this._cache.delete(key);
      this._misses++;
      return null;
    }
    
    this._hits++;
    entry.accessCount++;
    entry.lastAccessed = Date.now();
    
    return entry.value;
  }
  
  /**
   * Set in cache
   */
  set(key, value, ttl = 60000) {
    // Evict if full
    if (this._cache.size >= this._maxSize) {
      this._evictOldest();
    }
    
    this._cache.set(key, {
      value,
      createdAt: Date.now(),
      expiresAt: Date.now() + ttl,
      lastAccessed: Date.now(),
      accessCount: 0,
    });
  }
  
  /**
   * Invalidate cache entry
   */
  invalidate(key) {
    this._cache.delete(key);
  }
  
  /**
   * Invalidate all entries matching pattern
   */
  invalidatePattern(pattern) {
    for (const key of this._cache.keys()) {
      if (key.includes(pattern)) {
        this._cache.delete(key);
      }
    }
  }
  
  /**
   * Clear all cache
   */
  clear() {
    this._cache.clear();
  }
  
  /**
   * Evict oldest entry
   */
  _evictOldest() {
    let oldest = null;
    let oldestKey = null;
    
    for (const [key, entry] of this._cache) {
      if (!oldest || entry.lastAccessed < oldest.lastAccessed) {
        oldest = entry;
        oldestKey = key;
      }
    }
    
    if (oldestKey) {
      this._cache.delete(oldestKey);
    }
  }
  
  getState() {
    return {
      size: this._cache.size,
      maxSize: this._maxSize,
      hits: this._hits,
      misses: this._misses,
      hitRate: this._hits + this._misses > 0 
        ? this._hits / (this._hits + this._misses) 
        : 0,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — QUERY EXECUTOR
// ═══════════════════════════════════════════════════════════════════════════════

class QueryExecutor {
  constructor() {
    this._handlers = new Map();
    this._cache = new QueryCache();
    this._history = [];
    this._maxHistory = 100;
  }
  
  /**
   * Register a query handler
   */
  register(path, handler, options = {}) {
    this._handlers.set(path, {
      handler,
      cacheable: options.cacheable !== false,
      ttl: options.ttl || 60000,
    });
  }
  
  /**
   * Execute a query
   */
  async execute(query) {
    // Check cache first
    if (this._isCacheable(query.path)) {
      const cacheKey = this._getCacheKey(query);
      const cached = this._cache.get(cacheKey);
      
      if (cached !== null) {
        query.complete(cached, true);
        this._addToHistory(query);
        return cached;
      }
    }
    
    query.execute();
    
    try {
      const handlerDef = this._handlers.get(query.path);
      
      if (!handlerDef) {
        throw new Error(`No handler for query path: ${query.path}`);
      }
      
      const result = await handlerDef.handler(query.params);
      query.complete(result);
      
      // Cache result
      if (handlerDef.cacheable) {
        const cacheKey = this._getCacheKey(query);
        this._cache.set(cacheKey, result, handlerDef.ttl);
      }
      
      this._addToHistory(query);
      return result;
    } catch (error) {
      query.fail(error);
      this._addToHistory(query);
      throw error;
    }
  }
  
  _isCacheable(path) {
    const handlerDef = this._handlers.get(path);
    return handlerDef && handlerDef.cacheable;
  }
  
  _getCacheKey(query) {
    return `${query.path}:${JSON.stringify(query.params)}`;
  }
  
  _addToHistory(query) {
    this._history.push(query.toJSON());
    if (this._history.length > this._maxHistory) {
      this._history.shift();
    }
  }
  
  /**
   * Invalidate cache for path
   */
  invalidate(path) {
    this._cache.invalidatePattern(path);
  }
  
  getState() {
    return {
      registeredHandlers: this._handlers.size,
      cache: this._cache.getState(),
      historySize: this._history.length,
    };
  }
  
  getHistory() {
    return [...this._history];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — INTERNAL QUERIES
// ═══════════════════════════════════════════════════════════════════════════════
// Queries the AI makes about its own state

class InternalQueries {
  constructor() {
    this._executor = new QueryExecutor();
    this._stateProviders = new Map();
  }
  
  /**
   * Register a state provider
   */
  registerStateProvider(key, provider) {
    this._stateProviders.set(key, provider);
    
    // Register as query handler
    this._executor.register(`state:${key}`, async (params) => {
      return provider(params);
    }, { cacheable: false }); // State queries are not cached
  }
  
  /**
   * Query internal state
   */
  async query(path, params = {}) {
    const query = new QueryRecord(
      QUERY_TYPES.INTERNAL,
      path,
      params,
      'internal'
    );
    
    return this._executor.execute(query);
  }
  
  /**
   * Get state directly
   */
  getState(key) {
    const provider = this._stateProviders.get(key);
    if (provider) {
      return provider();
    }
    return null;
  }
  
  /**
   * Get all state
   */
  getAllState() {
    const state = {};
    for (const [key, provider] of this._stateProviders) {
      state[key] = provider();
    }
    return state;
  }
  
  getStats() {
    return this._executor.getState();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — EXTERNAL QUERIES
// ═══════════════════════════════════════════════════════════════════════════════
// Queries users/apps make to the system

class ExternalQueries {
  constructor() {
    this._executor = new QueryExecutor();
    this._authRequired = new Set();
  }
  
  /**
   * Register a query handler
   */
  register(path, handler, options = {}) {
    this._executor.register(path, handler, options);
    
    if (options.authRequired) {
      this._authRequired.add(path);
    }
  }
  
  /**
   * Execute query
   */
  async query(path, params = {}, source = 'user') {
    const query = new QueryRecord(
      QUERY_TYPES.EXTERNAL,
      path,
      params,
      source
    );
    
    return this._executor.execute(query);
  }
  
  /**
   * Check if path requires auth
   */
  requiresAuth(path) {
    return this._authRequired.has(path);
  }
  
  /**
   * Invalidate cache
   */
  invalidate(path) {
    this._executor.invalidate(path);
  }
  
  getStats() {
    return this._executor.getState();
  }
  
  getHistory() {
    return this._executor.getHistory();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — CANISTER QUERIES
// ═══════════════════════════════════════════════════════════════════════════════
// Queries to ICP canisters

class CanisterQueries {
  constructor() {
    this._canisters = new Map();
    this._cache = new QueryCache();
    this._history = [];
  }
  
  /**
   * Register a canister
   */
  registerCanister(canisterId, actor) {
    this._canisters.set(canisterId, actor);
  }
  
  /**
   * Query a canister
   */
  async query(canisterId, method, params = [], options = {}) {
    const query = new QueryRecord(
      QUERY_TYPES.CANISTER,
      `${canisterId}:${method}`,
      params,
      'sdk'
    );
    
    // Check cache
    if (options.cache !== false) {
      const cacheKey = `${canisterId}:${method}:${JSON.stringify(params)}`;
      const cached = this._cache.get(cacheKey);
      
      if (cached !== null) {
        query.complete(cached, true);
        this._history.push(query.toJSON());
        return cached;
      }
    }
    
    query.execute();
    
    try {
      const actor = this._canisters.get(canisterId);
      if (!actor) {
        throw new Error(`Canister not registered: ${canisterId}`);
      }
      
      const result = await actor[method](...params);
      query.complete(result);
      
      // Cache if enabled
      if (options.cache !== false) {
        const cacheKey = `${canisterId}:${method}:${JSON.stringify(params)}`;
        this._cache.set(cacheKey, result, options.ttl || 60000);
      }
      
      this._history.push(query.toJSON());
      return result;
    } catch (error) {
      query.fail(error);
      this._history.push(query.toJSON());
      throw error;
    }
  }
  
  /**
   * Invalidate cache for canister
   */
  invalidate(canisterId) {
    this._cache.invalidatePattern(canisterId);
  }
  
  getStats() {
    return {
      registeredCanisters: this._canisters.size,
      cache: this._cache.getState(),
      historySize: this._history.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — GLOBAL QUERIES MANAGER
// ═══════════════════════════════════════════════════════════════════════════════

class QueriesManager {
  constructor() {
    this.internal = new InternalQueries();
    this.external = new ExternalQueries();
    this.canister = new CanisterQueries();
  }
  
  /**
   * Internal query shorthand
   */
  async _internal(path, params = {}) {
    return this.internal.query(path, params);
  }
  
  /**
   * External query shorthand
   */
  async _external(path, params = {}) {
    return this.external.query(path, params);
  }
  
  /**
   * Canister query shorthand
   */
  async _canister(canisterId, method, params = []) {
    return this.canister.query(canisterId, method, params);
  }
  
  getState() {
    return {
      internal: this.internal.getStats(),
      external: this.external.getStats(),
      canister: this.canister.getStats(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — GLOBAL INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

const globalQueries = new QueriesManager();

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

async function internalQuery(path, params = {}) {
  return globalQueries._internal(path, params);
}

async function externalQuery(path, params = {}) {
  return globalQueries._external(path, params);
}

async function canisterQuery(canisterId, method, params = []) {
  return globalQueries._canister(canisterId, method, params);
}

function registerInternalStateProvider(key, provider) {
  globalQueries.internal.registerStateProvider(key, provider);
}

function registerExternalQueryHandler(path, handler, options = {}) {
  globalQueries.external.register(path, handler, options);
}

function registerCanister(canisterId, actor) {
  globalQueries.canister.registerCanister(canisterId, actor);
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  QUERY_TYPES,
  QUERY_STATUS,
  
  // Classes
  QueryRecord,
  QueryCache,
  QueryExecutor,
  InternalQueries,
  ExternalQueries,
  CanisterQueries,
  QueriesManager,
  
  // Global instance
  globalQueries,
  
  // Helper functions
  internalQuery,
  externalQuery,
  canisterQuery,
  registerInternalStateProvider,
  registerExternalQueryHandler,
  registerCanister,
};

export default {
  QUERY_TYPES,
  QUERY_STATUS,
  QueriesManager,
  globalQueries,
  internalQuery,
  externalQuery,
  canisterQuery,
  registerInternalStateProvider,
  registerExternalQueryHandler,
  registerCanister,
};
