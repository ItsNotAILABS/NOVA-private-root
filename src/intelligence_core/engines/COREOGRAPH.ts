// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// COREOGRAPH ENGINE — Sovereign Orchestration Engine (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// COREOGRAPH is the "physics of coordination" for the organism. All inter-agent
// communication, event routing, and orchestration flows through here. This is NOT
// an event emitter — this is a living orchestration engine with priority queues,
// φ-weighted routing, and consensus mechanisms across all agents.
//
// Used by: All agents for inter-agent communication and coordination
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PHI_INV, clamp } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — MESSAGE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type MessagePriority = 'CRITICAL' | 'HIGH' | 'NORMAL' | 'LOW' | 'BACKGROUND';

export interface Message {
  id: string;
  type: string;
  source: string;
  target: string | '*';  // '*' = broadcast
  payload: unknown;
  priority: MessagePriority;
  timestamp: number;
  ttl: number;           // Time-to-live in beats
  replyTo?: string;
}

export interface Route {
  source: string;
  target: string;
  channel: string;
  weight: number;        // φ-weighted routing priority
  active: boolean;
}

export interface CoreographState {
  agents: Map<string, AgentHandle>;
  routes: Map<string, Route>;
  messageQueue: Message[];
  processed: number;
  dropped: number;
  beat: number;
}

export interface AgentHandle {
  id: string;
  inbox: Message[];
  handler: ((msg: Message) => void) | null;
  status: 'DORMANT' | 'AWAKENING' | 'ALIVE' | 'SLEEPING' | 'DEAD';
  lastActivity: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — PRIORITY WEIGHTS
// ═══════════════════════════════════════════════════════════════════════════════

const PRIORITY_WEIGHTS: Record<MessagePriority, number> = {
  CRITICAL:   Math.pow(PHI, 4),  // 6.85
  HIGH:       Math.pow(PHI, 2),  // 2.62
  NORMAL:     1.0,
  LOW:        PHI_INV,           // 0.618
  BACKGROUND: Math.pow(PHI_INV, 2), // 0.382
};

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — COREOGRAPH ENGINE CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class CoreographEngine {
  private state: CoreographState;
  private messageIdCounter: number = 0;

  constructor() {
    this.state = {
      agents: new Map(),
      routes: new Map(),
      messageQueue: [],
      processed: 0,
      dropped: 0,
      beat: 0,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // AGENT REGISTRATION
  // ─────────────────────────────────────────────────────────────────────────────

  registerAgent(
    id: string,
    handler?: (msg: Message) => void
  ): void {
    const agent: AgentHandle = {
      id,
      inbox: [],
      handler: handler ?? null,
      status: 'DORMANT',
      lastActivity: Date.now(),
    };
    this.state.agents.set(id, agent);
  }

  unregisterAgent(id: string): void {
    this.state.agents.delete(id);
    // Remove routes involving this agent
    for (const [key, route] of this.state.routes) {
      if (route.source === id || route.target === id) {
        this.state.routes.delete(key);
      }
    }
  }

  setAgentHandler(id: string, handler: (msg: Message) => void): void {
    const agent = this.state.agents.get(id);
    if (agent) {
      agent.handler = handler;
    }
  }

  setAgentStatus(id: string, status: AgentHandle['status']): void {
    const agent = this.state.agents.get(id);
    if (agent) {
      agent.status = status;
      agent.lastActivity = Date.now();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ROUTING
  // ─────────────────────────────────────────────────────────────────────────────

  createRoute(
    source: string,
    target: string,
    channel: string,
    weight: number = 1.0
  ): void {
    const key = `${source}:${target}:${channel}`;
    this.state.routes.set(key, {
      source,
      target,
      channel,
      weight,
      active: true,
    });
  }

  disableRoute(source: string, target: string, channel: string): void {
    const key = `${source}:${target}:${channel}`;
    const route = this.state.routes.get(key);
    if (route) route.active = false;
  }

  enableRoute(source: string, target: string, channel: string): void {
    const key = `${source}:${target}:${channel}`;
    const route = this.state.routes.get(key);
    if (route) route.active = true;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // MESSAGING
  // ─────────────────────────────────────────────────────────────────────────────

  send(
    type: string,
    source: string,
    target: string | '*',
    payload: unknown,
    options: {
      priority?: MessagePriority;
      ttl?: number;
      replyTo?: string;
    } = {}
  ): string {
    const id = `msg_${Date.now()}_${this.messageIdCounter++}`;
    
    const message: Message = {
      id,
      type,
      source,
      target,
      payload,
      priority: options.priority ?? 'NORMAL',
      timestamp: Date.now(),
      ttl: options.ttl ?? 10,
      replyTo: options.replyTo,
    };

    this.state.messageQueue.push(message);
    this._sortQueue();

    return id;
  }

  broadcast(
    type: string,
    source: string,
    payload: unknown,
    options: {
      priority?: MessagePriority;
      ttl?: number;
    } = {}
  ): string {
    return this.send(type, source, '*', payload, options);
  }

  reply(
    originalMessage: Message,
    type: string,
    payload: unknown,
    options: { priority?: MessagePriority } = {}
  ): string {
    return this.send(
      type,
      originalMessage.target as string,
      originalMessage.source,
      payload,
      {
        priority: options.priority ?? originalMessage.priority,
        replyTo: originalMessage.id,
      }
    );
  }

  private _sortQueue(): void {
    // Sort by priority weight (descending)
    this.state.messageQueue.sort((a, b) => {
      const wA = PRIORITY_WEIGHTS[a.priority];
      const wB = PRIORITY_WEIGHTS[b.priority];
      return wB - wA;
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TICK — Process message queue
  // ─────────────────────────────────────────────────────────────────────────────

  tick(): void {
    this.state.beat++;

    // Decrement TTL and remove expired
    this.state.messageQueue = this.state.messageQueue.filter(msg => {
      msg.ttl--;
      if (msg.ttl <= 0) {
        this.state.dropped++;
        return false;
      }
      return true;
    });

    // Process messages
    const toProcess = this.state.messageQueue.splice(0, 100); // Process up to 100 per tick
    
    for (const msg of toProcess) {
      this._deliverMessage(msg);
    }
  }

  private _deliverMessage(msg: Message): void {
    if (msg.target === '*') {
      // Broadcast to all agents
      for (const [_id, agent] of this.state.agents) {
        if (agent.id !== msg.source && agent.status === 'ALIVE') {
          this._deliverToAgent(agent, msg);
        }
      }
    } else {
      // Deliver to specific target
      const agent = this.state.agents.get(msg.target);
      if (agent && agent.status === 'ALIVE') {
        this._deliverToAgent(agent, msg);
      }
    }
    this.state.processed++;
  }

  private _deliverToAgent(agent: AgentHandle, msg: Message): void {
    agent.inbox.push(msg);
    agent.lastActivity = Date.now();
    
    // Call handler if registered
    if (agent.handler) {
      try {
        agent.handler(msg);
      } catch (e) {
        console.error(`Agent ${agent.id} handler error:`, e);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // INBOX OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  getInbox(agentId: string): Message[] {
    return this.state.agents.get(agentId)?.inbox ?? [];
  }

  clearInbox(agentId: string): void {
    const agent = this.state.agents.get(agentId);
    if (agent) {
      agent.inbox = [];
    }
  }

  popInbox(agentId: string): Message | undefined {
    const agent = this.state.agents.get(agentId);
    return agent?.inbox.shift();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // QUERIES
  // ─────────────────────────────────────────────────────────────────────────────

  getAgentStatus(id: string): AgentHandle['status'] | undefined {
    return this.state.agents.get(id)?.status;
  }

  getActiveAgents(): string[] {
    const active: string[] = [];
    for (const [id, agent] of this.state.agents) {
      if (agent.status === 'ALIVE') {
        active.push(id);
      }
    }
    return active;
  }

  getQueueDepth(): number {
    return this.state.messageQueue.length;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CONSENSUS
  // ─────────────────────────────────────────────────────────────────────────────

  requestConsensus(
    topic: string,
    source: string,
    options: unknown
  ): Promise<Map<string, unknown>> {
    return new Promise((resolve) => {
      const responses = new Map<string, unknown>();
      const agents = this.getActiveAgents().filter(id => id !== source);
      
      if (agents.length === 0) {
        resolve(responses);
        return;
      }

      // Send consensus request
      this.broadcast(`CONSENSUS_REQUEST:${topic}`, source, options, { priority: 'HIGH' });

      // Collect responses (simplified — in production would use proper async)
      setTimeout(() => {
        for (const agentId of agents) {
          const inbox = this.getInbox(agentId);
          const response = inbox.find(m => m.type === `CONSENSUS_RESPONSE:${topic}`);
          if (response) {
            responses.set(agentId, response.payload);
          }
        }
        resolve(responses);
      }, 100);
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DIAGNOSTICS
  // ─────────────────────────────────────────────────────────────────────────────

  getDiagnostics(): {
    agentCount: number;
    activeAgents: number;
    routeCount: number;
    queueDepth: number;
    processed: number;
    dropped: number;
    beat: number;
  } {
    const activeCount = Array.from(this.state.agents.values())
      .filter(a => a.status === 'ALIVE').length;
    
    return {
      agentCount: this.state.agents.size,
      activeAgents: activeCount,
      routeCount: this.state.routes.size,
      queueDepth: this.state.messageQueue.length,
      processed: this.state.processed,
      dropped: this.state.dropped,
      beat: this.state.beat,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON EXPORT
// ═══════════════════════════════════════════════════════════════════════════════

export const COREOGRAPH = new CoreographEngine();
