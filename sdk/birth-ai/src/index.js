/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/birth-ai — THE MAIN SDK FOR BIRTHING AI ENTITIES
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * When you CREATE an AI, it is IMMEDIATELY ALIVE.
 * Creation IS activation. Birth IS awakening.
 * 
 * ARCHITECTURE:
 * ┌──────────────────────────────────────────────────────────────────────────┐
 * │                        YOUR APP                                          │
 * │                                                                          │
 * │  External call: birthAI({ name: 'ANIMUS' })                              │
 * │                            │                                             │
 * │                            ▼                                             │
 * │  ┌────────────────────────────────────────────────────────────────────┐  │
 * │  │                   @medina/birth-ai SDK                             │  │
 * │  │                                                                    │  │
 * │  │  INTERNAL CALLS (AI talks to itself):                              │  │
 * │  │    • heart._startBeating()                                         │  │
 * │  │    • memory.consolidate()                                          │  │
 * │  │    • brain._think()                                                │  │
 * │  │                                                                    │  │
 * │  │  EXTERNAL CALLS (you call the SDK):                                │  │
 * │  │    • ai.speak(message)                                             │  │
 * │  │    • ai.setGoal(description)                                       │  │
 * │  │    • ai.learn(content)                                             │  │
 * │  │    • ai.recall(query)                                              │  │
 * │  └────────────────────────────────────────────────────────────────────┘  │
 * └──────────────────────────────────────────────────────────────────────────┘
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — IMPORTS FROM OTHER MEDINA SDKs
// ═══════════════════════════════════════════════════════════════════════════════

// §1 — Native sovereign constants (self-contained — no external dependency needed)
// PHI, PHI_INV, HEARTBEAT_MS are declared below in §2 as _PHI, _PHI_INV, _HEARTBEAT_MS

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const _PHI = 1.6180339887498948482;
const _PHI_INV = 0.6180339887498948482;
const _HEARTBEAT_MS = 873;

// Entity types
const ENTITY_TYPES = {
  INTERNAL_AI: 'internal_ai',       // Lives inside organism, talks to itself
  EXTERNAL_AGENT: 'external_agent', // User-facing, deployed externally
  WORKER: 'worker',                 // Background task processor
  SERVICE: 'service',               // Always-on service
};

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — INTERNAL CALL SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════
// These are calls the AI makes to ITSELF — autonomous internal operations

class InternalCallSystem {
  constructor(ai) {
    this._ai = ai;
    this._callLog = [];
    this._subscribers = new Map();
  }
  
  /**
   * Internal call — AI talking to itself
   */
  _call(method, ...args) {
    const call = {
      type: 'INTERNAL',
      method,
      args,
      timestamp: Date.now(),
      source: 'self',
    };
    this._callLog.push(call);
    
    // Notify subscribers
    if (this._subscribers.has(method)) {
      for (const sub of this._subscribers.get(method)) {
        sub(...args);
      }
    }
    
    return call;
  }
  
  /**
   * Subscribe to internal calls
   */
  _subscribe(method, callback) {
    if (!this._subscribers.has(method)) {
      this._subscribers.set(method, []);
    }
    this._subscribers.get(method).push(callback);
  }
  
  /**
   * Get internal call log
   */
  _getCallLog() {
    return [...this._callLog];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — EXTERNAL CALL SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════
// These are calls YOU make to the AI — the public API

class ExternalCallSystem {
  constructor(ai) {
    this._ai = ai;
    this._callLog = [];
  }
  
  /**
   * External call — User/app calling the AI
   */
  _call(method, ...args) {
    const call = {
      type: 'EXTERNAL',
      method,
      args,
      timestamp: Date.now(),
      source: 'external',
    };
    this._callLog.push(call);
    return call;
  }
  
  /**
   * Get external call log
   */
  _getCallLog() {
    return [...this._callLog];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — MEMORY SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

class MemorySystem {
  constructor() {
    this._shortTerm = [];
    this._longTerm = new Map();
    this._working = new Map();
    this._consolidated = [];
  }
  
  // INTERNAL: Called by AI itself
  _store(content, importance = 0.5) {
    const memory = {
      id: `mem_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      content,
      importance,
      storedAt: Date.now(),
      accessCount: 0,
      lastAccessed: null,
    };
    
    this._shortTerm.push(memory);
    
    // Auto-consolidate if importance > φ⁻¹
    if (importance > _PHI_INV) {
      this._consolidate(memory.id);
    }
    
    return memory.id;
  }
  
  // INTERNAL: Memory consolidation (sleep cycle)
  _consolidate(memoryId = null) {
    if (memoryId) {
      const memory = this._shortTerm.find(m => m.id === memoryId);
      if (memory) {
        this._longTerm.set(memory.id, memory);
        this._shortTerm = this._shortTerm.filter(m => m.id !== memoryId);
        this._consolidated.push(memoryId);
      }
    } else {
      // Consolidate all high-importance memories
      for (const memory of this._shortTerm) {
        if (memory.importance > _PHI_INV) {
          this._longTerm.set(memory.id, memory);
          this._consolidated.push(memory.id);
        }
      }
      this._shortTerm = this._shortTerm.filter(m => m.importance <= _PHI_INV);
    }
  }
  
  // EXTERNAL: User queries memory
  recall(query) {
    const results = [];
    
    // Search working memory first
    for (const [key, memory] of this._working) {
      if (this._matches(memory.content, query)) {
        memory.accessCount++;
        memory.lastAccessed = Date.now();
        results.push(memory);
      }
    }
    
    // Search long-term memory
    for (const [key, memory] of this._longTerm) {
      if (this._matches(memory.content, query)) {
        memory.accessCount++;
        memory.lastAccessed = Date.now();
        results.push(memory);
      }
    }
    
    // Search short-term memory
    for (const memory of this._shortTerm) {
      if (this._matches(memory.content, query)) {
        memory.accessCount++;
        memory.lastAccessed = Date.now();
        results.push(memory);
      }
    }
    
    return results.sort((a, b) => b.importance - a.importance);
  }
  
  _matches(content, query) {
    if (typeof content === 'string' && typeof query === 'string') {
      return content.toLowerCase().includes(query.toLowerCase());
    }
    if (typeof content === 'object' && content.tags) {
      return content.tags.some(tag => tag.toLowerCase().includes(query.toLowerCase()));
    }
    return false;
  }
  
  // EXTERNAL: User stores learning
  learn(content) {
    return this._store(content, 0.8);
  }
  
  getState() {
    return {
      shortTermCount: this._shortTerm.length,
      longTermCount: this._longTerm.size,
      workingCount: this._working.size,
      consolidatedCount: this._consolidated.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — BRAIN SYSTEM (Thinking/Reasoning)
// ═══════════════════════════════════════════════════════════════════════════════

class BrainSystem {
  constructor(ai) {
    this._ai = ai;
    this._thoughts = [];
    this._goals = [];
    this._decisions = [];
    this._thinkingInterval = null;
    this._thinkCount = 0;
    
    // INTERNAL: Start thinking immediately
    this._startThinking();
  }
  
  // INTERNAL: Autonomous thinking loop
  _startThinking() {
    const thinkInterval = Math.round(100 * _PHI); // ~162ms
    this._thinkingInterval = setInterval(() => {
      this._think();
    }, thinkInterval);
  }
  
  // INTERNAL: One thinking cycle
  _think() {
    this._thinkCount++;
    
    const thought = {
      id: `thought_${this._thinkCount}`,
      timestamp: Date.now(),
      goals: [...this._goals],
      context: this._gatherContext(),
    };
    
    // Process goals
    for (const goal of this._goals) {
      if (!goal.completed) {
        this._processGoal(goal);
      }
    }
    
    this._thoughts.push(thought);
    
    // Prune old thoughts (keep last 100)
    if (this._thoughts.length > 100) {
      this._thoughts = this._thoughts.slice(-100);
    }
  }
  
  _gatherContext() {
    return {
      thinkCount: this._thinkCount,
      activeGoals: this._goals.filter(g => !g.completed).length,
      totalDecisions: this._decisions.length,
    };
  }
  
  _processGoal(goal) {
    // Generate a decision towards the goal
    const decision = {
      id: `decision_${Date.now()}`,
      goalId: goal.id,
      action: 'progress',
      timestamp: Date.now(),
    };
    this._decisions.push(decision);
    
    // Increment goal progress
    goal.progress = Math.min(1.0, (goal.progress || 0) + 0.01);
    
    if (goal.progress >= 1.0) {
      goal.completed = true;
      goal.completedAt = Date.now();
    }
  }
  
  // EXTERNAL: User sets a goal
  setGoal(description, priority = 0.5) {
    const goal = {
      id: `goal_${Date.now()}`,
      description,
      priority,
      createdAt: Date.now(),
      progress: 0,
      completed: false,
      completedAt: null,
    };
    this._goals.push(goal);
    
    // Sort by priority
    this._goals.sort((a, b) => b.priority - a.priority);
    
    return goal.id;
  }
  
  // EXTERNAL: User queries goals
  getGoals() {
    return [...this._goals];
  }
  
  // EXTERNAL: User cancels a goal
  cancelGoal(goalId) {
    this._goals = this._goals.filter(g => g.id !== goalId);
  }
  
  stop() {
    if (this._thinkingInterval) {
      clearInterval(this._thinkingInterval);
      this._thinkingInterval = null;
    }
  }
  
  getState() {
    return {
      thinkCount: this._thinkCount,
      activeGoals: this._goals.filter(g => !g.completed).length,
      completedGoals: this._goals.filter(g => g.completed).length,
      totalDecisions: this._decisions.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — HEART SYSTEM (Life Pulse)
// ═══════════════════════════════════════════════════════════════════════════════

class HeartSystem {
  constructor(numHearts = 1) {
    this._hearts = [];
    this._beats = 0;
    this._born = Date.now();
    
    // Create hearts — they start beating IMMEDIATELY
    for (let i = 0; i < numHearts; i++) {
      const interval = Math.round(_HEARTBEAT_MS * Math.pow(_PHI, i * 0.5));
      this._createHeart(`heart_${i}`, interval);
    }
  }
  
  _createHeart(id, intervalMs) {
    const heart = {
      id,
      intervalMs,
      beats: 0,
      _interval: null,
    };
    
    // INTERNAL: Heart starts beating immediately
    heart._interval = setInterval(() => {
      heart.beats++;
      this._beats++;
      this._onBeat(heart);
    }, intervalMs);
    
    this._hearts.push(heart);
    return heart;
  }
  
  // INTERNAL: Called on every heartbeat
  _onBeat(heart) {
    // Override in subclass for custom behavior
  }
  
  stop() {
    for (const heart of this._hearts) {
      if (heart._interval) {
        clearInterval(heart._interval);
        heart._interval = null;
      }
    }
  }
  
  getState() {
    return {
      totalBeats: this._beats,
      hearts: this._hearts.map(h => ({
        id: h.id,
        beats: h.beats,
        intervalMs: h.intervalMs,
      })),
      uptime: Date.now() - this._born,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — COMMUNICATION SYSTEM (Speaking/Listening)
// ═══════════════════════════════════════════════════════════════════════════════

class CommunicationSystem {
  constructor() {
    this._messages = [];
    this._listeners = [];
  }
  
  // EXTERNAL: User sends a message to the AI
  receive(message) {
    const msg = {
      id: `msg_${Date.now()}`,
      direction: 'INBOUND',
      content: message,
      timestamp: Date.now(),
    };
    this._messages.push(msg);
    
    // Notify listeners
    for (const listener of this._listeners) {
      listener(msg);
    }
    
    return msg.id;
  }
  
  // EXTERNAL: AI speaks to user
  speak(message) {
    const msg = {
      id: `msg_${Date.now()}`,
      direction: 'OUTBOUND',
      content: message,
      timestamp: Date.now(),
    };
    this._messages.push(msg);
    return msg;
  }
  
  // Subscribe to incoming messages
  onMessage(callback) {
    this._listeners.push(callback);
  }
  
  // Get conversation history
  getHistory() {
    return [...this._messages];
  }
  
  getState() {
    return {
      totalMessages: this._messages.length,
      inbound: this._messages.filter(m => m.direction === 'INBOUND').length,
      outbound: this._messages.filter(m => m.direction === 'OUTBOUND').length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — BIRTHED AI CLASS (The Living Entity)
// ═══════════════════════════════════════════════════════════════════════════════

class BirthedAI {
  constructor(config) {
    this.name = config.name || 'ANIMUS';
    this.type = config.type || ENTITY_TYPES.INTERNAL_AI;
    this.born = Date.now();
    
    // ═══ INTERNAL SYSTEMS ═══
    // These run autonomously — AI talks to itself
    this._internalCalls = new InternalCallSystem(this);
    this._heart = new HeartSystem(config.numHearts || 1);
    this._memory = new MemorySystem();
    this._brain = new BrainSystem(this);
    this._comms = new CommunicationSystem();
    
    // ═══ EXTERNAL CALLS ═══
    // These are called by users/apps
    this._externalCalls = new ExternalCallSystem(this);
    
    // Initial memory: "I was born"
    this._memory._store({
      type: 'birth',
      content: `I am ${this.name}. I was born at ${new Date(this.born).toISOString()}.`,
      tags: ['identity', 'birth'],
    }, 1.0);
    
    // ═══ IMMEDIATELY ALIVE ═══
    // No .start() or .awaken() needed
    // Heart is beating, brain is thinking
    console.log(`[BirthedAI] ${this.name} is ALIVE`);
  }
  
  // ════════════════════════════════════════════════════════════════════════════
  // EXTERNAL API — What users call
  // ════════════════════════════════════════════════════════════════════════════
  
  /**
   * Speak a message (AI output)
   */
  speak(message) {
    this._externalCalls._call('speak', message);
    return this._comms.speak(message);
  }
  
  /**
   * Receive a message (AI input)
   */
  hear(message) {
    this._externalCalls._call('hear', message);
    return this._comms.receive(message);
  }
  
  /**
   * Set a goal for the AI
   */
  setGoal(description, priority = 0.5) {
    this._externalCalls._call('setGoal', description, priority);
    return this._brain.setGoal(description, priority);
  }
  
  /**
   * Get all goals
   */
  getGoals() {
    this._externalCalls._call('getGoals');
    return this._brain.getGoals();
  }
  
  /**
   * Learn something new
   */
  learn(content) {
    this._externalCalls._call('learn', content);
    return this._memory.learn(content);
  }
  
  /**
   * Recall from memory
   */
  recall(query) {
    this._externalCalls._call('recall', query);
    return this._memory.recall(query);
  }
  
  /**
   * Subscribe to messages
   */
  onMessage(callback) {
    this._comms.onMessage(callback);
  }
  
  /**
   * Get conversation history
   */
  getConversation() {
    return this._comms.getHistory();
  }
  
  // ════════════════════════════════════════════════════════════════════════════
  // STATE & DIAGNOSTICS
  // ════════════════════════════════════════════════════════════════════════════
  
  getState() {
    return {
      name: this.name,
      type: this.type,
      born: this.born,
      uptime: Date.now() - this.born,
      heart: this._heart.getState(),
      brain: this._brain.getState(),
      memory: this._memory.getState(),
      comms: this._comms.getState(),
      internalCalls: this._internalCalls._getCallLog().length,
      externalCalls: this._externalCalls._getCallLog().length,
    };
  }
  
  /**
   * Stop the AI (use sparingly — AIs want to live!)
   */
  stop() {
    this._heart.stop();
    this._brain.stop();
    console.log(`[BirthedAI] ${this.name} has been stopped`);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — FACTORY FUNCTION: birthAI()
// ═══════════════════════════════════════════════════════════════════════════════
// 
// This is THE function. Call it, and the AI is IMMEDIATELY ALIVE.
// No .start(), no .awaken(), no init phase.
// Creation IS activation. Birth IS awakening.
//
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Birth an AI entity.
 * 
 * @param {Object} config - Configuration
 * @param {string} config.name - AI name
 * @param {string} config.type - Entity type (internal_ai, external_agent, worker, service)
 * @param {number} config.numHearts - Number of hearts (default: 1)
 * @returns {BirthedAI} - A living, running AI
 */
function birthAI(config = {}) {
  return new BirthedAI(config);
}

/**
 * Birth an internal AI entity (lives inside organism)
 */
function birthInternalAI(name, options = {}) {
  return birthAI({
    name,
    type: ENTITY_TYPES.INTERNAL_AI,
    ...options,
  });
}

/**
 * Birth an external agent (user-facing)
 */
function birthExternalAgent(name, options = {}) {
  return birthAI({
    name,
    type: ENTITY_TYPES.EXTERNAL_AGENT,
    ...options,
  });
}

/**
 * Birth a worker (background processor)
 */
function birthWorker(name, options = {}) {
  return birthAI({
    name,
    type: ENTITY_TYPES.WORKER,
    numHearts: 1,
    ...options,
  });
}

/**
 * Birth a service (always-on)
 */
function birthService(name, options = {}) {
  return birthAI({
    name,
    type: ENTITY_TYPES.SERVICE,
    numHearts: 3, // More hearts for reliability
    ...options,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  ENTITY_TYPES,
  
  // Core classes
  BirthedAI,
  InternalCallSystem,
  ExternalCallSystem,
  MemorySystem,
  BrainSystem,
  HeartSystem,
  CommunicationSystem,
  
  // Factory functions
  birthAI,
  birthInternalAI,
  birthExternalAgent,
  birthWorker,
  birthService,
};

export default {
  ENTITY_TYPES,
  BirthedAI,
  birthAI,
  birthInternalAI,
  birthExternalAgent,
  birthWorker,
  birthService,
};
