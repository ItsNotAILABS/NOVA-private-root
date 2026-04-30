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
// §6 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  AGENT_TYPES,
  AGENT_STATES,
  DEPLOYMENT_TARGETS,
  
  // Classes
  AgentBlueprint,
  Agent,
  AgentRegistry,
  AgentCoordinator,
};

export default {
  AGENT_TYPES,
  AGENT_STATES,
  DEPLOYMENT_TARGETS,
  AgentBlueprint,
  Agent,
  AgentRegistry,
  AgentCoordinator,
};
