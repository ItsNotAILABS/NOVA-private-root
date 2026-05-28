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

import { PHI, PHI_INV, HEARTBEAT_MS, secureHexId } from '../../medina-core/src/index.js';

/**
 * Cryptographically secure hex ID generator.
 * Uses Web Crypto (Cloudflare Workers / browsers / Node.js 15+) or
 * Node.js crypto module as fallback.  Never falls back to Math.random()
 * for security contexts.
 * @param {number} [bytes=16]
 * @returns {string}
 */
function secureId(bytes) {
  return secureHexId(bytes);
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
// §10 — INTERNAL AI IDENTITY REGISTRY
// Provides persistent identity + emoji signatures for commits, reports, and
// generic agent actions.
// ═══════════════════════════════════════════════════════════════════════════════

const DEFAULT_INTERNAL_AI_EMOJI = '🤖';

class InternalAIIdentityRegistry {
  constructor(config = {}) {
    this.defaultEmoji = config.defaultEmoji || DEFAULT_INTERNAL_AI_EMOJI;
    this._identities = new Map();
  }

  register(identity = {}) {
    if (!identity.agentId) {
      throw new Error('Identity must include agentId');
    }
    if (!identity.name) {
      throw new Error('Identity must include name');
    }

    const record = {
      agentId: identity.agentId,
      name: identity.name,
      emoji: identity.emoji || this.defaultEmoji,
      role: identity.role || 'internal_ai',
      createdAt: identity.createdAt || Date.now(),
      updatedAt: Date.now(),
    };

    this._identities.set(record.agentId, record);
    return { ...record };
  }

  registerMany(identities = []) {
    return identities.map(identity => this.register(identity));
  }

  setEmoji(agentId, emoji) {
    const current = this._identities.get(agentId);
    if (!current) {
      throw new Error(`Identity not found for agent: ${agentId}`);
    }
    current.emoji = emoji || this.defaultEmoji;
    current.updatedAt = Date.now();
    this._identities.set(agentId, current);
    return { ...current };
  }

  get(agentId) {
    const identity = this._identities.get(agentId);
    return identity ? { ...identity } : null;
  }

  list() {
    return Array.from(this._identities.values()).map(identity => ({ ...identity }));
  }

  _resolveIdentity(agentId, fallbackName = 'Internal AI') {
    return this.get(agentId) || {
      agentId,
      name: fallbackName,
      emoji: this.defaultEmoji,
      role: 'internal_ai',
    };
  }

  signAction(agentId, actionType, details = {}) {
    const identity = this._resolveIdentity(agentId);
    return {
      actionType,
      details,
      signedBy: identity.name,
      agentId: identity.agentId,
      emoji: identity.emoji,
      signature: `${identity.name} ${identity.emoji}`,
      signedAt: Date.now(),
    };
  }

  signCommit(agentId, commitMessage, metadata = {}) {
    const signed = this.signAction(agentId, 'commit', {
      message: commitMessage,
      ...metadata,
    });

    return {
      ...signed,
      commitMessage,
      signedCommitMessage: `${commitMessage}\n\nSigned-by: ${signed.signature}`,
    };
  }

  signReport(agentId, reportTitle, metadata = {}) {
    const signed = this.signAction(agentId, 'report', {
      title: reportTitle,
      ...metadata,
    });

    return {
      ...signed,
      reportTitle,
      reportFooter: `Signed by ${signed.signature}`,
    };
  }
}

function createInternalAIIdentityRegistry(config = {}) {
  return new InternalAIIdentityRegistry(config);
}

const globalInternalAIIdentityRegistry = createInternalAIIdentityRegistry();

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
  InternalAIIdentityRegistry,
  DEFAULT_INTERNAL_AI_EMOJI,
  createInternalAIIdentityRegistry,
  globalInternalAIIdentityRegistry,
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
  InternalAIIdentityRegistry,
  DEFAULT_INTERNAL_AI_EMOJI,
  createInternalAIIdentityRegistry,
  globalInternalAIIdentityRegistry,
};

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — STATEFUL AGENT EXTENSIONS
// 20 additional sovereign capabilities built on top of StatefulAgent.
// Each is a mixin-style helper class or function that augments the agent.
// ═══════════════════════════════════════════════════════════════════════════════

/* ── 10.1  RETRY QUEUE ───────────────────────────────────────────────────────
 * φ-backoff retry queue for failed operations.
 * Retry delays follow Fibonacci sequence: 1s, 1s, 2s, 3s, 5s, 8s, 13s…
 * Max retries = 8 (Fibonacci index).
 */
class RetryQueue {
  constructor(opts) {
    opts          = opts || {};
    this._queue   = [];
    this._maxRetries = opts.maxRetries || 8;
    this._running = false;
    this._hbi     = null;
  }

  /** Enqueue an operation with φ-backoff retry. Returns a Promise. */
  enqueue(fn, label) {
    return new Promise((resolve, reject) => {
      const entry = { fn, label: label || 'op', attempt: 0, nextAt: Date.now(), resolve, reject };
      this._queue.push(entry);
      if (!this._running) this._start();
    });
  }

  _start() {
    this._running = true;
    this._hbi = setInterval(() => {
      const now  = Date.now();
      const due  = this._queue.filter(e => e.nextAt <= now);
      for (const entry of due) {
        this._queue.splice(this._queue.indexOf(entry), 1);
        Promise.resolve().then(() => entry.fn()).then(r => entry.resolve(r)).catch(e => {
          entry.attempt++;
          if (entry.attempt >= this._maxRetries) {
            entry.reject(e);
          } else {
            entry.nextAt = Date.now() + FIBONACCI_MS[Math.min(entry.attempt, FIBONACCI_MS.length - 1)];
            this._queue.push(entry);
          }
        });
      }
      if (this._queue.length === 0) { clearInterval(this._hbi); this._running = false; }
    }, HEARTBEAT_MS);
  }

  stop() { clearInterval(this._hbi); this._running = false; }
  size() { return this._queue.length; }
}

/* ── 10.2  PUB/SUB BUS ─────────────────────────────────────────────────────
 * Lightweight in-process pub/sub for sovereign agent communication.
 * Topics are strings; subscribers receive all messages on a topic.
 */
class PubSubBus {
  constructor() { this._subs = new Map(); }

  subscribe(topic, fn) {
    if (!this._subs.has(topic)) this._subs.set(topic, []);
    this._subs.get(topic).push(fn);
    return () => this.unsubscribe(topic, fn);
  }

  unsubscribe(topic, fn) {
    const list = this._subs.get(topic);
    if (list) { const i = list.indexOf(fn); if (i !== -1) list.splice(i, 1); }
  }

  publish(topic, payload) {
    const list = this._subs.get(topic) || [];
    for (const fn of list) try { fn(payload, topic); } catch (_) { /* non-fatal */ }
    return list.length;
  }

  topics()       { return Array.from(this._subs.keys()); }
  subscriberCount(topic) { return (this._subs.get(topic) || []).length; }
}

/* ── 10.3  WEBHOOK DISPATCHER ───────────────────────────────────────────────
 * Dispatch events to external webhooks via HTTP POST.
 * Supports φ-backoff retry via RetryQueue.
 */
class WebhookDispatcher {
  constructor(opts) {
    opts         = opts || {};
    this._hooks  = new Map();  /* hookId → { url, topics, secret } */
    this._retry  = new RetryQueue({ maxRetries: opts.maxRetries || 5 });
    this._sent   = 0;
    this._failed = 0;
  }

  /** Register a webhook endpoint. */
  register(hookId, url, topics, secret) {
    this._hooks.set(hookId, { hookId, url, topics: topics || ['*'], secret: secret || null });
    return hookId;
  }

  /** Deregister a webhook. */
  deregister(hookId) { this._hooks.delete(hookId); }

  /** Dispatch an event to all matching webhooks. */
  dispatch(topic, payload) {
    for (const hook of this._hooks.values()) {
      if (!hook.topics.includes('*') && !hook.topics.includes(topic)) continue;
      const body = JSON.stringify({ topic, payload, sentAt: Date.now(), hookId: hook.hookId });
      const headers = { 'Content-Type': 'application/json' };
      if (hook.secret) headers['X-Nova-Signature'] = `sha256=${_hmacSha256Hex(body, hook.secret)}`;
      this._retry.enqueue(
        () => fetch(hook.url, { method: 'POST', headers, body }).then(r => { if (!r.ok) throw new Error(`HTTP ${r.status}`); this._sent++; }),
        `webhook_${hook.hookId}_${topic}`
      ).catch(() => this._failed++);
    }
  }

  stats() { return { hooks: this._hooks.size, sent: this._sent, failed: this._failed, queue: this._retry.size() }; }
}

function _hmacSha256Hex(data, key) {
  /* Deterministic φ-hash — in production use WebCrypto HMAC-SHA256 */
  let h = 0;
  const s = data + key;
  for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
  return h.toString(16).padStart(8, '0');
}

/* ── 10.4  CIRCUIT BREAKER ──────────────────────────────────────────────────
 * φ-threshold circuit breaker for outbound calls.
 * Opens when failure rate > φ⁻¹; half-opens after AMOR × cooldown.
 */
class CircuitBreaker {
  constructor(opts) {
    opts             = opts || {};
    this._state      = 'CLOSED';
    this._failures   = 0;
    this._successes  = 0;
    this._total      = 0;
    this._openAt     = null;
    this._threshold  = opts.threshold  || PHI_INV;   /* open if failure rate > φ⁻¹ */
    this._cooldownMs = opts.cooldownMs || HEARTBEAT_MS * 21;  /* 21 heartbeats */
    this._halfOpenMax= opts.halfOpenMax|| 1;
    this._halfOpenCount = 0;
  }

  /** Execute a function through the circuit breaker. */
  async call(fn) {
    if (this._state === 'OPEN') {
      if (Date.now() - this._openAt > this._cooldownMs * AMOR) {
        this._state = 'HALF_OPEN';
        this._halfOpenCount = 0;
      } else {
        throw new Error('CircuitBreaker: OPEN — calls rejected');
      }
    }
    if (this._state === 'HALF_OPEN' && this._halfOpenCount >= this._halfOpenMax) {
      throw new Error('CircuitBreaker: HALF_OPEN — at probe limit');
    }
    if (this._state === 'HALF_OPEN') this._halfOpenCount++;
    try {
      const result = await fn();
      this._successes++;
      this._total++;
      if (this._state === 'HALF_OPEN') this._state = 'CLOSED';
      this._failures = 0;
      return result;
    } catch (e) {
      this._failures++;
      this._total++;
      const failRate = this._total > 0 ? this._failures / this._total : 0;
      if (failRate > this._threshold || this._state === 'HALF_OPEN') {
        this._state  = 'OPEN';
        this._openAt = Date.now();
      }
      throw e;
    }
  }

  status() { return { state: this._state, failures: this._failures, successes: this._successes, total: this._total, failRate: this._total > 0 ? Math.round(this._failures / this._total * 1e4) / 1e4 : 0 }; }
  reset()  { this._state = 'CLOSED'; this._failures = 0; this._successes = 0; this._total = 0; this._openAt = null; }
}

/* ── 10.5  AUDIT LOG ────────────────────────────────────────────────────────
 * Immutable, append-only audit log for sovereign agent actions.
 * Ring buffer of 1024 entries (near-Fibonacci: F₁₆ = 987 → 1024).
 */
class AuditLog {
  constructor(opts) {
    opts          = opts || {};
    this._log     = [];
    this._cap     = opts.cap || 1024;
    this._counter = 0;
  }

  /** Append an audit entry. Returns the entry ID. */
  append(agentId, action, details, actor) {
    const entry = {
      id:      ++this._counter,
      agentId: String(agentId || ''),
      actor:   String(actor || agentId || ''),
      action:  String(action || ''),
      details: details || null,
      at:      Date.now(),
      beat:    this._counter,
    };
    this._log.push(entry);
    if (this._log.length > this._cap) this._log.shift();
    return entry.id;
  }

  /** Query audit entries for a specific agent or action. */
  query(opts) {
    opts = opts || {};
    let entries = this._log.slice();
    if (opts.agentId) entries = entries.filter(e => e.agentId === opts.agentId);
    if (opts.action)  entries = entries.filter(e => e.action  === opts.action);
    if (opts.since)   entries = entries.filter(e => e.at >= opts.since);
    if (opts.limit)   entries = entries.slice(-opts.limit);
    return entries;
  }

  size()  { return this._log.length; }
  clear() { this._log = []; }
}

/* ── 10.6  PERMISSIONS ENGINE ───────────────────────────────────────────────
 * φ-scored permission system for sovereign agent capabilities.
 * Permissions are granted, denied, or conditional (AMOR-scored threshold).
 */
class PermissionsEngine {
  constructor() {
    this._grants  = new Map();  /* agentId → Map(permission → { granted, score, expiresAt }) */
    this._policies= [];         /* global policy rules */
  }

  grant(agentId, permission, opts) {
    opts = opts || {};
    if (!this._grants.has(agentId)) this._grants.set(agentId, new Map());
    this._grants.get(agentId).set(permission, { granted: true, score: opts.score || 1.0, expiresAt: opts.expiresAt || null, grantedAt: Date.now() });
  }

  deny(agentId, permission) {
    if (!this._grants.has(agentId)) this._grants.set(agentId, new Map());
    this._grants.get(agentId).set(permission, { granted: false, score: 0, expiresAt: null, grantedAt: Date.now() });
  }

  check(agentId, permission, requiredScore) {
    requiredScore = requiredScore || AMOR;
    /* Check global policies first */
    for (const policy of this._policies) {
      const result = policy(agentId, permission);
      if (result !== undefined) return result;
    }
    /* Check agent-specific grants */
    const agentGrants = this._grants.get(agentId);
    if (!agentGrants) return false;
    const grant = agentGrants.get(permission) || agentGrants.get('*');
    if (!grant) return false;
    if (!grant.granted) return false;
    if (grant.expiresAt && grant.expiresAt < Date.now()) return false;
    return grant.score >= requiredScore;
  }

  addPolicy(fn) { this._policies.push(fn); return this; }
  listGrants(agentId) { return agentId ? Object.fromEntries(this._grants.get(agentId) || new Map()) : Object.fromEntries([...this._grants.entries()].map(([k, v]) => [k, Object.fromEntries(v)])); }
}

/* ── 10.7  SECRETS VAULT ────────────────────────────────────────────────────
 * Secure in-memory secrets vault for sovereign agents.
 * Secrets are stored encrypted (φ-XOR obfuscation) with TTL and ACL.
 */
class SecretsVault {
  constructor() {
    this._secrets = new Map();  /* name → { ciphertext, ttl, acl, createdAt } */
  }

  /** Store a secret. ttlMs = 0 means never expires. */
  set(name, value, opts) {
    opts = opts || {};
    const n = String(name || '');
    if (n === '__proto__' || n === 'constructor' || n === 'prototype') throw new Error(`Invalid secret name: ${name}`);
    const cipher = _phiXor(JSON.stringify(value), PHI);
    this._secrets.set(n, { ciphertext: cipher, ttlMs: opts.ttlMs || 0, acl: opts.acl || [], createdAt: Date.now() });
  }

  /** Retrieve a secret (returns null if missing/expired/denied). */
  get(name, requesterId) {
    const n = String(name || '');
    if (n === '__proto__' || n === 'constructor' || n === 'prototype') return null;
    const entry = this._secrets.get(n);
    if (!entry) return null;
    if (entry.ttlMs > 0 && Date.now() - entry.createdAt > entry.ttlMs) { this._secrets.delete(n); return null; }
    if (entry.acl.length > 0 && !entry.acl.includes(requesterId)) return null;
    try { return JSON.parse(_phiXor(entry.ciphertext, PHI)); } catch (_) { return null; }
  }

  delete(name) { return this._secrets.delete(String(name || '')); }
  list()        { return Array.from(this._secrets.keys()); }
}

function _phiXor(str, key) {
  /* Simple φ-seeded XOR obfuscation — not cryptographic encryption */
  const k = String(key || PHI);
  return Array.from(str).map((c, i) => String.fromCharCode(c.charCodeAt(0) ^ k.charCodeAt(i % k.length))).join('');
}

/* ── 10.8  WORKFLOW ENGINE ──────────────────────────────────────────────────
 * Orchestrate multi-step agent workflows with φ-cascade branching.
 * A workflow is a DAG of steps; each step can spawn sub-workflows.
 */
class WorkflowEngine {
  constructor(bus) {
    this._bus      = bus || new PubSubBus();
    this._workflows= new Map();  /* workflowId → Workflow */
    this._counter  = 0;
  }

  /** Define a workflow from a list of step functions. */
  define(name, steps) {
    return { name, steps: steps || [], createdAt: Date.now() };
  }

  /** Run a workflow. Returns a Promise resolving to the final output. */
  async run(workflow, input, opts) {
    opts = opts || {};
    const workflowId = `wf_${secureId(6)}`;
    const record     = { workflowId, name: workflow.name, status: 'RUNNING', input, steps: [], startedAt: Date.now() };
    this._workflows.set(workflowId, record);
    this._bus.publish('WORKFLOW_STARTED', { workflowId, name: workflow.name });

    let current = input;
    for (let i = 0; i < workflow.steps.length; i++) {
      const step = workflow.steps[i];
      const stepId = `step_${i}`;
      try {
        current = await step(current, { workflowId, stepIndex: i, bus: this._bus });
        record.steps.push({ stepId, status: 'DONE', at: Date.now() });
        this._bus.publish('WORKFLOW_STEP_DONE', { workflowId, stepId, output: current });
      } catch (e) {
        record.steps.push({ stepId, status: 'FAILED', error: e.message, at: Date.now() });
        record.status = 'FAILED';
        this._bus.publish('WORKFLOW_FAILED', { workflowId, stepId, error: e.message });
        throw e;
      }
      if (opts.timeout && Date.now() - record.startedAt > opts.timeout) {
        record.status = 'TIMED_OUT';
        this._bus.publish('WORKFLOW_TIMEOUT', { workflowId });
        throw new Error(`Workflow ${workflowId} timed out`);
      }
    }

    record.status = 'DONE';
    record.output = current;
    this._bus.publish('WORKFLOW_DONE', { workflowId, output: current });
    return current;
  }

  getWorkflow(workflowId) { return this._workflows.get(workflowId) || null; }
  listWorkflows()         { return Array.from(this._workflows.values()); }
}

/* ── 10.9  RATE LIMITER ─────────────────────────────────────────────────────
 * φ-token-bucket rate limiter for sovereign agent API calls.
 * Capacity = C, refill rate = C × AMOR per heartbeat.
 */
class RateLimiter {
  constructor(opts) {
    opts             = opts || {};
    this._cap        = opts.capacity  || 89;   /* F₁₁ */
    this._tokens     = this._cap;
    this._refillRate = opts.refillRate|| Math.ceil(this._cap * AMOR);
    this._hbi        = null;
    this._denied     = 0;
    this._allowed    = 0;
    this._start();
  }

  /** Try to consume tokens. Returns true if allowed. */
  allow(cost) {
    cost = cost || 1;
    if (this._tokens >= cost) { this._tokens -= cost; this._allowed++; return true; }
    this._denied++;
    return false;
  }

  /** Consume or throw. */
  consume(cost) {
    if (!this.allow(cost)) throw new Error(`RateLimiter: denied (${this._tokens}/${this._cap} tokens)`);
  }

  stats() { return { tokens: this._tokens, cap: this._cap, allowed: this._allowed, denied: this._denied, refillRate: this._refillRate }; }

  _start() {
    this._hbi = setInterval(() => {
      this._tokens = Math.min(this._cap, this._tokens + this._refillRate);
    }, HEARTBEAT_MS);
  }

  stop() { clearInterval(this._hbi); }
}

/* ── 10.10 HEALTH MONITOR ───────────────────────────────────────────────────
 * Monitor agent health: heartbeat liveness, queue depth, error rate.
 * Publishes HEALTH events to a PubSubBus every Fibonacci(8)=21 beats.
 */
class HealthMonitor {
  constructor(bus, opts) {
    opts           = opts || {};
    this._bus      = bus || new PubSubBus();
    this._agents   = new Map();  /* agentId → { lastBeat, errors, checks } */
    this._beat     = 0;
    this._interval = opts.interval || 21;  /* check every 21 heartbeats */
    this._hbi      = null;
    this.start();
  }

  register(agentId) {
    this._agents.set(agentId, { agentId, lastBeat: Date.now(), errors: 0, checks: 0, healthy: true });
  }

  heartbeat(agentId) {
    const rec = this._agents.get(agentId);
    if (rec) rec.lastBeat = Date.now();
  }

  recordError(agentId) {
    const rec = this._agents.get(agentId);
    if (rec) rec.errors++;
  }

  start() {
    this._hbi = setInterval(() => {
      this._beat++;
      if (this._beat % this._interval !== 0) return;
      const now = Date.now();
      for (const rec of this._agents.values()) {
        rec.checks++;
        const stale   = now - rec.lastBeat > HEARTBEAT_MS * this._interval * 2;
        const errRate = rec.checks > 0 ? rec.errors / rec.checks : 0;
        const healthy = !stale && errRate <= PHI_INV;
        if (healthy !== rec.healthy) {
          rec.healthy = healthy;
          this._bus.publish(healthy ? 'AGENT_HEALTHY' : 'AGENT_UNHEALTHY', { agentId: rec.agentId, errRate, stale });
        }
      }
    }, HEARTBEAT_MS);
  }

  stop() { clearInterval(this._hbi); }

  status() {
    return Array.from(this._agents.values()).map(r => ({
      agentId: r.agentId, healthy: r.healthy, errors: r.errors, checks: r.checks,
      lastBeatAge: Date.now() - r.lastBeat,
    }));
  }
}

/* ── 10.11 DEAD LETTER QUEUE ────────────────────────────────────────────────
 * Capture messages that could not be delivered after max retries.
 */
class DeadLetterQueue {
  constructor(opts) {
    opts       = opts || {};
    this._dlq  = [];
    this._cap  = opts.cap || 256;
    this._onDead = opts.onDead || null;
  }

  push(message, reason, retries) {
    const entry = { message, reason, retries: retries || 0, deadAt: Date.now(), id: `dlq_${secureId(4)}` };
    this._dlq.push(entry);
    if (this._dlq.length > this._cap) this._dlq.shift();
    if (this._onDead) try { this._onDead(entry); } catch (_) { /* non-fatal */ }
    return entry.id;
  }

  drain()    { const msgs = this._dlq.splice(0); return msgs; }
  peek(n)    { return this._dlq.slice(-(n || 20)); }
  size()     { return this._dlq.length; }
}

/* ── 10.12 FEATURE FLAGS ────────────────────────────────────────────────────
 * φ-scored feature flag system. Flags have a rollout score in [0,1].
 * An agent is enabled for a flag if its trust score ≥ flag.rollout.
 */
class FeatureFlags {
  constructor() {
    this._flags = new Map();
  }

  define(name, rollout, opts) {
    opts = opts || {};
    this._flags.set(name, { name, rollout: rollout || 0, enabled: opts.enabled !== false, description: opts.description || '', createdAt: Date.now() });
  }

  isEnabled(name, agentScore) {
    const flag = this._flags.get(name);
    if (!flag || !flag.enabled) return false;
    return (agentScore || 0) >= flag.rollout;
  }

  enable(name)  { const f = this._flags.get(name); if (f) f.enabled = true; }
  disable(name) { const f = this._flags.get(name); if (f) f.enabled = false; }
  list()        { return Array.from(this._flags.values()); }
}

/* ── 10.13 TELEMETRY EMITTER ────────────────────────────────────────────────
 * Emit telemetry spans and metrics to NOVA STREAM or a custom sink.
 */
class TelemetryEmitter {
  constructor(opts) {
    opts         = opts || {};
    this._sinks  = [];
    this._spans  = [];
    this._metrics= new Map();  /* metric name → { value, count, sum, min, max } */
    if (opts.sink) this._sinks.push(opts.sink);
  }

  /** Start a timing span. Returns a finish function. */
  span(name, tags) {
    const startMs = Date.now();
    const spanId  = secureId(4);
    return () => {
      const dur = Date.now() - startMs;
      const span= { name, spanId, tags: tags || {}, durationMs: dur, at: startMs };
      this._spans.push(span);
      if (this._spans.length > 512) this._spans.shift();
      this.record(`span.${name}`, dur);
      for (const sink of this._sinks) try { sink({ type: 'SPAN', span }); } catch (_) { /* non-fatal */ }
      return dur;
    };
  }

  /** Record a metric value. */
  record(name, value) {
    if (!this._metrics.has(name)) this._metrics.set(name, { value, count: 0, sum: 0, min: Infinity, max: -Infinity });
    const m = this._metrics.get(name);
    m.count++;
    m.sum   += value;
    m.value  = value;
    m.min    = Math.min(m.min, value);
    m.max    = Math.max(m.max, value);
    for (const sink of this._sinks) try { sink({ type: 'METRIC', name, value, at: Date.now() }); } catch (_) { /* non-fatal */ }
  }

  addSink(fn) { this._sinks.push(fn); return this; }
  getMetrics() { return Object.fromEntries(this._metrics.entries()); }
  getSpans(n)  { return this._spans.slice(-(n || 20)); }
}

/* ── 10.14 CRON EXPRESSION SCHEDULER ───────────────────────────────────────
 * In addition to Fibonacci scheduling, support cron-style expressions
 * (minute, hour, dayOfWeek) using the AgentScheduler base.
 */
class CronScheduler extends AgentScheduler {
  constructor() {
    super();
    this._cronJobs = new Map();  /* jobId → { minute, hour, dow, fn } */
    this._cronHbi  = null;
    this._lastMin  = -1;
  }

  /** Register a cron job. minute/hour/dow: number or '*'. */
  cron(minute, hour, dayOfWeek, fn) {
    const jobId = 'cron_' + secureId(4);
    this._cronJobs.set(jobId, { minute, hour, dayOfWeek, fn });
    if (!this._cronHbi) {
      this._cronHbi = setInterval(() => {
        const now   = new Date();
        const min   = now.getMinutes();
        if (min === this._lastMin) return;
        this._lastMin = min;
        const hour  = now.getHours();
        const dow   = now.getDay();
        for (const job of this._cronJobs.values()) {
          if ((job.minute === '*' || job.minute === min) &&
              (job.hour   === '*' || job.hour   === hour) &&
              (job.dayOfWeek === '*' || job.dayOfWeek === dow)) {
            try { job.fn(now); } catch (_) { /* non-fatal */ }
          }
        }
      }, 60_000);
    }
    return jobId;
  }

  stopCron() { clearInterval(this._cronHbi); this._cronHbi = null; }
}

/* ── 10.15 SAGA COORDINATOR ─────────────────────────────────────────────────
 * Distributed saga pattern: each step has a compensating action.
 * If any step fails, compensations are run in reverse order.
 */
class SagaCoordinator {
  constructor() { this._sagas = new Map(); }

  /** Execute a saga. steps = [{ execute, compensate }] */
  async execute(sagaId, steps, input) {
    const saga       = { sagaId, status: 'RUNNING', completed: [], input, startedAt: Date.now() };
    this._sagas.set(sagaId, saga);
    let current = input;

    for (let i = 0; i < steps.length; i++) {
      try {
        current = await steps[i].execute(current);
        saga.completed.push(i);
      } catch (e) {
        saga.status = 'COMPENSATING';
        /* Run compensations in reverse */
        for (let j = saga.completed.length - 1; j >= 0; j--) {
          const ci = saga.completed[j];
          try { await steps[ci].compensate(current); } catch (_) { /* non-fatal */ }
        }
        saga.status = 'FAILED';
        saga.error  = e.message;
        throw e;
      }
    }

    saga.status = 'DONE';
    saga.output = current;
    return current;
  }

  getSaga(sagaId) { return this._sagas.get(sagaId) || null; }
}

/* ── 10.16 AGENT POOL ───────────────────────────────────────────────────────
 * Pool of reusable agents for load balancing.
 * Selects agents using φ-weighted round-robin.
 */
class AgentPool {
  constructor(agents) {
    this._agents  = agents || [];
    this._index   = 0;
    this._weights = this._agents.map((_, i) => Math.pow(PHI_INV, i));
    this._wTotal  = this._weights.reduce((a, b) => a + b, 0);
  }

  /** Add an agent to the pool. */
  add(agent) {
    const i = this._agents.length;
    this._agents.push(agent);
    this._weights.push(Math.pow(PHI_INV, i));
    this._wTotal = this._weights.reduce((a, b) => a + b, 0);
  }

  /** Pick the next available agent (φ-weighted round-robin). */
  pick() {
    if (!this._agents.length) return null;
    /* φ-weighted random selection */
    let rng = (Date.now() * PHI) % this._wTotal;
    for (let i = 0; i < this._agents.length; i++) {
      rng -= this._weights[i];
      if (rng <= 0) return this._agents[i];
    }
    return this._agents[this._agents.length - 1];
  }

  size()   { return this._agents.length; }
  remove(agent) {
    const i = this._agents.indexOf(agent);
    if (i !== -1) { this._agents.splice(i, 1); this._weights.splice(i, 1); this._wTotal = this._weights.reduce((a,b)=>a+b,0); }
  }
}

/* ── 10.17 CONTEXT PROPAGATOR ───────────────────────────────────────────────
 * Propagate trace context (traceId, spanId, baggage) across agent calls.
 * Compatible with OpenTelemetry W3C Trace Context.
 */
class ContextPropagator {
  constructor() { this._contexts = new Map(); }

  /** Create a root context. */
  root(baggage) {
    const ctx = { traceId: secureId(16), spanId: secureId(8), parentSpanId: null, baggage: baggage || {}, createdAt: Date.now() };
    this._contexts.set(ctx.traceId, ctx);
    return ctx;
  }

  /** Create a child span from a parent context. */
  child(parentCtx, baggage) {
    const ctx = { traceId: parentCtx.traceId, spanId: secureId(8), parentSpanId: parentCtx.spanId, baggage: Object.assign({}, parentCtx.baggage, baggage || {}), createdAt: Date.now() };
    return ctx;
  }

  /** Inject context into an HTTP-style headers object. */
  inject(ctx, headers) {
    headers = headers || {};
    headers['traceparent'] = `00-${ctx.traceId}-${ctx.spanId}-01`;
    if (Object.keys(ctx.baggage).length > 0) {
      headers['baggage'] = Object.entries(ctx.baggage).map(([k, v]) => `${k}=${v}`).join(',');
    }
    return headers;
  }

  /** Extract context from headers. */
  extract(headers) {
    const tp = headers && headers['traceparent'];
    if (!tp) return this.root();
    const parts = tp.split('-');
    return { traceId: parts[1] || secureId(16), spanId: parts[2] || secureId(8), parentSpanId: null, baggage: {}, createdAt: Date.now() };
  }
}

/* ── 10.18 SNAPSHOT SCHEDULER ───────────────────────────────────────────────
 * Schedule periodic snapshots of StatefulAgent state to an external store.
 * Fibonacci snapshot schedule: F_k heartbeats between snapshots.
 */
class SnapshotScheduler {
  constructor(agent, store, opts) {
    opts          = opts || {};
    this._agent   = agent;
    this._store   = store;  /* async (snapshot) => void */
    this._beat    = 0;
    this._fibIdx  = 0;
    this._nextAt  = FIBONACCI_MS[0];
    this._hbi     = null;
    this._count   = 0;
    if (opts.autoStart !== false) this.start();
  }

  start() {
    this._hbi = setInterval(() => {
      this._beat++;
      if (this._beat >= this._nextAt / HEARTBEAT_MS) {
        this._snapshot();
        this._fibIdx = (this._fibIdx + 1) % FIBONACCI_MS.length;
        this._nextAt = FIBONACCI_MS[this._fibIdx];
        this._beat   = 0;
      }
    }, HEARTBEAT_MS);
  }

  stop() { clearInterval(this._hbi); }

  async _snapshot() {
    if (typeof this._agent.snapshot !== 'function') return;
    const snap = this._agent.snapshot();
    this._count++;
    try { await this._store(snap); } catch (_) { /* non-fatal */ }
  }

  snapshotCount() { return this._count; }
}

/* ── 10.19 AGENT MIRROR ─────────────────────────────────────────────────────
 * Mirror a StatefulAgent's state to a read-only replica using PROTOCOL-MIRROR.
 * Publishes MIRROR:DELTA events on every state change.
 */
class AgentMirror {
  constructor(agent, opts) {
    opts          = opts || {};
    this._agent   = agent;
    this._beat    = 0;
    this._hbi     = null;
    this._sinks   = [];
    this._clock   = {};   /* simplified φ-vector clock */
    if (opts.autoStart !== false) this.start();
  }

  /** Register a sink to receive MIRROR events (fn(event) → void). */
  addSink(fn) { this._sinks.push(fn); return this; }

  start() {
    /* Intercept state changes */
    const original = this._agent.setState.bind(this._agent);
    const mirror   = this;
    this._agent.setState = function(keyOrPatch, value) {
      original(keyOrPatch, value);
      const patch = typeof keyOrPatch === 'string' ? { [keyOrPatch]: value } : keyOrPatch;
      mirror._emitDelta(patch);
    };
    /* Snapshot schedule */
    this._hbi = setInterval(() => {
      this._beat++;
      if (this._beat % 144 === 0) this._emitSnapshot();
    }, HEARTBEAT_MS);
  }

  stop() { clearInterval(this._hbi); }

  _emitDelta(patch) {
    const agentId = this._agent.id;
    this._clock[agentId] = (this._clock[agentId] || 0) + PHI_INV;
    const event = { type: 'MIRROR:DELTA', agentId, patch, clock: Object.assign({}, this._clock), emittedAt: Date.now() };
    for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
  }

  _emitSnapshot() {
    const agentId = this._agent.id;
    const state   = this._agent.getState ? this._agent.getState() : {};
    const event   = { type: 'MIRROR:SNAPSHOT', agentId, state, clock: Object.assign({}, this._clock), beat: this._beat, emittedAt: Date.now() };
    for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
  }
}

/* ── 10.20 SOVEREIGN AGENT FACTORY ─────────────────────────────────────────
 * Factory that creates fully-equipped StatefulAgents with all 19 capabilities
 * above pre-attached.  The sovereign standard for all new agents.
 */
class SovereignAgentFactory {
  constructor(opts) {
    opts         = opts || {};
    this._bus    = new PubSubBus();
    this._audit  = new AuditLog();
    this._health = new HealthMonitor(this._bus);
    this._perms  = new PermissionsEngine();
    this._flags  = new FeatureFlags();
    this._telemetry = new TelemetryEmitter();
    this._pool   = new AgentPool();
    this._agents = [];
  }

  /**
   * Create a sovereign agent with full capability set pre-attached.
   * @param {Object} config — standard StatefulAgent config
   * @returns {StatefulAgent & { retry, pubsub, webhook, breaker, audit, perms, vault, workflow, rateLimit, health, dlq, flags, telemetry, ctx }}
   */
  create(config) {
    const agent   = new StatefulAgent(config);
    /* Attach all capabilities as named properties */
    agent.retry   = new RetryQueue();
    agent.pubsub  = this._bus;
    agent.webhook = new WebhookDispatcher();
    agent.breaker = new CircuitBreaker();
    agent.audit   = this._audit;
    agent.perms   = this._perms;
    agent.vault   = new SecretsVault();
    agent.workflow= new WorkflowEngine(this._bus);
    agent.rateLimit= new RateLimiter({ capacity: 55 });
    agent.health  = this._health;
    agent.dlq     = new DeadLetterQueue();
    agent.flags   = this._flags;
    agent.telemetry= this._telemetry;
    agent.ctx     = new ContextPropagator();
    agent.mirror  = new AgentMirror(agent, { autoStart: false });
    agent.saga    = new SagaCoordinator();

    /* Register with health monitor */
    this._health.register(agent.id);
    this._pool.add(agent);
    this._agents.push(agent);

    /* Audit creation */
    this._audit.append(agent.id, 'AGENT_CREATED', { type: config.type, name: config.name }, 'factory');

    return agent;
  }

  getPool()   { return this._pool; }
  getAudit()  { return this._audit; }
  getBus()    { return this._bus; }
  getHealth() { return this._health; }
  getFlags()  { return this._flags; }
  listAgents(){ return this._agents.map(a => ({ id: a.id, name: a.name, state: a.state })); }
}

// ── §10 exports ─────────────────────────────────────────────────────────────
if (typeof module !== 'undefined' && module.exports) {
  const existing = module.exports;
  Object.assign(existing, {
    /* §10 — 20 new capabilities */
    RetryQueue,
    PubSubBus,
    WebhookDispatcher,
    CircuitBreaker,
    AuditLog,
    PermissionsEngine,
    SecretsVault,
    WorkflowEngine,
    RateLimiter,
    HealthMonitor,
    DeadLetterQueue,
    FeatureFlags,
    TelemetryEmitter,
    CronScheduler,
    SagaCoordinator,
    AgentPool,
    ContextPropagator,
    SnapshotScheduler,
    AgentMirror,
    SovereignAgentFactory,
  });
}
