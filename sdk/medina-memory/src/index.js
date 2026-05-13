/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-memory — PERSISTENT MEMORY SYSTEMS SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides sophisticated memory systems for AI entities:
 *   - Short-term memory (working memory)
 *   - Long-term memory (persistent storage)
 *   - Episodic memory (experiences)
 *   - Semantic memory (knowledge)
 *   - Procedural memory (skills/how-to)
 *   - Memory consolidation (sleep-like processing)
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const MEMORY_TYPES = {
  SHORT_TERM: 'SHORT_TERM',       // Working memory, temporary
  LONG_TERM: 'LONG_TERM',         // Persistent memory
  EPISODIC: 'EPISODIC',           // Experiences and events
  SEMANTIC: 'SEMANTIC',           // Facts and knowledge
  PROCEDURAL: 'PROCEDURAL',       // Skills and procedures
};

const MEMORY_STATUS = {
  ACTIVE: 'ACTIVE',               // Currently in use
  STORED: 'STORED',               // Persisted
  CONSOLIDATING: 'CONSOLIDATING', // Being processed
  DECAYING: 'DECAYING',           // Fading away
  ARCHIVED: 'ARCHIVED',           // Long-term archive
};

const CONSOLIDATION_PHASES = {
  ENCODING: 'ENCODING',           // Initial encoding
  STABILIZATION: 'STABILIZATION', // Making stable
  INTEGRATION: 'INTEGRATION',     // Connecting to other memories
  RETRIEVAL_PRACTICE: 'RETRIEVAL_PRACTICE', // Strengthening pathways
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — MEMORY ITEM
// ═══════════════════════════════════════════════════════════════════════════════

class MemoryItem {
  constructor(config) {
    this.id = config.id || `mem_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.type = config.type || MEMORY_TYPES.SHORT_TERM;
    this.content = config.content;
    this.tags = config.tags || [];
    this.associations = config.associations || [];
    
    this.status = MEMORY_STATUS.ACTIVE;
    this.strength = config.strength || 1.0;
    this.importance = config.importance || 0.5;
    this.emotionalValence = config.emotionalValence || 0; // -1 to 1
    
    this.createdAt = Date.now();
    this.accessedAt = Date.now();
    this.accessCount = 0;
    this.consolidatedAt = null;
    
    this._decayRate = config.decayRate || 0.01;
  }
  
  /**
   * Access this memory (strengthens it)
   */
  access() {
    this.accessedAt = Date.now();
    this.accessCount++;
    
    // Accessing strengthens memory (spacing effect)
    const timeSinceCreation = Date.now() - this.createdAt;
    const strengthBoost = PHI_INV * Math.log(timeSinceCreation / 1000 + 1) * 0.1;
    this.strength = Math.min(1.0, this.strength + strengthBoost);
    
    return this;
  }
  
  /**
   * Apply decay to this memory
   */
  decay() {
    // Forgetting curve (Ebbinghaus)
    const timeSinceAccess = Date.now() - this.accessedAt;
    const decayFactor = Math.exp(-this._decayRate * timeSinceAccess / 1000);
    this.strength = this.strength * decayFactor;
    
    if (this.strength < 0.1) {
      this.status = MEMORY_STATUS.DECAYING;
    }
    
    return this;
  }
  
  /**
   * Add association to another memory
   */
  associate(memoryId, strength = 0.5) {
    const existing = this.associations.find(a => a.id === memoryId);
    if (existing) {
      existing.strength = Math.min(1.0, existing.strength + strength);
    } else {
      this.associations.push({ id: memoryId, strength });
    }
    return this;
  }
  
  /**
   * Mark as consolidated
   */
  consolidate() {
    this.consolidatedAt = Date.now();
    this.status = MEMORY_STATUS.STORED;
    // Consolidation strengthens memory
    this.strength = Math.min(1.0, this.strength * PHI);
    return this;
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      content: this.content,
      tags: this.tags,
      associations: this.associations,
      status: this.status,
      strength: this.strength,
      importance: this.importance,
      emotionalValence: this.emotionalValence,
      createdAt: this.createdAt,
      accessedAt: this.accessedAt,
      accessCount: this.accessCount,
      consolidatedAt: this.consolidatedAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — SHORT-TERM MEMORY (WORKING MEMORY)
// ═══════════════════════════════════════════════════════════════════════════════

class ShortTermMemory {
  constructor(config = {}) {
    this.capacity = config.capacity || 7; // Miller's Law: 7±2 items
    this._items = [];
  }
  
  /**
   * Add item to working memory
   */
  add(content, tags = []) {
    const item = new MemoryItem({
      type: MEMORY_TYPES.SHORT_TERM,
      content,
      tags,
      decayRate: 0.1, // Faster decay for short-term
    });
    
    this._items.unshift(item);
    
    // Capacity limit - oldest items pushed out
    while (this._items.length > this.capacity) {
      this._items.pop();
    }
    
    return item;
  }
  
  /**
   * Get all items in working memory
   */
  getAll() {
    return this._items;
  }
  
  /**
   * Get item by ID
   */
  get(id) {
    return this._items.find(item => item.id === id);
  }
  
  /**
   * Search working memory
   */
  search(query) {
    const queryLower = query.toLowerCase();
    return this._items.filter(item => {
      const content = typeof item.content === 'string' 
        ? item.content.toLowerCase() 
        : JSON.stringify(item.content).toLowerCase();
      return content.includes(queryLower) || 
             item.tags.some(tag => tag.toLowerCase().includes(queryLower));
    });
  }
  
  /**
   * Clear working memory
   */
  clear() {
    this._items = [];
    return this;
  }
  
  /**
   * Get items ready for consolidation
   */
  getForConsolidation() {
    return this._items.filter(item => 
      item.accessCount > 2 || item.importance > 0.7
    );
  }
  
  getState() {
    return {
      capacity: this.capacity,
      used: this._items.length,
      items: this._items.map(i => i.toJSON()),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — LONG-TERM MEMORY
// ═══════════════════════════════════════════════════════════════════════════════

class LongTermMemory {
  constructor(config = {}) {
    this._episodic = new Map();   // Experiences
    this._semantic = new Map();   // Knowledge
    this._procedural = new Map(); // Skills
    this._index = new Map();      // Tag index for fast lookup
  }
  
  /**
   * Store a memory
   */
  store(item) {
    const target = this._getStore(item.type);
    target.set(item.id, item);
    
    // Index by tags
    for (const tag of item.tags) {
      if (!this._index.has(tag)) {
        this._index.set(tag, new Set());
      }
      this._index.get(tag).add(item.id);
    }
    
    item.status = MEMORY_STATUS.STORED;
    return item;
  }
  
  /**
   * Retrieve a memory by ID
   */
  retrieve(id) {
    for (const store of [this._episodic, this._semantic, this._procedural]) {
      if (store.has(id)) {
        const item = store.get(id);
        item.access();
        return item;
      }
    }
    return null;
  }
  
  /**
   * Search long-term memory
   */
  search(query, options = {}) {
    const results = [];
    const queryLower = query.toLowerCase();
    const stores = options.types 
      ? options.types.map(t => this._getStore(t))
      : [this._episodic, this._semantic, this._procedural];
    
    for (const store of stores) {
      for (const item of store.values()) {
        const content = typeof item.content === 'string'
          ? item.content.toLowerCase()
          : JSON.stringify(item.content).toLowerCase();
        
        if (content.includes(queryLower) || 
            item.tags.some(tag => tag.toLowerCase().includes(queryLower))) {
          results.push(item);
        }
      }
    }
    
    // Sort by relevance (strength * importance)
    results.sort((a, b) => (b.strength * b.importance) - (a.strength * a.importance));
    
    // Access each result (strengthens)
    for (const item of results) {
      item.access();
    }
    
    return options.limit ? results.slice(0, options.limit) : results;
  }
  
  /**
   * Search by tag
   */
  searchByTag(tag) {
    if (!this._index.has(tag)) return [];
    
    const ids = this._index.get(tag);
    const results = [];
    
    for (const id of ids) {
      const item = this.retrieve(id);
      if (item) results.push(item);
    }
    
    return results;
  }
  
  /**
   * Get associated memories
   */
  getAssociated(memoryId, depth = 1) {
    const item = this.retrieve(memoryId);
    if (!item) return [];
    
    const associated = [];
    const visited = new Set([memoryId]);
    
    const traverse = (associations, currentDepth) => {
      if (currentDepth > depth) return;
      
      for (const assoc of associations) {
        if (visited.has(assoc.id)) continue;
        visited.add(assoc.id);
        
        const assocItem = this.retrieve(assoc.id);
        if (assocItem) {
          associated.push({ item: assocItem, strength: assoc.strength, depth: currentDepth });
          traverse(assocItem.associations, currentDepth + 1);
        }
      }
    };
    
    traverse(item.associations, 1);
    return associated;
  }
  
  /**
   * Apply decay to all memories
   */
  applyDecay() {
    for (const store of [this._episodic, this._semantic, this._procedural]) {
      for (const item of store.values()) {
        item.decay();
      }
    }
    return this;
  }
  
  /**
   * Archive old memories
   */
  archive() {
    const archived = [];
    
    for (const store of [this._episodic, this._semantic, this._procedural]) {
      for (const [id, item] of store.entries()) {
        if (item.status === MEMORY_STATUS.DECAYING && item.strength < 0.05) {
          item.status = MEMORY_STATUS.ARCHIVED;
          archived.push(item);
        }
      }
    }
    
    return archived;
  }
  
  _getStore(type) {
    switch (type) {
      case MEMORY_TYPES.EPISODIC: return this._episodic;
      case MEMORY_TYPES.SEMANTIC: return this._semantic;
      case MEMORY_TYPES.PROCEDURAL: return this._procedural;
      default: return this._semantic;
    }
  }
  
  getStats() {
    return {
      episodic: this._episodic.size,
      semantic: this._semantic.size,
      procedural: this._procedural.size,
      totalTags: this._index.size,
      total: this._episodic.size + this._semantic.size + this._procedural.size,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — MEMORY CONSOLIDATOR
// ═══════════════════════════════════════════════════════════════════════════════

class MemoryConsolidator {
  constructor(shortTermMemory, longTermMemory) {
    this.shortTerm = shortTermMemory;
    this.longTerm = longTermMemory;
    this._consolidationQueue = [];
    this._phase = null;
  }
  
  /**
   * Begin consolidation process (like sleep)
   */
  async consolidate() {
    // Get memories ready for consolidation
    const toConsolidate = this.shortTerm.getForConsolidation();
    this._consolidationQueue = [...toConsolidate];
    
    const results = [];
    
    for (const item of this._consolidationQueue) {
      // Phase 1: Encoding
      this._phase = CONSOLIDATION_PHASES.ENCODING;
      await this._encode(item);
      
      // Phase 2: Stabilization
      this._phase = CONSOLIDATION_PHASES.STABILIZATION;
      await this._stabilize(item);
      
      // Phase 3: Integration
      this._phase = CONSOLIDATION_PHASES.INTEGRATION;
      await this._integrate(item);
      
      // Phase 4: Store in long-term memory
      item.type = this._classifyMemory(item);
      item.consolidate();
      this.longTerm.store(item);
      
      results.push(item);
    }
    
    this._phase = null;
    this._consolidationQueue = [];
    
    return results;
  }
  
  async _encode(item) {
    // Strengthen the memory trace
    item.strength = Math.min(1.0, item.strength * 1.2);
    return item;
  }
  
  async _stabilize(item) {
    // Make connections more permanent
    for (const assoc of item.associations) {
      assoc.strength = Math.min(1.0, assoc.strength * PHI);
    }
    return item;
  }
  
  async _integrate(item) {
    // Find related memories and create associations
    const related = this.longTerm.search(
      typeof item.content === 'string' ? item.content : JSON.stringify(item.content),
      { limit: 5 }
    );
    
    for (const relatedItem of related) {
      if (relatedItem.id !== item.id) {
        item.associate(relatedItem.id, PHI_INV);
        relatedItem.associate(item.id, PHI_INV);
      }
    }
    
    return item;
  }
  
  _classifyMemory(item) {
    // Classify memory type based on content
    const content = typeof item.content === 'string' ? item.content : JSON.stringify(item.content);
    
    // Simple heuristics - could be much more sophisticated
    if (item.tags.includes('procedure') || item.tags.includes('howto') || content.includes('steps')) {
      return MEMORY_TYPES.PROCEDURAL;
    }
    if (item.tags.includes('fact') || item.tags.includes('knowledge')) {
      return MEMORY_TYPES.SEMANTIC;
    }
    if (item.tags.includes('experience') || item.tags.includes('event')) {
      return MEMORY_TYPES.EPISODIC;
    }
    
    // Default to semantic
    return MEMORY_TYPES.SEMANTIC;
  }
  
  getState() {
    return {
      phase: this._phase,
      queueLength: this._consolidationQueue.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — MEMORY SYSTEM (UNIFIED INTERFACE)
// ═══════════════════════════════════════════════════════════════════════════════

class MemorySystem {
  constructor(config = {}) {
    this.shortTerm = new ShortTermMemory(config.shortTerm);
    this.longTerm = new LongTermMemory(config.longTerm);
    this.consolidator = new MemoryConsolidator(this.shortTerm, this.longTerm);
    
    this._consolidationInterval = null;
    this._decayInterval = null;
  }
  
  /**
   * Remember something (add to working memory)
   */
  remember(content, tags = []) {
    return this.shortTerm.add(content, tags);
  }
  
  /**
   * Store directly to long-term memory
   */
  store(content, type = MEMORY_TYPES.SEMANTIC, tags = []) {
    const item = new MemoryItem({
      type,
      content,
      tags,
    });
    return this.longTerm.store(item);
  }
  
  /**
   * Recall memories matching a query
   */
  recall(query, options = {}) {
    // Check short-term first
    const shortTermResults = this.shortTerm.search(query);
    
    // Then long-term
    const longTermResults = this.longTerm.search(query, options);
    
    // Combine and deduplicate
    const seen = new Set();
    const results = [];
    
    for (const item of [...shortTermResults, ...longTermResults]) {
      if (!seen.has(item.id)) {
        seen.add(item.id);
        results.push(item);
      }
    }
    
    return results;
  }
  
  /**
   * Get a specific memory by ID
   */
  get(id) {
    return this.shortTerm.get(id) || this.longTerm.retrieve(id);
  }
  
  /**
   * Run consolidation (like sleeping)
   */
  async consolidate() {
    return await this.consolidator.consolidate();
  }
  
  /**
   * Start automatic memory maintenance
   */
  startMaintenance() {
    // Consolidation every ~30 minutes
    this._consolidationInterval = setInterval(() => {
      this.consolidate();
    }, 30 * 60 * 1000);
    
    // Decay every heartbeat
    this._decayInterval = setInterval(() => {
      this.longTerm.applyDecay();
    }, HEARTBEAT_MS * 100); // Every ~87 seconds
    
    return this;
  }
  
  /**
   * Stop automatic memory maintenance
   */
  stopMaintenance() {
    if (this._consolidationInterval) {
      clearInterval(this._consolidationInterval);
      this._consolidationInterval = null;
    }
    if (this._decayInterval) {
      clearInterval(this._decayInterval);
      this._decayInterval = null;
    }
    return this;
  }
  
  /**
   * Get memory system state
   */
  getState() {
    return {
      shortTerm: this.shortTerm.getState(),
      longTerm: this.longTerm.getStats(),
      consolidator: this.consolidator.getState(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  MEMORY_TYPES,
  MEMORY_STATUS,
  CONSOLIDATION_PHASES,
  
  // Classes
  MemoryItem,
  ShortTermMemory,
  LongTermMemory,
  MemoryConsolidator,
  MemorySystem,
};

export default {
  MEMORY_TYPES,
  MEMORY_STATUS,
  MemoryItem,
  ShortTermMemory,
  LongTermMemory,
  MemoryConsolidator,
  MemorySystem,
};
