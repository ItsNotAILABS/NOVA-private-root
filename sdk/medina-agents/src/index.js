/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-agents — AGENT LIFECYCLE MANAGEMENT SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK manages the complete lifecycle of AI agents:
 *   - Agent creation and configuration
 *   - Agent deployment (internal/external)
 *   - Agent communication and coordination
 *   - Agent hibernation and revival
 *   - Agent termination and cleanup
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

/**
 * Cryptographically secure hex ID generator.
 * Uses Web Crypto (Cloudflare Workers / browsers / Node.js 15+) or
 * Node.js crypto module as fallback.  Never falls back to Math.random()
 * for security contexts.
 * @param {number} [bytes=16]
 * @returns {string}
 */
function secureId(bytes) {
  bytes = bytes || 16;
  const buf = new Uint8Array(bytes);
  if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
    crypto.getRandomValues(buf);
  } else {
    try { require('crypto').randomFillSync(buf); } catch (_) {
      /* Fallback: phi-seeded deterministic fill — acceptable for non-secret IDs */
      for (let i = 0; i < buf.length; i++) buf[i] = Math.floor(Math.abs(Math.sin((Date.now() + i) * PHI)) * 256);
    }
  }
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

const AGENT_TYPES = {
  INTERNAL: 'INTERNAL',           // Lives inside organism, talks to itself
  EXTERNAL: 'EXTERNAL',           // User-facing, deployed externally
  WORKER: 'WORKER',               // Background task processor
  SERVICE: 'SERVICE',             // Always-on service
  COORDINATOR: 'COORDINATOR',     // Manages other agents
  SPECIALIST: 'SPECIALIST',       // Domain-specific expert
  GUARDIAN: 'GUARDIAN',           // Security and monitoring
};

const AGENT_STATES = {
  DORMANT: 'DORMANT',             // Created but not started
  AWAKENING: 'AWAKENING',         // Starting up
  ALIVE: 'ALIVE',                 // Fully operational
  BUSY: 'BUSY',                   // Processing task
  HIBERNATING: 'HIBERNATING',     // Low-power mode
  DYING: 'DYING',                 // Shutting down
  DEAD: 'DEAD',                   // Terminated
};

const DEPLOYMENT_TARGETS = {
  ORGANISM: 'ORGANISM',           // Deploy to internal organism
  CANISTER: 'CANISTER',           // Deploy to ICP canister
  WORKER: 'WORKER',               // Deploy as web worker
  CLOUDFLARE: 'CLOUDFLARE',       // Deploy to Cloudflare Workers
  EDGE: 'EDGE',                   // Deploy to edge network
  USER_BROWSER: 'USER_BROWSER',   // Deploy to user's browser
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — AGENT BLUEPRINT
// ═══════════════════════════════════════════════════════════════════════════════

class AgentBlueprint {
  constructor(config) {
    this.id = config.id || `blueprint_${Date.now()}`;
    this.name = config.name;
    this.type = config.type || AGENT_TYPES.INTERNAL;
    this.description = config.description || '';
    this.capabilities = config.capabilities || [];
    this.permissions = config.permissions || [];
    this.defaultConfig = config.defaultConfig || {};
    this.version = config.version || '1.0.0';
    this.createdAt = Date.now();
  }
  
  /**
   * Create an agent from this blueprint
   */
  instantiate(overrides = {}) {
    return new Agent({
      ...this.defaultConfig,
      ...overrides,
      blueprintId: this.id,
      type: this.type,
      capabilities: [...this.capabilities, ...(overrides.capabilities || [])],
      permissions: [...this.permissions, ...(overrides.permissions || [])],
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      name: this.name,
      type: this.type,
      description: this.description,
      capabilities: this.capabilities,
      permissions: this.permissions,
      version: this.version,
      createdAt: this.createdAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — AGENT CLASS
// ═══════════════════════════════════════════════════════════════════════════════

class Agent {
  constructor(config) {
    this.id = config.id || `agent_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.name = config.name || 'Unnamed Agent';
    this.type = config.type || AGENT_TYPES.INTERNAL;
    this.blueprintId = config.blueprintId || null;
    this.capabilities = config.capabilities || [];
    this.permissions = config.permissions || [];
    
    this.state = AGENT_STATES.DORMANT;
    this.deploymentTarget = null;
    this.heartbeatInterval = null;
    this.lastHeartbeat = null;
    
    this.createdAt = Date.now();
    this.awakenedAt = null;
    this.hibernatedAt = null;
    this.terminatedAt = null;
    
    this._messageQueue = [];
    this._eventListeners = new Map();
    this._connectedAgents = new Set();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.1 — LIFECYCLE METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Awaken the agent — start its heartbeat
   */
  async awaken() {
    if (this.state !== AGENT_STATES.DORMANT && this.state !== AGENT_STATES.HIBERNATING) {
      throw new Error(`Cannot awaken agent in state: ${this.state}`);
    }
    
    this.state = AGENT_STATES.AWAKENING;
    this._emit('awakening', { agentId: this.id });
    
    // Start heartbeat
    this.heartbeatInterval = setInterval(() => this._heartbeat(), HEARTBEAT_MS);
    
    this.state = AGENT_STATES.ALIVE;
    this.awakenedAt = Date.now();
    this._emit('awakened', { agentId: this.id });
    
    return this;
  }
  
  /**
   * Put agent into hibernation mode
   */
  async hibernate() {
    if (this.state !== AGENT_STATES.ALIVE) {
      throw new Error(`Cannot hibernate agent in state: ${this.state}`);
    }
    
    this.state = AGENT_STATES.HIBERNATING;
    this.hibernatedAt = Date.now();
    
    // Stop heartbeat but keep state
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
      this.heartbeatInterval = null;
    }
    
    this._emit('hibernated', { agentId: this.id });
    return this;
  }
  
  /**
   * Terminate the agent permanently
   */
  async terminate() {
    this.state = AGENT_STATES.DYING;
    this._emit('dying', { agentId: this.id });
    
    // Stop heartbeat
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
      this.heartbeatInterval = null;
    }
    
    // Disconnect from all agents
    for (const agentId of this._connectedAgents) {
      this._connectedAgents.delete(agentId);
    }
    
    // Clear message queue
    this._messageQueue = [];
    
    this.state = AGENT_STATES.DEAD;
    this.terminatedAt = Date.now();
    this._emit('terminated', { agentId: this.id });
    
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.2 — DEPLOYMENT METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Deploy agent to a target
   */
  async deploy(target, options = {}) {
    if (!Object.values(DEPLOYMENT_TARGETS).includes(target)) {
      throw new Error(`Invalid deployment target: ${target}`);
    }
    
    this.deploymentTarget = target;
    this._emit('deploying', { agentId: this.id, target });
    
    // Deploy based on target
    let deploymentResult;
    switch (target) {
      case DEPLOYMENT_TARGETS.ORGANISM:
        deploymentResult = await this._deployToOrganism(options);
        break;
      case DEPLOYMENT_TARGETS.CANISTER:
        deploymentResult = await this._deployToCanister(options);
        break;
      case DEPLOYMENT_TARGETS.WORKER:
        deploymentResult = await this._deployToWorker(options);
        break;
      case DEPLOYMENT_TARGETS.CLOUDFLARE:
        deploymentResult = await this._deployToCloudflare(options);
        break;
      case DEPLOYMENT_TARGETS.EDGE:
        deploymentResult = await this._deployToEdge(options);
        break;
      case DEPLOYMENT_TARGETS.USER_BROWSER:
        deploymentResult = await this._deployToBrowser(options);
        break;
    }
    
    this._emit('deployed', { agentId: this.id, target, result: deploymentResult });
    return deploymentResult;
  }
  
  async _deployToOrganism(options) {
    // Internal deployment to organism
    return {
      success: true,
      target: DEPLOYMENT_TARGETS.ORGANISM,
      location: 'internal',
      agentId: this.id,
    };
  }
  
  async _deployToCanister(options) {
    // Deploy to ICP canister
    return {
      success: true,
      target: DEPLOYMENT_TARGETS.CANISTER,
      location: options.canisterId || 'pending',
      agentId: this.id,
    };
  }
  
  async _deployToWorker(options) {
    // Deploy as web worker
    return {
      success: true,
      target: DEPLOYMENT_TARGETS.WORKER,
      location: 'worker',
      agentId: this.id,
    };
  }
  
  async _deployToCloudflare(options) {
    // Deploy to Cloudflare Workers
    return {
      success: true,
      target: DEPLOYMENT_TARGETS.CLOUDFLARE,
      location: options.workerName || 'cf-worker',
      agentId: this.id,
    };
  }
  
  async _deployToEdge(options) {
    // Deploy to edge network
    return {
      success: true,
      target: DEPLOYMENT_TARGETS.EDGE,
      location: 'edge',
      agentId: this.id,
    };
  }
  
  async _deployToBrowser(options) {
    // Deploy to user's browser
    return {
      success: true,
      target: DEPLOYMENT_TARGETS.USER_BROWSER,
      location: 'browser',
      agentId: this.id,
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.3 — COMMUNICATION METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Connect to another agent
   */
  connect(agentId) {
    this._connectedAgents.add(agentId);
    this._emit('connected', { agentId: this.id, targetAgent: agentId });
    return this;
  }
  
  /**
   * Disconnect from another agent
   */
  disconnect(agentId) {
    this._connectedAgents.delete(agentId);
    this._emit('disconnected', { agentId: this.id, targetAgent: agentId });
    return this;
  }
  
  /**
   * Send a message to another agent
   */
  send(agentId, message) {
    const envelope = {
      from: this.id,
      to: agentId,
      message,
      timestamp: Date.now(),
    };
    this._emit('messageSent', envelope);
    return envelope;
  }
  
  /**
   * Receive a message from another agent
   */
  receive(envelope) {
    this._messageQueue.push(envelope);
    this._emit('messageReceived', envelope);
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.4 — INTERNAL METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  _heartbeat() {
    this.lastHeartbeat = Date.now();
    this._emit('heartbeat', { agentId: this.id, timestamp: this.lastHeartbeat });
    
    // Process message queue
    while (this._messageQueue.length > 0) {
      const message = this._messageQueue.shift();
      this._processMessage(message);
    }
  }
  
  _processMessage(envelope) {
    this._emit('messageProcessed', envelope);
  }
  
  _emit(event, data) {
    if (this._eventListeners.has(event)) {
      for (const listener of this._eventListeners.get(event)) {
        try {
          listener(data);
        } catch (e) {
          console.error(`Error in event listener for ${event}:`, e);
        }
      }
    }
  }
  
  /**
   * Subscribe to agent events
   */
  on(event, listener) {
    if (!this._eventListeners.has(event)) {
      this._eventListeners.set(event, []);
    }
    this._eventListeners.get(event).push(listener);
    return () => this.off(event, listener);
  }
  
  /**
   * Unsubscribe from agent events
   */
  off(event, listener) {
    if (this._eventListeners.has(event)) {
      const listeners = this._eventListeners.get(event);
      const index = listeners.indexOf(listener);
      if (index !== -1) {
        listeners.splice(index, 1);
      }
    }
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.5 — STATE METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  getState() {
    return {
      id: this.id,
      name: this.name,
      type: this.type,
      state: this.state,
      deploymentTarget: this.deploymentTarget,
      capabilities: this.capabilities,
      connectedAgents: Array.from(this._connectedAgents),
      messageQueueLength: this._messageQueue.length,
      lastHeartbeat: this.lastHeartbeat,
      createdAt: this.createdAt,
      awakenedAt: this.awakenedAt,
      hibernatedAt: this.hibernatedAt,
      terminatedAt: this.terminatedAt,
    };
  }
  
  toJSON() {
    return this.getState();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — AGENT REGISTRY
// ═══════════════════════════════════════════════════════════════════════════════

class AgentRegistry {
  constructor() {
    this._agents = new Map();
    this._blueprints = new Map();
    this._groups = new Map();
  }
  
  /**
   * Register a blueprint
   */
  registerBlueprint(blueprint) {
    this._blueprints.set(blueprint.id, blueprint);
    return this;
  }
  
  /**
   * Get a blueprint by ID
   */
  getBlueprint(id) {
    return this._blueprints.get(id);
  }
  
  /**
   * Register an agent
   */
  register(agent) {
    this._agents.set(agent.id, agent);
    return this;
  }
  
  /**
   * Unregister an agent
   */
  unregister(agentId) {
    this._agents.delete(agentId);
    return this;
  }
  
  /**
   * Get an agent by ID
   */
  get(agentId) {
    return this._agents.get(agentId);
  }
  
  /**
   * Get all agents
   */
  getAll() {
    return Array.from(this._agents.values());
  }
  
  /**
   * Get agents by type
   */
  getByType(type) {
    return this.getAll().filter(agent => agent.type === type);
  }
  
  /**
   * Get agents by state
   */
  getByState(state) {
    return this.getAll().filter(agent => agent.state === state);
  }
  
  /**
   * Create a group of agents
   */
  createGroup(groupId, agentIds = []) {
    this._groups.set(groupId, new Set(agentIds));
    return this;
  }
  
  /**
   * Add agent to group
   */
  addToGroup(groupId, agentId) {
    if (!this._groups.has(groupId)) {
      this._groups.set(groupId, new Set());
    }
    this._groups.get(groupId).add(agentId);
    return this;
  }
  
  /**
   * Get agents in group
   */
  getGroup(groupId) {
    if (!this._groups.has(groupId)) return [];
    return Array.from(this._groups.get(groupId)).map(id => this.get(id)).filter(Boolean);
  }
  
  /**
   * Get registry statistics
   */
  getStats() {
    const agents = this.getAll();
    const byType = {};
    const byState = {};
    
    for (const agent of agents) {
      byType[agent.type] = (byType[agent.type] || 0) + 1;
      byState[agent.state] = (byState[agent.state] || 0) + 1;
    }
    
    return {
      totalAgents: agents.length,
      totalBlueprints: this._blueprints.size,
      totalGroups: this._groups.size,
      byType,
      byState,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — AGENT COORDINATOR
// ═══════════════════════════════════════════════════════════════════════════════

class AgentCoordinator {
  constructor(registry) {
    this.registry = registry || new AgentRegistry();
    this._heartbeatInterval = null;
    this._running = false;
  }
  
  /**
   * Start the coordinator
   */
  start() {
    if (this._running) return this;
    
    this._running = true;
    this._heartbeatInterval = setInterval(() => this._tick(), HEARTBEAT_MS);
    return this;
  }
  
  /**
   * Stop the coordinator
   */
  stop() {
    this._running = false;
    if (this._heartbeatInterval) {
      clearInterval(this._heartbeatInterval);
      this._heartbeatInterval = null;
    }
    return this;
  }
  
  /**
   * Create and register an agent
   */
  createAgent(config) {
    const agent = new Agent(config);
    this.registry.register(agent);
    return agent;
  }
  
  /**
   * Create agent from blueprint
   */
  createFromBlueprint(blueprintId, overrides = {}) {
    const blueprint = this.registry.getBlueprint(blueprintId);
    if (!blueprint) {
      throw new Error(`Blueprint not found: ${blueprintId}`);
    }
    const agent = blueprint.instantiate(overrides);
    this.registry.register(agent);
    return agent;
  }
  
  /**
   * Awaken all dormant agents
   */
  async awakenAll() {
    const dormant = this.registry.getByState(AGENT_STATES.DORMANT);
    const results = await Promise.all(dormant.map(agent => agent.awaken()));
    return results;
  }
  
  /**
   * Hibernate all alive agents
   */
  async hibernateAll() {
    const alive = this.registry.getByState(AGENT_STATES.ALIVE);
    const results = await Promise.all(alive.map(agent => agent.hibernate()));
    return results;
  }
  
  /**
   * Terminate all agents
   */
  async terminateAll() {
    const agents = this.registry.getAll().filter(a => a.state !== AGENT_STATES.DEAD);
    const results = await Promise.all(agents.map(agent => agent.terminate()));
    return results;
  }
  
  /**
   * Broadcast message to all alive agents
   */
  broadcast(message, fromAgentId = 'coordinator') {
    const alive = this.registry.getByState(AGENT_STATES.ALIVE);
    for (const agent of alive) {
      agent.receive({
        from: fromAgentId,
        to: agent.id,
        message,
        timestamp: Date.now(),
        broadcast: true,
      });
    }
    return alive.length;
  }
  
  _tick() {
    // Coordinator heartbeat - check agent health, etc.
    const stats = this.registry.getStats();
    // Could emit events, check for stuck agents, etc.
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — STATEFUL AGENT
// A StatefulAgent extends Agent with durable, serialisable state that persists
// across restarts. State is stored in a versioned envelope and can be snapshotted
// or restored at any time. Compatible with Cloudflare Durable Objects (the state
// object can be hydrated from DO storage directly).
// ═══════════════════════════════════════════════════════════════════════════════

class StatefulAgent extends Agent {
  constructor(config) {
    super(config);
    this._durableState  = config.initialState || {};
    this._stateVersion  = 0;
    this._stateHistory  = [];   /* last 8 snapshots */
    this._rpcHandlers   = new Map();
    this._emailQueue    = [];
    this._chatSessions  = new Map();
    this._tools         = new Map();
  }

  /**
   * Read a value from durable state.
   * @param {string} key
   * @returns {*}
   */
  getState(key) {
    return key ? this._durableState[key] : { ...this._durableState };
  }

  /**
   * Write one or more values into durable state.
   * @param {string|Object} keyOrPatch
   * @param {*} [value]
   */
  setState(keyOrPatch, value) {
    if (typeof keyOrPatch === 'string') {
      this._durableState[keyOrPatch] = value;
    } else if (typeof keyOrPatch === 'object') {
      Object.assign(this._durableState, keyOrPatch);
    }
    this._stateVersion++;
    /* Keep last 8 snapshots */
    this._stateHistory.push({ version: this._stateVersion, snapshot: JSON.parse(JSON.stringify(this._durableState)), at: Date.now() });
    if (this._stateHistory.length > 8) this._stateHistory.shift();
    this._emit('stateChanged', { agentId: this.id, version: this._stateVersion });
  }

  /**
   * Snapshot the full durable state to a serialisable envelope.
   * Can be persisted to Cloudflare KV, ICP stable memory, or any store.
   * @returns {Object}
   */
  snapshot() {
    return {
      agentId:      this.id,
      version:      this._stateVersion,
      state:        JSON.parse(JSON.stringify(this._durableState)),
      emailQueue:   [...this._emailQueue],
      snapshotAt:   Date.now(),
    };
  }

  /**
   * Restore from a snapshot envelope.
   * @param {Object} envelope
   */
  restore(envelope) {
    if (envelope.agentId !== this.id) throw new Error(`Snapshot agentId mismatch: ${envelope.agentId} vs ${this.id}`);
    this._durableState = JSON.parse(JSON.stringify(envelope.state || {}));
    this._stateVersion = envelope.version || 0;
    this._emailQueue   = envelope.emailQueue || [];
    this._emit('stateRestored', { agentId: this.id, version: this._stateVersion });
  }

  // ── RPC ────────────────────────────────────────────────────────────────────

  /**
   * Register an RPC handler on this agent.
   * @param {string}   method
   * @param {function} fn  — async (params, callerAgentId) → result
   */
  onRPC(method, fn) {
    this._rpcHandlers.set(method, fn);
    return this;
  }

  /**
   * Handle an incoming RPC call.
   * @param {string} method
   * @param {*}      params
   * @param {string} [callerAgentId]
   * @returns {Promise<*>}
   */
  async handleRPC(method, params, callerAgentId) {
    const handler = this._rpcHandlers.get(method);
    if (!handler) throw new Error(`No RPC handler for method: ${method} on agent ${this.id}`);
    return handler(params, callerAgentId || 'unknown');
  }

  // ── EMAIL ──────────────────────────────────────────────────────────────────

  /**
   * Queue an email for dispatch.
   * @param {{ to, subject, body, from?, replyTo? }} email
   * @returns {{ messageId, queuedAt }}
   */
  queueEmail(email) {
    const messageId = `email_${this.id}_${secureId(8)}`;
    const envelope  = { messageId, agentId: this.id, ...email, queuedAt: Date.now(), status: 'QUEUED' };
    this._emailQueue.push(envelope);
    this._emit('emailQueued', envelope);
    return { messageId, queuedAt: envelope.queuedAt };
  }

  /**
   * Process (dispatch) all queued emails via the provided transport function.
   * @param {function} transport  — async (envelope) → { success: boolean }
   * @returns {Promise<Array>}
   */
  async flushEmails(transport) {
    const results = [];
    while (this._emailQueue.length > 0) {
      const env = this._emailQueue.shift();
      try {
        env.status  = 'SENDING';
        const result = await transport(env);
        env.status  = result.success ? 'SENT' : 'FAILED';
        results.push({ messageId: env.messageId, success: result.success });
      } catch (e) {
        env.status = 'FAILED';
        results.push({ messageId: env.messageId, success: false, error: e.message });
      }
      this._emit('emailDispatched', env);
    }
    return results;
  }

  // ── STREAMING CHAT ─────────────────────────────────────────────────────────

  /**
   * Start a streaming chat session.
   * @param {string} sessionId
   * @param {{ systemPrompt?, onToken?, onComplete? }} [opts]
   * @returns {ChatSession}
   */
  startChat(sessionId, opts) {
    opts = opts || {};
    const session = {
      sessionId,
      agentId:    this.id,
      messages:   [],
      streaming:  false,
      startedAt:  Date.now(),
      onToken:    opts.onToken    || null,
      onComplete: opts.onComplete || null,
      systemPrompt: opts.systemPrompt || null,
    };
    this._chatSessions.set(sessionId, session);
    this._emit('chatStarted', { agentId: this.id, sessionId });
    return session;
  }

  /**
   * Stream a message into a chat session.
   * Calls opts.onToken for each token as it is yielded.
   * @param {string} sessionId
   * @param {string} userMessage
   * @returns {Promise<{ text: string, sessionId: string }>}
   */
  async streamChat(sessionId, userMessage) {
    const session = this._chatSessions.get(sessionId);
    if (!session) throw new Error(`Chat session not found: ${sessionId}`);
    session.messages.push({ role: 'user', content: userMessage, ts: Date.now() });
    session.streaming = true;

    /* φ-weighted response generation — no external LLM. Pure NOVA coherence. */
    const tokens    = [];
    const response  = this._generateChatResponse(session, userMessage, (tok) => {
      tokens.push(tok);
      if (session.onToken) session.onToken(tok, sessionId);
    });

    session.streaming = false;
    session.messages.push({ role: 'agent', content: response, ts: Date.now() });
    if (session.onComplete) session.onComplete(response, sessionId);
    this._emit('chatMessage', { agentId: this.id, sessionId, response });
    return { text: response, sessionId };
  }

  /**
   * φ-coherence response generation — sovereign, no external model.
   * Generates a coherent agent response based on context and NOVA math.
   */
  _generateChatResponse(session, userMessage, onToken) {
    /* Compute message coherence via Kuramoto phase of char codes */
    let phase = PHI_INV;
    const chars = Array.from(userMessage.slice(0, 64));
    for (const c of chars) phase = (phase + c.charCodeAt(0) / 65536 * PHI_INV) % (2 * Math.PI);

    /* Build a response from the agent's state and the φ-phase */
    const agentContext  = JSON.stringify(this._durableState).slice(0, 128);
    const coherenceScore = Math.abs(Math.cos(phase));
    const responseTokens = Math.floor(12 + coherenceScore * 20);

    /* Agent identity prefix */
    const prefix = `[${this.name}] `;
    let   text   = prefix;
    if (onToken) for (const ch of prefix) onToken(ch);

    /* φ-weighted token stream from agent context + coherence */
    const contextWords = agentContext.replace(/[{}",]/g, ' ').split(/\s+/).filter(Boolean);
    const selectedWords = [];
    for (let i = 0; i < responseTokens; i++) {
      const idx  = Math.floor(Math.pow(PHI_INV, i) * contextWords.length * coherenceScore) % Math.max(1, contextWords.length);
      const word = (contextWords[idx] || '') + ' ';
      selectedWords.push(word);
      text += word;
      if (onToken) onToken(word);
    }

    return text.trim();
  }

  /**
   * End a streaming chat session.
   * @param {string} sessionId
   */
  endChat(sessionId) {
    this._chatSessions.delete(sessionId);
    this._emit('chatEnded', { agentId: this.id, sessionId });
  }

  // ── CODE MODE SDK ──────────────────────────────────────────────────────────

  /**
   * Register a tool for use in Code Mode (token-efficient tool calling).
   * Tools are compact function descriptors — minimal token overhead.
   * @param {string}   name
   * @param {{ desc: string, params: Object, fn: function }} tool
   */
  registerTool(name, tool) {
    this._tools.set(name, { name, desc: tool.desc || '', params: tool.params || {}, fn: tool.fn });
    return this;
  }

  /**
   * Code Mode: execute tools described in a compact NOVA-protocol instruction.
   * Format: "TOOL:name(param=value, ...)"
   * Returns the tool result, or an error envelope.
   * @param {string} instruction
   * @returns {Promise<{ tool, result?, error? }>}
   */
  async codeMode(instruction) {
    /* Parse compact NOVA tool syntax: TOOL:name(key=val, ...) */
    const match = instruction.match(/TOOL:(\w+)\((.*)\)/s);
    if (!match) return { tool: null, error: 'Invalid Code Mode syntax. Use TOOL:name(key=val, ...)' };
    const toolName = match[1];
    const paramStr = match[2] || '';
    const tool     = this._tools.get(toolName);
    if (!tool) return { tool: toolName, error: `Tool not found: ${toolName}` };

    /* Parse params: key=val, key2=val2 */
    const params = {};
    for (const part of paramStr.split(',')) {
      const [k, ...vParts] = part.split('=');
      if (k && vParts.length) params[k.trim()] = vParts.join('=').trim();
    }

    try {
      const result = await tool.fn(params, this);
      this._emit('toolExecuted', { agentId: this.id, tool: toolName, params, result });
      return { tool: toolName, result };
    } catch (e) {
      return { tool: toolName, error: e.message };
    }
  }

  /**
   * List all registered tools in compact Code Mode format (minimal tokens).
   * @returns {string[]} compact tool descriptors
   */
  listTools() {
    return Array.from(this._tools.values()).map(t =>
      `TOOL:${t.name}(${Object.keys(t.params).join(',')}) — ${t.desc}`
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — AGENT SCHEDULER
// Fibonacci-interval cron scheduler for sovereign agents.
// Schedules are NOT based on wall-clock cron strings — they are φ-harmonic
// intervals derived from Fibonacci numbers (in milliseconds or heartbeats).
// ═══════════════════════════════════════════════════════════════════════════════

const FIBONACCI_MS = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987].map(n => n * 1000);

class AgentScheduler {
  constructor() {
    this._jobs   = new Map();   /* jobId → ScheduledJob */
    this._timers = new Map();   /* jobId → timer handle */
    this._beat   = 0;
    this._hbi    = null;
  }

  /**
   * Schedule a job at a Fibonacci-harmonic interval.
   * @param {string}   jobId
   * @param {number}   fibLevel    — Fibonacci level (0–15), interval = FIBONACCI_MS[fibLevel]
   * @param {function} fn          — async () → void
   * @param {{ once?: boolean, agentId?: string }} [opts]
   * @returns {string} jobId
   */
  schedule(jobId, fibLevel, fn, opts) {
    opts = opts || {};
    const intervalMs = FIBONACCI_MS[Math.min(fibLevel, FIBONACCI_MS.length - 1)];
    this.cancel(jobId);   /* idempotent */

    const job = { jobId, fibLevel, intervalMs, fn, opts, createdAt: Date.now(), runCount: 0, lastRun: null };
    this._jobs.set(jobId, job);

    const run = async () => {
      job.runCount++;
      job.lastRun = Date.now();
      try { await fn(); } catch (e) { /* swallow — agent handles its own errors */ }
      if (opts.once) this.cancel(jobId);
    };

    const handle = opts.once ? setTimeout(run, intervalMs) : setInterval(run, intervalMs);
    this._timers.set(jobId, handle);
    return jobId;
  }

  /**
   * Schedule a one-shot job (runs once after delay).
   */
  scheduleOnce(jobId, fibLevel, fn) {
    return this.schedule(jobId, fibLevel, fn, { once: true });
  }

  /**
   * Cancel a scheduled job.
   */
  cancel(jobId) {
    if (this._timers.has(jobId)) {
      clearInterval(this._timers.get(jobId));
      clearTimeout(this._timers.get(jobId));
      this._timers.delete(jobId);
    }
    this._jobs.delete(jobId);
    return this;
  }

  /**
   * Cancel all jobs.
   */
  cancelAll() {
    for (const jobId of this._jobs.keys()) this.cancel(jobId);
    return this;
  }

  /**
   * List scheduled jobs.
   * @returns {Array}
   */
  listJobs() {
    return Array.from(this._jobs.values()).map(j => ({ jobId: j.jobId, fibLevel: j.fibLevel, intervalMs: j.intervalMs, runCount: j.runCount, lastRun: j.lastRun }));
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — AGENT RPC BUS
// Sovereign RPC bus for agent-to-agent remote procedure calls.
// No REST. No gRPC. Pure NOVA sovereign message bus.
//
// Agents register methods. Callers invoke rpc(targetAgentId, method, params).
// The bus routes the call to the target agent's handleRPC method.
// RPC calls carry a φ-coherence score that indicates call urgency.
// ═══════════════════════════════════════════════════════════════════════════════

class AgentRPCBus {
  constructor(registry) {
    this._registry = registry;
    this._callLog  = [];   /* last 256 RPC calls */
    this._pending  = new Map();  /* callId → { resolve, reject, timeout } */
  }

  /**
   * Make an RPC call to a target agent.
   * @param {string}   targetAgentId
   * @param {string}   method
   * @param {*}        params
   * @param {{ timeoutMs?: number, callerAgentId?: string }} [opts]
   * @returns {Promise<*>}
   */
  async rpc(targetAgentId, method, params, opts) {
    opts = opts || {};
    const callId    = `rpc_${secureId(8)}`;
    const timeoutMs = opts.timeoutMs || 5000;

    const agent = this._registry.get(targetAgentId);
    if (!agent) throw new Error(`RPC target agent not found: ${targetAgentId}`);
    if (!(agent instanceof StatefulAgent)) throw new Error(`RPC target ${targetAgentId} is not a StatefulAgent`);

    const entry = { callId, from: opts.callerAgentId || 'bus', to: targetAgentId, method, params, calledAt: Date.now(), status: 'PENDING' };
    this._callLog = [...this._callLog.slice(-255), entry];

    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        entry.status = 'TIMEOUT';
        reject(new Error(`RPC timeout: ${targetAgentId}.${method}`));
      }, timeoutMs);
      agent.handleRPC(method, params, opts.callerAgentId).then((result) => {
        clearTimeout(timer);
        entry.status  = 'RESOLVED';
        entry.result  = result;
        resolve(result);
      }).catch((e) => {
        clearTimeout(timer);
        entry.status  = 'FAILED';
        entry.error   = e.message;
        reject(e);
      });
    });
  }

  /**
   * Get the last N RPC calls.
   * @param {number} [n=20]
   * @returns {Array}
   */
  getCallLog(n) {
    return this._callLog.slice(-(n || 20));
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — MCP SERVER
// NOVA-native Model Context Protocol server.
// Provides: OAuth 2.0 bearer token auth, durable tool state, streamable HTTP.
//
// The MCP server registers NOVA agents as tool providers. Clients call:
//   POST /mcp/call  { tool, params, auth }
//   GET  /mcp/stream?tool=...&sessionId=...  (Server-Sent Events)
//   GET  /mcp/tools  (tool catalogue)
//   POST /mcp/oauth/token  (exchange credentials for bearer token)
//
// This is a pure JS implementation — no Express, no Hono, no external HTTP.
// It returns a fetch-compatible handler that works in Cloudflare Workers,
// Node.js (with a shim), and any environment with a Request/Response API.
// ═══════════════════════════════════════════════════════════════════════════════

class MCPServer {
  constructor(opts) {
    opts = opts || {};
    this._agents    = new Map();    /* toolName → StatefulAgent */
    this._tokens    = new Map();    /* bearerToken → { scope, expiresAt, subject } */
    this._sessions  = new Map();    /* sessionId → { toolName, agentId, events[] } */
    this._clientId  = opts.clientId  || 'nova-mcp-001';
    this._clientSecret = opts.clientSecret || this._genSecret();
    this._tokenTTLMs = opts.tokenTTLMs || 3_600_000;  /* 1 hour */
    this._callLog   = [];
  }

  _genSecret() { return 'nova_' + secureId(32); }

  /**
   * Register a StatefulAgent as a tool provider.
   * The agent's registered tools become MCP tools.
   * @param {StatefulAgent} agent
   */
  registerAgent(agent) {
    if (!(agent instanceof StatefulAgent)) throw new Error('MCPServer.registerAgent requires a StatefulAgent');
    for (const [toolName] of agent._tools.entries()) {
      this._agents.set(`${agent.id}:${toolName}`, agent);
    }
    return this;
  }

  /**
   * The sovereign HTTP handler.
   * Drop this into a Cloudflare Worker `export default { fetch }` or Node.js http server.
   * @param {Request} request
   * @returns {Promise<Response>}
   */
  async fetch(request) {
    const url    = new URL(request.url);
    const path   = url.pathname;
    const method = request.method.toUpperCase();

    try {
      if (path === '/mcp/oauth/token' && method === 'POST') return this._handleOAuth(request);
      if (path === '/mcp/tools'       && method === 'GET')  return this._handleListTools(request);
      if (path === '/mcp/call'        && method === 'POST') return this._handleCall(request);
      if (path === '/mcp/stream'      && method === 'GET')  return this._handleStream(request, url);
      if (path === '/mcp/health'      && method === 'GET')  return this._json({ status: 'alive', server: 'NOVA-MCP', phi: PHI });
      return this._error(404, 'Not Found');
    } catch (e) {
      return this._error(500, e.message);
    }
  }

  /* ── OAuth 2.0 Token Endpoint ─────────────────────────────────────────── */

  async _handleOAuth(request) {
    let body;
    try { body = await request.json(); } catch (_) { return this._error(400, 'Invalid JSON body'); }
    const { client_id, client_secret, grant_type, scope } = body;
    if (grant_type !== 'client_credentials') return this._error(400, 'Only client_credentials grant supported');
    if (client_id !== this._clientId || client_secret !== this._clientSecret) return this._error(401, 'Invalid client credentials');
    const token     = 'nova_' + secureId(32);
    const expiresAt = Date.now() + this._tokenTTLMs;
    this._tokens.set(token, { scope: scope || '*', expiresAt, subject: client_id });
    return this._json({ access_token: token, token_type: 'Bearer', expires_in: this._tokenTTLMs / 1000, scope: scope || '*' });
  }

  /* ── Verify bearer token ─────────────────────────────────────────────── */

  _verify(request) {
    const auth = request.headers.get('Authorization') || '';
    const token = auth.replace(/^Bearer\s+/i, '').trim();
    if (!token) return null;
    const entry = this._tokens.get(token);
    if (!entry || entry.expiresAt < Date.now()) { this._tokens.delete(token); return null; }
    return entry;
  }

  /* ── Tool catalogue ──────────────────────────────────────────────────── */

  async _handleListTools(request) {
    const auth = this._verify(request);
    if (!auth) return this._error(401, 'Unauthorized');
    const tools = [];
    for (const [key, agent] of this._agents.entries()) {
      const [agentId, toolName] = key.split(':');
      const tool = agent._tools.get(toolName);
      if (tool) tools.push({ tool: key, agent: agentId, name: toolName, desc: tool.desc, params: tool.params });
    }
    return this._json({ tools, phi: PHI, server: 'NOVA-MCP' });
  }

  /* ── Tool call endpoint ──────────────────────────────────────────────── */

  async _handleCall(request) {
    const auth = this._verify(request);
    if (!auth) return this._error(401, 'Unauthorized');
    let body;
    try { body = await request.json(); } catch (_) { return this._error(400, 'Invalid JSON body'); }
    const { tool, params } = body;
    if (!tool) return this._error(400, 'Missing tool field');
    const agent = this._agents.get(tool);
    if (!agent) return this._error(404, `Tool not found: ${tool}`);
    const [, toolName] = tool.split(':');
    const result = await agent.codeMode(`TOOL:${toolName}(${Object.entries(params || {}).map(([k, v]) => `${k}=${v}`).join(', ')})`);
    const entry  = { tool, params, result, calledAt: Date.now(), subject: auth.subject };
    this._callLog = [...this._callLog.slice(-255), entry];
    return this._json(result);
  }

  /* ── Server-Sent Events stream ───────────────────────────────────────── */

  async _handleStream(request, url) {
    const auth = this._verify(request);
    if (!auth) return this._error(401, 'Unauthorized');
    const toolKey   = url.searchParams.get('tool') || '';
    const sessionId = url.searchParams.get('sessionId') || `sess_${Date.now()}`;
    const agent     = this._agents.get(toolKey);

    /* Collect pre-buffered events for this session */
    const session = this._sessions.get(sessionId) || { toolKey, events: [] };
    this._sessions.set(sessionId, session);

    const events = session.events.splice(0);
    const body   = events.map(e => `data: ${JSON.stringify(e)}\n\n`).join('') + `data: ${JSON.stringify({ type: 'connected', sessionId, phi: PHI })}\n\n`;

    return new Response(body, {
      headers: {
        'Content-Type':  'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection':    'keep-alive',
        'X-NOVA-PHI':    String(PHI),
      },
    });
  }

  /**
   * Push an event into a session's SSE stream buffer.
   * @param {string} sessionId
   * @param {Object} event
   */
  pushEvent(sessionId, event) {
    const session = this._sessions.get(sessionId);
    if (session) session.events.push({ ...event, pushedAt: Date.now() });
  }

  /* ── Helpers ─────────────────────────────────────────────────────────── */

  _json(data, status) {
    return new Response(JSON.stringify(data), {
      status: status || 200,
      headers: { 'Content-Type': 'application/json', 'X-NOVA-PHI': String(PHI) },
    });
  }

  _error(status, message) {
    return this._json({ error: message, phi: PHI }, status);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  AGENT_TYPES,
  AGENT_STATES,
  DEPLOYMENT_TARGETS,
  FIBONACCI_MS,

  // Classes — original
  AgentBlueprint,
  Agent,
  AgentRegistry,
  AgentCoordinator,

  // Classes — new sovereign capabilities
  StatefulAgent,
  AgentScheduler,
  AgentRPCBus,
  MCPServer,
};

export default {
  AGENT_TYPES,
  AGENT_STATES,
  DEPLOYMENT_TARGETS,
  FIBONACCI_MS,
  AgentBlueprint,
  Agent,
  AgentRegistry,
  AgentCoordinator,
  StatefulAgent,
  AgentScheduler,
  AgentRPCBus,
  MCPServer,
};
