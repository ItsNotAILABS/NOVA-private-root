/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-network — INTER-AGENT COMMUNICATION SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides networking capabilities for AI agents:
 *   - Peer-to-peer communication
 *   - Pub/sub messaging
 *   - Request/response patterns
 *   - Broadcast channels
 *   - Mesh networking
 *   - Service discovery
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const MESSAGE_TYPES = {
  REQUEST: 'REQUEST',
  RESPONSE: 'RESPONSE',
  EVENT: 'EVENT',
  BROADCAST: 'BROADCAST',
  HEARTBEAT: 'HEARTBEAT',
  DISCOVERY: 'DISCOVERY',
  ACK: 'ACK',
};

const CHANNEL_TYPES = {
  DIRECT: 'DIRECT',           // Point-to-point
  PUBSUB: 'PUBSUB',           // Publish/subscribe
  BROADCAST: 'BROADCAST',     // One-to-all
  MULTICAST: 'MULTICAST',     // One-to-many
};

const PEER_STATES = {
  UNKNOWN: 'UNKNOWN',
  DISCOVERING: 'DISCOVERING',
  CONNECTED: 'CONNECTED',
  DISCONNECTED: 'DISCONNECTED',
  UNREACHABLE: 'UNREACHABLE',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — MESSAGE
// ═══════════════════════════════════════════════════════════════════════════════

class Message {
  constructor(config) {
    this.id = config.id || `msg_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.type = config.type || MESSAGE_TYPES.EVENT;
    this.from = config.from;
    this.to = config.to;
    this.channel = config.channel || null;
    this.topic = config.topic || null;
    this.payload = config.payload;
    this.correlationId = config.correlationId || null;
    this.timestamp = Date.now();
    this.ttl = config.ttl || 30000; // 30 second default TTL
    this.hops = 0;
    this.maxHops = config.maxHops || 10;
  }
  
  /**
   * Check if message has expired
   */
  isExpired() {
    return Date.now() - this.timestamp > this.ttl;
  }
  
  /**
   * Increment hop count
   */
  hop() {
    this.hops++;
    return this.hops <= this.maxHops;
  }
  
  /**
   * Create a response to this message
   */
  createResponse(payload) {
    return new Message({
      type: MESSAGE_TYPES.RESPONSE,
      from: this.to,
      to: this.from,
      channel: this.channel,
      correlationId: this.id,
      payload,
    });
  }
  
  /**
   * Create an acknowledgment
   */
  createAck() {
    return new Message({
      type: MESSAGE_TYPES.ACK,
      from: this.to,
      to: this.from,
      correlationId: this.id,
      payload: { acknowledged: true },
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      from: this.from,
      to: this.to,
      channel: this.channel,
      topic: this.topic,
      payload: this.payload,
      correlationId: this.correlationId,
      timestamp: this.timestamp,
      ttl: this.ttl,
      hops: this.hops,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — PEER
// ═══════════════════════════════════════════════════════════════════════════════

class Peer {
  constructor(id, config = {}) {
    this.id = id;
    this.name = config.name || id;
    this.type = config.type || 'agent';
    this.capabilities = config.capabilities || [];
    this.metadata = config.metadata || {};
    
    this.state = PEER_STATES.UNKNOWN;
    this.lastSeen = null;
    this.latency = null;
    this.messageCount = 0;
    
    this._pendingRequests = new Map();
  }
  
  /**
   * Update peer as seen
   */
  seen() {
    this.lastSeen = Date.now();
    this.state = PEER_STATES.CONNECTED;
    return this;
  }
  
  /**
   * Check if peer is alive
   */
  isAlive(timeout = 30000) {
    if (!this.lastSeen) return false;
    return Date.now() - this.lastSeen < timeout;
  }
  
  /**
   * Record a pending request
   */
  addPendingRequest(messageId, callback, timeout = 30000) {
    this._pendingRequests.set(messageId, {
      callback,
      timestamp: Date.now(),
      timeout,
    });
  }
  
  /**
   * Resolve a pending request
   */
  resolvePendingRequest(correlationId, response) {
    const pending = this._pendingRequests.get(correlationId);
    if (pending) {
      this._pendingRequests.delete(correlationId);
      pending.callback(null, response);
      return true;
    }
    return false;
  }
  
  /**
   * Check for timed out requests
   */
  checkTimeouts() {
    const now = Date.now();
    for (const [id, pending] of this._pendingRequests) {
      if (now - pending.timestamp > pending.timeout) {
        this._pendingRequests.delete(id);
        pending.callback(new Error('Request timeout'), null);
      }
    }
  }
  
  toJSON() {
    return {
      id: this.id,
      name: this.name,
      type: this.type,
      capabilities: this.capabilities,
      state: this.state,
      lastSeen: this.lastSeen,
      latency: this.latency,
      messageCount: this.messageCount,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — CHANNEL
// ═══════════════════════════════════════════════════════════════════════════════

class Channel {
  constructor(id, type = CHANNEL_TYPES.PUBSUB) {
    this.id = id;
    this.type = type;
    this._subscribers = new Map();
    this._messageHistory = [];
    this._historyLimit = 100;
  }
  
  /**
   * Subscribe to the channel
   */
  subscribe(peerId, callback) {
    this._subscribers.set(peerId, callback);
    return () => this.unsubscribe(peerId);
  }
  
  /**
   * Unsubscribe from the channel
   */
  unsubscribe(peerId) {
    this._subscribers.delete(peerId);
    return this;
  }
  
  /**
   * Publish a message to the channel
   */
  publish(message) {
    message.channel = this.id;
    
    // Store in history
    this._messageHistory.push(message);
    while (this._messageHistory.length > this._historyLimit) {
      this._messageHistory.shift();
    }
    
    // Deliver to subscribers
    for (const [peerId, callback] of this._subscribers) {
      if (message.from !== peerId) {
        try {
          callback(message);
        } catch (e) {
          console.error(`Error delivering to ${peerId}:`, e);
        }
      }
    }
    
    return this;
  }
  
  /**
   * Get channel history
   */
  getHistory(limit = 50) {
    return this._messageHistory.slice(-limit);
  }
  
  /**
   * Get subscriber count
   */
  getSubscriberCount() {
    return this._subscribers.size;
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      subscriberCount: this._subscribers.size,
      historyCount: this._messageHistory.length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — NETWORK NODE
// ═══════════════════════════════════════════════════════════════════════════════

class NetworkNode {
  constructor(id, config = {}) {
    this.id = id;
    this.name = config.name || id;
    this.capabilities = config.capabilities || [];
    
    this._peers = new Map();
    this._channels = new Map();
    this._handlers = new Map();
    this._middleware = [];
    
    this._heartbeatInterval = null;
    this._running = false;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.1 — LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Start the network node
   */
  start() {
    if (this._running) return this;
    
    this._running = true;
    
    // Start heartbeat
    this._heartbeatInterval = setInterval(() => this._heartbeat(), HEARTBEAT_MS);
    
    return this;
  }
  
  /**
   * Stop the network node
   */
  stop() {
    this._running = false;
    
    if (this._heartbeatInterval) {
      clearInterval(this._heartbeatInterval);
      this._heartbeatInterval = null;
    }
    
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.2 — PEER MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Add a peer
   */
  addPeer(peerId, config = {}) {
    const peer = new Peer(peerId, config);
    this._peers.set(peerId, peer);
    return peer;
  }
  
  /**
   * Remove a peer
   */
  removePeer(peerId) {
    this._peers.delete(peerId);
    return this;
  }
  
  /**
   * Get a peer
   */
  getPeer(peerId) {
    return this._peers.get(peerId);
  }
  
  /**
   * Get all peers
   */
  getAllPeers() {
    return Array.from(this._peers.values());
  }
  
  /**
   * Get connected peers
   */
  getConnectedPeers() {
    return this.getAllPeers().filter(p => p.state === PEER_STATES.CONNECTED);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.3 — MESSAGING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Send a message to a peer
   */
  send(peerId, payload, options = {}) {
    const message = new Message({
      type: options.type || MESSAGE_TYPES.EVENT,
      from: this.id,
      to: peerId,
      payload,
      ...options,
    });
    
    return this._deliverMessage(message);
  }
  
  /**
   * Send a request and wait for response
   */
  async request(peerId, payload, timeout = 30000) {
    const peer = this._peers.get(peerId);
    if (!peer) {
      throw new Error(`Unknown peer: ${peerId}`);
    }
    
    const message = new Message({
      type: MESSAGE_TYPES.REQUEST,
      from: this.id,
      to: peerId,
      payload,
    });
    
    return new Promise((resolve, reject) => {
      const timeoutId = setTimeout(() => {
        reject(new Error('Request timeout'));
      }, timeout);
      
      peer.addPendingRequest(message.id, (err, response) => {
        clearTimeout(timeoutId);
        if (err) reject(err);
        else resolve(response);
      }, timeout);
      
      this._deliverMessage(message);
    });
  }
  
  /**
   * Broadcast to all connected peers
   */
  broadcast(payload, options = {}) {
    const message = new Message({
      type: MESSAGE_TYPES.BROADCAST,
      from: this.id,
      to: '*',
      payload,
      ...options,
    });
    
    for (const peer of this.getConnectedPeers()) {
      const peerMessage = new Message({
        ...message.toJSON(),
        to: peer.id,
      });
      this._deliverMessage(peerMessage);
    }
    
    return this;
  }
  
  /**
   * Handle incoming message
   */
  receive(message) {
    // Run through middleware
    for (const middleware of this._middleware) {
      message = middleware(message, this);
      if (!message) return; // Middleware can filter messages
    }
    
    // Handle responses
    if (message.type === MESSAGE_TYPES.RESPONSE || message.type === MESSAGE_TYPES.ACK) {
      const peer = this._peers.get(message.from);
      if (peer) {
        peer.resolvePendingRequest(message.correlationId, message);
      }
      return;
    }
    
    // Route to handlers
    const handler = this._handlers.get(message.type);
    if (handler) {
      const response = handler(message, this);
      
      // Auto-respond to requests
      if (message.type === MESSAGE_TYPES.REQUEST && response !== undefined) {
        const responseMessage = message.createResponse(response);
        this._deliverMessage(responseMessage);
      }
    }
    
    return this;
  }
  
  /**
   * Register a message handler
   */
  on(messageType, handler) {
    this._handlers.set(messageType, handler);
    return this;
  }
  
  /**
   * Add middleware
   */
  use(middleware) {
    this._middleware.push(middleware);
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.4 — CHANNELS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create or get a channel
   */
  channel(channelId, type = CHANNEL_TYPES.PUBSUB) {
    if (!this._channels.has(channelId)) {
      this._channels.set(channelId, new Channel(channelId, type));
    }
    return this._channels.get(channelId);
  }
  
  /**
   * Subscribe to a channel
   */
  subscribe(channelId, callback) {
    return this.channel(channelId).subscribe(this.id, callback);
  }
  
  /**
   * Publish to a channel
   */
  publish(channelId, payload) {
    const message = new Message({
      type: MESSAGE_TYPES.EVENT,
      from: this.id,
      payload,
    });
    this.channel(channelId).publish(message);
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.5 — SERVICE DISCOVERY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Announce presence to network
   */
  announce() {
    const discoveryMessage = new Message({
      type: MESSAGE_TYPES.DISCOVERY,
      from: this.id,
      to: '*',
      payload: {
        id: this.id,
        name: this.name,
        capabilities: this.capabilities,
      },
    });
    
    this.broadcast(discoveryMessage.payload, { type: MESSAGE_TYPES.DISCOVERY });
    return this;
  }
  
  /**
   * Find peers with specific capability
   */
  findPeersWithCapability(capability) {
    return this.getAllPeers().filter(p => 
      p.capabilities.includes(capability) && p.state === PEER_STATES.CONNECTED
    );
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.6 — INTERNAL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  _deliverMessage(message) {
    const peer = this._peers.get(message.to);
    if (peer) {
      peer.messageCount++;
      peer.seen();
    }
    // In a real implementation, this would send over the wire
    return message;
  }
  
  _heartbeat() {
    // Check peer timeouts
    for (const peer of this._peers.values()) {
      peer.checkTimeouts();
      
      if (!peer.isAlive()) {
        peer.state = PEER_STATES.DISCONNECTED;
      }
    }
  }
  
  getState() {
    return {
      id: this.id,
      name: this.name,
      running: this._running,
      peerCount: this._peers.size,
      connectedPeerCount: this.getConnectedPeers().length,
      channelCount: this._channels.size,
      handlerCount: this._handlers.size,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — MESH NETWORK
// ═══════════════════════════════════════════════════════════════════════════════

class MeshNetwork {
  constructor(config = {}) {
    this._nodes = new Map();
    this._topology = new Map(); // Node connections
  }
  
  /**
   * Add a node to the mesh
   */
  addNode(nodeId, config = {}) {
    const node = new NetworkNode(nodeId, config);
    this._nodes.set(nodeId, node);
    this._topology.set(nodeId, new Set());
    return node;
  }
  
  /**
   * Connect two nodes
   */
  connect(nodeIdA, nodeIdB) {
    const nodeA = this._nodes.get(nodeIdA);
    const nodeB = this._nodes.get(nodeIdB);
    
    if (!nodeA || !nodeB) {
      throw new Error('Both nodes must exist in the mesh');
    }
    
    // Add as peers
    nodeA.addPeer(nodeIdB, { name: nodeB.name });
    nodeB.addPeer(nodeIdA, { name: nodeA.name });
    
    // Update topology
    this._topology.get(nodeIdA).add(nodeIdB);
    this._topology.get(nodeIdB).add(nodeIdA);
    
    // Mark as connected
    nodeA.getPeer(nodeIdB).state = PEER_STATES.CONNECTED;
    nodeB.getPeer(nodeIdA).state = PEER_STATES.CONNECTED;
    
    return this;
  }
  
  /**
   * Route a message through the mesh
   */
  route(message) {
    if (message.hops >= message.maxHops) {
      return null; // Max hops reached
    }
    
    const targetNode = this._nodes.get(message.to);
    if (targetNode) {
      // Direct delivery
      targetNode.receive(message);
      return message;
    }
    
    // Need to find a route
    const sourceNode = this._nodes.get(message.from);
    if (!sourceNode) return null;
    
    // Simple BFS routing
    const route = this._findRoute(message.from, message.to);
    if (route && route.length > 0) {
      message.hop();
      const nextHop = route[0];
      const nextNode = this._nodes.get(nextHop);
      if (nextNode) {
        nextNode.receive(message);
        return message;
      }
    }
    
    return null;
  }
  
  _findRoute(from, to, visited = new Set()) {
    if (from === to) return [];
    if (visited.has(from)) return null;
    
    visited.add(from);
    const neighbors = this._topology.get(from) || new Set();
    
    for (const neighbor of neighbors) {
      if (neighbor === to) return [neighbor];
      
      const route = this._findRoute(neighbor, to, visited);
      if (route) return [neighbor, ...route];
    }
    
    return null;
  }
  
  /**
   * Start all nodes
   */
  startAll() {
    for (const node of this._nodes.values()) {
      node.start();
    }
    return this;
  }
  
  /**
   * Stop all nodes
   */
  stopAll() {
    for (const node of this._nodes.values()) {
      node.stop();
    }
    return this;
  }
  
  getTopology() {
    const result = {};
    for (const [nodeId, connections] of this._topology) {
      result[nodeId] = Array.from(connections);
    }
    return result;
  }
  
  getStats() {
    return {
      nodeCount: this._nodes.size,
      connectionCount: Array.from(this._topology.values())
        .reduce((sum, set) => sum + set.size, 0) / 2,
      topology: this.getTopology(),
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
  MESSAGE_TYPES,
  CHANNEL_TYPES,
  PEER_STATES,
  
  // Classes
  Message,
  Peer,
  Channel,
  NetworkNode,
  MeshNetwork,
};

export default {
  MESSAGE_TYPES,
  CHANNEL_TYPES,
  PEER_STATES,
  Message,
  Peer,
  Channel,
  NetworkNode,
  MeshNetwork,
};
