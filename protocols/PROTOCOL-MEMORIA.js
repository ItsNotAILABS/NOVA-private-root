/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-MEMORIA — MEMORY PERSISTENCE PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * The MEMORIA protocol handles storage, retrieval, and consolidation of memories.
 * Like biological memory systems, it supports different memory types with different
 * persistence and retrieval characteristics.
 * 
 * Biological Inspiration:
 *   - Working memory (temporary, limited capacity)
 *   - Long-term memory (persistent, unlimited)
 *   - Sleep consolidation (transfer and strengthen)
 *   - Forgetting curve (Ebbinghaus decay)
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const MEMORY_TIERS = {
  SENSORY: 'SENSORY',         // Milliseconds
  WORKING: 'WORKING',         // Seconds to minutes
  SHORT_TERM: 'SHORT_TERM',   // Minutes to hours
  LONG_TERM: 'LONG_TERM',     // Days to years
  PERMANENT: 'PERMANENT',     // Forever
};

const ENCODING_TYPES = {
  RAW: 'RAW',
  COMPRESSED: 'COMPRESSED',
  SEMANTIC: 'SEMANTIC',
  PROCEDURAL: 'PROCEDURAL',
};

const CONSOLIDATION_STATES = {
  ENCODING: 'ENCODING',
  STABILIZING: 'STABILIZING',
  INTEGRATING: 'INTEGRATING',
  CONSOLIDATED: 'CONSOLIDATED',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — MEMORY TRACE
// ═══════════════════════════════════════════════════════════════════════════════

class MemoryTrace {
  constructor(content, config = {}) {
    this.id = config.id || `mem_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.content = content;
    this.tier = config.tier || MEMORY_TIERS.WORKING;
    this.encoding = config.encoding || ENCODING_TYPES.RAW;
    
    this.strength = config.strength || 1.0;
    this.importance = config.importance || 0.5;
    this.emotionalValence = config.emotionalValence || 0;
    
    this.associations = new Set(config.associations || []);
    this.tags = new Set(config.tags || []);
    this.context = config.context || {};
    
    this.createdAt = Date.now();
    this.accessedAt = Date.now();
    this.consolidatedAt = null;
    this.accessCount = 0;
    
    this._decayConstant = this._calculateDecayConstant();
    this._consolidationState = null;
  }
  
  /**
   * Calculate decay constant based on tier
   */
  _calculateDecayConstant() {
    switch (this.tier) {
      case MEMORY_TIERS.SENSORY:
        return 0.5;
      case MEMORY_TIERS.WORKING:
        return 0.1;
      case MEMORY_TIERS.SHORT_TERM:
        return 0.01;
      case MEMORY_TIERS.LONG_TERM:
        return 0.001;
      case MEMORY_TIERS.PERMANENT:
        return 0;
      default:
        return 0.01;
    }
  }
  
  /**
   * Access the memory (strengthens it)
   */
  access() {
    this.accessedAt = Date.now();
    this.accessCount++;
    
    // Spacing effect - more time since last access = stronger reinforcement
    const timeSinceCreation = Date.now() - this.createdAt;
    const reinforcement = Math.log(timeSinceCreation / 1000 + 1) * PHI_INV * 0.05;
    this.strength = Math.min(1.0, this.strength + reinforcement);
    
    return this.content;
  }
  
  /**
   * Apply decay (Ebbinghaus forgetting curve)
   */
  decay() {
    if (this.tier === MEMORY_TIERS.PERMANENT) return this;
    
    const timeSinceAccess = Date.now() - this.accessedAt;
    const decayFactor = Math.exp(-this._decayConstant * timeSinceAccess / 1000);
    this.strength = this.strength * decayFactor;
    
    return this;
  }
  
  /**
   * Calculate retention probability
   */
  getRetention() {
    const timeSinceAccess = Date.now() - this.accessedAt;
    return Math.exp(-this._decayConstant * timeSinceAccess / 1000) * this.strength;
  }
  
  /**
   * Add association
   */
  associate(memoryId) {
    this.associations.add(memoryId);
    return this;
  }
  
  /**
   * Add tag
   */
  tag(tagName) {
    this.tags.add(tagName);
    return this;
  }
  
  /**
   * Promote to higher tier
   */
  promote() {
    const tiers = Object.values(MEMORY_TIERS);
    const currentIndex = tiers.indexOf(this.tier);
    if (currentIndex < tiers.length - 1) {
      this.tier = tiers[currentIndex + 1];
      this._decayConstant = this._calculateDecayConstant();
      this.strength = Math.min(1.0, this.strength * PHI);
    }
    return this;
  }
  
  /**
   * Mark as consolidated
   */
  consolidate() {
    this.consolidatedAt = Date.now();
    this._consolidationState = CONSOLIDATION_STATES.CONSOLIDATED;
    this.strength = Math.min(1.0, this.strength * PHI);
    return this;
  }
  
  toJSON() {
    return {
      id: this.id,
      content: this.content,
      tier: this.tier,
      encoding: this.encoding,
      strength: this.strength,
      importance: this.importance,
      emotionalValence: this.emotionalValence,
      associations: Array.from(this.associations),
      tags: Array.from(this.tags),
      accessCount: this.accessCount,
      retention: this.getRetention(),
      createdAt: this.createdAt,
      accessedAt: this.accessedAt,
      consolidatedAt: this.consolidatedAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — MEMORY STORE
// ═══════════════════════════════════════════════════════════════════════════════

class MemoryStore {
  constructor(config = {}) {
    this._memories = new Map();
    this._tagIndex = new Map();
    this._tierIndex = new Map();
    
    this.capacities = config.capacities || {
      [MEMORY_TIERS.SENSORY]: 100,
      [MEMORY_TIERS.WORKING]: 7,
      [MEMORY_TIERS.SHORT_TERM]: 100,
      [MEMORY_TIERS.LONG_TERM]: 10000,
      [MEMORY_TIERS.PERMANENT]: Infinity,
    };
    
    // Initialize tier indexes
    for (const tier of Object.values(MEMORY_TIERS)) {
      this._tierIndex.set(tier, new Set());
    }
  }
  
  /**
   * Store a memory
   */
  store(content, config = {}) {
    const memory = new MemoryTrace(content, config);
    
    // Check capacity
    this._enforceCapacity(memory.tier);
    
    this._memories.set(memory.id, memory);
    this._tierIndex.get(memory.tier).add(memory.id);
    
    // Index by tags
    for (const tag of memory.tags) {
      if (!this._tagIndex.has(tag)) {
        this._tagIndex.set(tag, new Set());
      }
      this._tagIndex.get(tag).add(memory.id);
    }
    
    return memory;
  }
  
  /**
   * Retrieve a memory by ID
   */
  retrieve(id) {
    const memory = this._memories.get(id);
    if (!memory) return null;
    
    // Check if forgotten
    if (memory.getRetention() < 0.1 && memory.tier !== MEMORY_TIERS.PERMANENT) {
      this._forget(id);
      return null;
    }
    
    return memory.access();
  }
  
  /**
   * Search memories
   */
  search(query, options = {}) {
    const results = [];
    const queryLower = query.toLowerCase();
    
    for (const memory of this._memories.values()) {
      // Skip if forgotten
      if (memory.getRetention() < 0.1 && memory.tier !== MEMORY_TIERS.PERMANENT) {
        continue;
      }
      
      // Search content
      const content = typeof memory.content === 'string'
        ? memory.content.toLowerCase()
        : JSON.stringify(memory.content).toLowerCase();
      
      if (content.includes(queryLower) || 
          Array.from(memory.tags).some(t => t.toLowerCase().includes(queryLower))) {
        memory.access();
        results.push(memory);
      }
    }
    
    // Sort by relevance (strength * importance * retention)
    results.sort((a, b) => {
      const scoreA = a.strength * a.importance * a.getRetention();
      const scoreB = b.strength * b.importance * b.getRetention();
      return scoreB - scoreA;
    });
    
    return options.limit ? results.slice(0, options.limit) : results;
  }
  
  /**
   * Get memories by tag
   */
  getByTag(tag) {
    const ids = this._tagIndex.get(tag);
    if (!ids) return [];
    
    return Array.from(ids)
      .map(id => this._memories.get(id))
      .filter(m => m && m.getRetention() >= 0.1);
  }
  
  /**
   * Get memories by tier
   */
  getByTier(tier) {
    const ids = this._tierIndex.get(tier);
    if (!ids) return [];
    
    return Array.from(ids)
      .map(id => this._memories.get(id))
      .filter(m => m);
  }
  
  /**
   * Get associated memories
   */
  getAssociated(memoryId, depth = 1) {
    const memory = this._memories.get(memoryId);
    if (!memory) return [];
    
    const associated = [];
    const visited = new Set([memoryId]);
    
    const traverse = (associations, currentDepth) => {
      if (currentDepth > depth) return;
      
      for (const assocId of associations) {
        if (visited.has(assocId)) continue;
        visited.add(assocId);
        
        const assocMemory = this._memories.get(assocId);
        if (assocMemory && assocMemory.getRetention() >= 0.1) {
          associated.push({ memory: assocMemory, depth: currentDepth });
          traverse(assocMemory.associations, currentDepth + 1);
        }
      }
    };
    
    traverse(memory.associations, 1);
    return associated;
  }
  
  /**
   * Forget a memory
   */
  _forget(id) {
    const memory = this._memories.get(id);
    if (!memory) return;
    
    // Remove from indexes
    this._tierIndex.get(memory.tier)?.delete(id);
    for (const tag of memory.tags) {
      this._tagIndex.get(tag)?.delete(id);
    }
    
    this._memories.delete(id);
  }
  
  /**
   * Enforce capacity limits
   */
  _enforceCapacity(tier) {
    const capacity = this.capacities[tier];
    const tierMemories = this._tierIndex.get(tier);
    
    while (tierMemories.size >= capacity) {
      // Find weakest memory
      let weakest = null;
      let weakestScore = Infinity;
      
      for (const id of tierMemories) {
        const memory = this._memories.get(id);
        if (memory) {
          const score = memory.strength * memory.importance * memory.getRetention();
          if (score < weakestScore) {
            weakestScore = score;
            weakest = id;
          }
        }
      }
      
      if (weakest) {
        this._forget(weakest);
      } else {
        break;
      }
    }
  }
  
  /**
   * Apply decay to all memories
   */
  applyDecay() {
    for (const memory of this._memories.values()) {
      memory.decay();
    }
    return this;
  }
  
  /**
   * Clean up forgotten memories
   */
  cleanup() {
    const forgotten = [];
    
    for (const [id, memory] of this._memories) {
      if (memory.getRetention() < 0.1 && memory.tier !== MEMORY_TIERS.PERMANENT) {
        forgotten.push(id);
      }
    }
    
    for (const id of forgotten) {
      this._forget(id);
    }
    
    return forgotten.length;
  }
  
  getStats() {
    const byTier = {};
    for (const tier of Object.values(MEMORY_TIERS)) {
      byTier[tier] = this._tierIndex.get(tier)?.size || 0;
    }
    
    return {
      totalMemories: this._memories.size,
      tagCount: this._tagIndex.size,
      byTier,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — MEMORIA PROTOCOL
// ═══════════════════════════════════════════════════════════════════════════════

class MemoriaProtocol {
  constructor(config = {}) {
    this.store = new MemoryStore(config);
    
    this._consolidationQueue = [];
    this._isConsolidating = false;
    
    this._decayInterval = null;
    this._cleanupInterval = null;
    this._running = false;
    
    this._stats = {
      memoriesStored: 0,
      memoriesRetrieved: 0,
      memoriesConsolidated: 0,
      memoriesForgotten: 0,
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.1 — BASIC OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Remember something
   */
  remember(content, config = {}) {
    const memory = this.store.store(content, config);
    this._stats.memoriesStored++;
    return memory;
  }
  
  /**
   * Recall a memory by ID
   */
  recall(id) {
    const content = this.store.retrieve(id);
    if (content) {
      this._stats.memoriesRetrieved++;
    }
    return content;
  }
  
  /**
   * Search memories
   */
  search(query, options = {}) {
    const results = this.store.search(query, options);
    this._stats.memoriesRetrieved += results.length;
    return results;
  }
  
  /**
   * Get by tag
   */
  getByTag(tag) {
    return this.store.getByTag(tag);
  }
  
  /**
   * Associate two memories
   */
  associate(memoryIdA, memoryIdB) {
    const memoryA = this.store._memories.get(memoryIdA);
    const memoryB = this.store._memories.get(memoryIdB);
    
    if (memoryA && memoryB) {
      memoryA.associate(memoryIdB);
      memoryB.associate(memoryIdA);
    }
    
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.2 — CONSOLIDATION (SLEEP)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Queue memory for consolidation
   */
  queueForConsolidation(memoryId) {
    if (!this._consolidationQueue.includes(memoryId)) {
      this._consolidationQueue.push(memoryId);
    }
    return this;
  }
  
  /**
   * Run consolidation (like sleeping)
   */
  async consolidate() {
    if (this._isConsolidating) return [];
    this._isConsolidating = true;
    
    const consolidated = [];
    
    try {
      // Get memories ready for consolidation
      const candidates = this._consolidationQueue.length > 0
        ? this._consolidationQueue.splice(0)
        : this._getConsolidationCandidates();
      
      for (const id of candidates) {
        const memory = this.store._memories.get(id);
        if (!memory) continue;
        
        // Phase 1: Stabilization
        memory._consolidationState = CONSOLIDATION_STATES.STABILIZING;
        memory.strength = Math.min(1.0, memory.strength * 1.1);
        
        // Phase 2: Integration - find and strengthen associations
        memory._consolidationState = CONSOLIDATION_STATES.INTEGRATING;
        const related = this.store.search(
          typeof memory.content === 'string' ? memory.content : JSON.stringify(memory.content),
          { limit: 5 }
        );
        
        for (const relatedMemory of related) {
          if (relatedMemory.id !== memory.id) {
            memory.associate(relatedMemory.id);
            relatedMemory.associate(memory.id);
          }
        }
        
        // Phase 3: Consolidate
        memory.consolidate();
        
        // Promote if strong enough
        if (memory.strength > 0.7 && memory.accessCount > 3) {
          memory.promote();
        }
        
        consolidated.push(memory);
        this._stats.memoriesConsolidated++;
      }
    } finally {
      this._isConsolidating = false;
    }
    
    return consolidated;
  }
  
  /**
   * Get memories that should be consolidated
   */
  _getConsolidationCandidates() {
    const candidates = [];
    
    // Working and short-term memories with high importance/access
    for (const tier of [MEMORY_TIERS.WORKING, MEMORY_TIERS.SHORT_TERM]) {
      const memories = this.store.getByTier(tier);
      
      for (const memory of memories) {
        if (memory.accessCount > 2 || memory.importance > 0.7) {
          candidates.push(memory.id);
        }
      }
    }
    
    return candidates;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.3 — LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Start memory maintenance
   */
  start() {
    if (this._running) return this;
    this._running = true;
    
    // Decay interval (every ~30 heartbeats)
    this._decayInterval = setInterval(() => {
      this.store.applyDecay();
    }, HEARTBEAT_MS * 30);
    
    // Cleanup interval (every ~100 heartbeats)
    this._cleanupInterval = setInterval(() => {
      const forgotten = this.store.cleanup();
      this._stats.memoriesForgotten += forgotten;
    }, HEARTBEAT_MS * 100);
    
    return this;
  }
  
  /**
   * Stop memory maintenance
   */
  stop() {
    this._running = false;
    
    if (this._decayInterval) {
      clearInterval(this._decayInterval);
      this._decayInterval = null;
    }
    
    if (this._cleanupInterval) {
      clearInterval(this._cleanupInterval);
      this._cleanupInterval = null;
    }
    
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.4 — STATS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  getStats() {
    return {
      running: this._running,
      isConsolidating: this._isConsolidating,
      consolidationQueueSize: this._consolidationQueue.length,
      store: this.store.getStats(),
      ...this._stats,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  MEMORY_TIERS,
  ENCODING_TYPES,
  CONSOLIDATION_STATES,
  
  // Classes
  MemoryTrace,
  MemoryStore,
  MemoriaProtocol,
};

export default MemoriaProtocol;
