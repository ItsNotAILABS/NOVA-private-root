/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-VEIN — BLOOD-FLOW ROUTING PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * The VEIN protocol is the circulatory system of NOVA. It routes messages, data, and computation
 * throughout the organism like blood through veins.
 * 
 * Biological Inspiration:
 *   - Messages are like red blood cells carrying oxygen
 *   - Routes are like blood vessels
 *   - The heart (873ms heartbeat) pumps the flow
 *   - Congestion is handled like blood pressure regulation
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const ROUTE_TYPES = {
  ARTERY: 'ARTERY',         // High-priority, direct routes
  VEIN: 'VEIN',             // Standard routes
  CAPILLARY: 'CAPILLARY',   // Fine-grained, local routes
  LYMPH: 'LYMPH',           // Cleanup and maintenance routes
};

const FLOW_STATES = {
  FLOWING: 'FLOWING',
  CONGESTED: 'CONGESTED',
  BLOCKED: 'BLOCKED',
  CLOTTED: 'CLOTTED',
};

const MESSAGE_PRIORITY = {
  CRITICAL: 1.0,
  HIGH: PHI_INV,
  NORMAL: PHI_INV * PHI_INV,
  LOW: 0.2,
  BACKGROUND: 0.1,
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — VESSEL (Route)
// ═══════════════════════════════════════════════════════════════════════════════

class Vessel {
  constructor(from, to, config = {}) {
    this.id = config.id || `vessel_${from}_${to}_${Date.now()}`;
    this.from = from;
    this.to = to;
    this.type = config.type || ROUTE_TYPES.VEIN;
    this.capacity = config.capacity || 100;
    this.latency = config.latency || 0;
    
    this.state = FLOW_STATES.FLOWING;
    this.currentLoad = 0;
    this.totalTransferred = 0;
    this.lastFlowTime = null;
    
    this._queue = [];
  }
  
  /**
   * Check if vessel can accept more flow
   */
  canFlow() {
    return this.state === FLOW_STATES.FLOWING && this.currentLoad < this.capacity;
  }
  
  /**
   * Queue a message for transmission
   */
  enqueue(message) {
    if (!this.canFlow()) {
      return false;
    }
    
    this._queue.push(message);
    this.currentLoad++;
    
    // Check for congestion
    if (this.currentLoad >= this.capacity * 0.8) {
      this.state = FLOW_STATES.CONGESTED;
    }
    
    return true;
  }
  
  /**
   * Dequeue a message for delivery
   */
  dequeue() {
    if (this._queue.length === 0) return null;
    
    const message = this._queue.shift();
    this.currentLoad--;
    this.totalTransferred++;
    this.lastFlowTime = Date.now();
    
    // Check if no longer congested
    if (this.state === FLOW_STATES.CONGESTED && this.currentLoad < this.capacity * 0.5) {
      this.state = FLOW_STATES.FLOWING;
    }
    
    return message;
  }
  
  /**
   * Clear a blockage
   */
  unblock() {
    if (this.state === FLOW_STATES.BLOCKED || this.state === FLOW_STATES.CLOTTED) {
      this.state = FLOW_STATES.FLOWING;
    }
    return this;
  }
  
  /**
   * Block the vessel
   */
  block() {
    this.state = FLOW_STATES.BLOCKED;
    return this;
  }
  
  toJSON() {
    return {
      id: this.id,
      from: this.from,
      to: this.to,
      type: this.type,
      state: this.state,
      capacity: this.capacity,
      currentLoad: this.currentLoad,
      queueLength: this._queue.length,
      totalTransferred: this.totalTransferred,
      lastFlowTime: this.lastFlowTime,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — BLOOD CELL (Message)
// ═══════════════════════════════════════════════════════════════════════════════

class BloodCell {
  constructor(payload, config = {}) {
    this.id = config.id || `cell_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.payload = payload;
    this.from = config.from;
    this.to = config.to;
    this.priority = config.priority || MESSAGE_PRIORITY.NORMAL;
    this.ttl = config.ttl || 30000;
    
    this.createdAt = Date.now();
    this.hops = 0;
    this.maxHops = config.maxHops || 10;
    this.route = [config.from];
    this.deliveredAt = null;
  }
  
  /**
   * Record a hop
   */
  hop(nodeId) {
    this.hops++;
    this.route.push(nodeId);
    return this.hops <= this.maxHops;
  }
  
  /**
   * Check if expired
   */
  isExpired() {
    return Date.now() - this.createdAt > this.ttl;
  }
  
  /**
   * Mark as delivered
   */
  deliver() {
    this.deliveredAt = Date.now();
    return this;
  }
  
  toJSON() {
    return {
      id: this.id,
      from: this.from,
      to: this.to,
      priority: this.priority,
      createdAt: this.createdAt,
      hops: this.hops,
      route: this.route,
      deliveredAt: this.deliveredAt,
      isExpired: this.isExpired(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — VEIN PROTOCOL
// ═══════════════════════════════════════════════════════════════════════════════

class VeinProtocol {
  constructor(nodeId, config = {}) {
    this.nodeId = nodeId;
    this._vessels = new Map();
    this._nodes = new Map();
    this._routingTable = new Map();
    this._pendingDeliveries = [];
    this._deadLetters = [];
    
    this._heartbeatInterval = null;
    this._running = false;
    
    this._stats = {
      messagesRouted: 0,
      messagesDelivered: 0,
      messagesDropped: 0,
      messagesFailed: 0,
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.1 — VESSEL MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create a vessel between two nodes
   */
  createVessel(from, to, config = {}) {
    const vessel = new Vessel(from, to, config);
    const key = `${from}->${to}`;
    this._vessels.set(key, vessel);
    
    // Update routing table
    this._updateRoutingTable();
    
    return vessel;
  }
  
  /**
   * Get a vessel
   */
  getVessel(from, to) {
    return this._vessels.get(`${from}->${to}`);
  }
  
  /**
   * Remove a vessel
   */
  removeVessel(from, to) {
    const key = `${from}->${to}`;
    const vessel = this._vessels.get(key);
    if (vessel) {
      this._vessels.delete(key);
      this._updateRoutingTable();
    }
    return vessel;
  }
  
  /**
   * Register a node
   */
  registerNode(nodeId, handler) {
    this._nodes.set(nodeId, handler);
    return this;
  }
  
  /**
   * Unregister a node
   */
  unregisterNode(nodeId) {
    this._nodes.delete(nodeId);
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.2 — ROUTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Route a message
   */
  route(config) {
    const cell = new BloodCell(config.payload, {
      from: config.from || this.nodeId,
      to: config.to,
      priority: config.priority,
      ttl: config.ttl,
    });
    
    this._stats.messagesRouted++;
    
    return this._routeCell(cell);
  }
  
  /**
   * Internal routing logic
   */
  _routeCell(cell) {
    // Check if we're the destination
    if (cell.to === this.nodeId) {
      return this._deliverLocally(cell);
    }
    
    // Check if expired
    if (cell.isExpired()) {
      this._stats.messagesDropped++;
      this._deadLetters.push(cell);
      return { success: false, reason: 'expired' };
    }
    
    // Check hop count
    if (!cell.hop(this.nodeId)) {
      this._stats.messagesDropped++;
      this._deadLetters.push(cell);
      return { success: false, reason: 'max_hops' };
    }
    
    // Find route to destination
    const nextHop = this._findNextHop(cell.to);
    if (!nextHop) {
      this._stats.messagesFailed++;
      this._deadLetters.push(cell);
      return { success: false, reason: 'no_route' };
    }
    
    // Get vessel to next hop
    const vessel = this.getVessel(this.nodeId, nextHop);
    if (!vessel || !vessel.canFlow()) {
      this._stats.messagesFailed++;
      this._deadLetters.push(cell);
      return { success: false, reason: 'vessel_blocked' };
    }
    
    // Queue for transmission
    vessel.enqueue(cell);
    this._pendingDeliveries.push({ cell, nextHop });
    
    return { success: true, nextHop };
  }
  
  /**
   * Deliver a message locally
   */
  _deliverLocally(cell) {
    const handler = this._nodes.get(this.nodeId);
    if (!handler) {
      this._stats.messagesFailed++;
      return { success: false, reason: 'no_handler' };
    }
    
    try {
      handler(cell.payload, cell);
      cell.deliver();
      this._stats.messagesDelivered++;
      return { success: true, delivered: true };
    } catch (error) {
      this._stats.messagesFailed++;
      return { success: false, reason: 'handler_error', error: error.message };
    }
  }
  
  /**
   * Find next hop for destination
   */
  _findNextHop(destination) {
    // Direct route
    if (this._vessels.has(`${this.nodeId}->${destination}`)) {
      return destination;
    }
    
    // Check routing table
    const route = this._routingTable.get(destination);
    if (route) {
      return route.nextHop;
    }
    
    return null;
  }
  
  /**
   * Update routing table (simplified Dijkstra)
   */
  _updateRoutingTable() {
    this._routingTable.clear();
    
    // Build adjacency list
    const graph = new Map();
    for (const vessel of this._vessels.values()) {
      if (!graph.has(vessel.from)) {
        graph.set(vessel.from, []);
      }
      graph.get(vessel.from).push({
        to: vessel.to,
        cost: vessel.state === FLOW_STATES.FLOWING ? 1 : 10,
      });
    }
    
    // Dijkstra from this node
    const distances = new Map();
    const previous = new Map();
    const unvisited = new Set(graph.keys());
    
    distances.set(this.nodeId, 0);
    
    while (unvisited.size > 0) {
      // Find minimum distance unvisited node
      let current = null;
      let minDist = Infinity;
      for (const node of unvisited) {
        const dist = distances.get(node) ?? Infinity;
        if (dist < minDist) {
          minDist = dist;
          current = node;
        }
      }
      
      if (current === null) break;
      unvisited.delete(current);
      
      const neighbors = graph.get(current) || [];
      for (const { to, cost } of neighbors) {
        const alt = (distances.get(current) ?? Infinity) + cost;
        if (alt < (distances.get(to) ?? Infinity)) {
          distances.set(to, alt);
          previous.set(to, current);
        }
      }
    }
    
    // Build routing table
    for (const [dest, dist] of distances) {
      if (dest !== this.nodeId) {
        // Trace back to find first hop
        let node = dest;
        while (previous.get(node) !== this.nodeId && previous.has(node)) {
          node = previous.get(node);
        }
        
        this._routingTable.set(dest, {
          destination: dest,
          nextHop: node,
          distance: dist,
        });
      }
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.3 — LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Start the protocol
   */
  start() {
    if (this._running) return this;
    
    this._running = true;
    
    // Process pending deliveries on heartbeat
    this._heartbeatInterval = setInterval(() => {
      this._pump();
    }, HEARTBEAT_MS);
    
    return this;
  }
  
  /**
   * Stop the protocol
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
   * Pump (heartbeat tick)
   */
  _pump() {
    // Process vessels
    for (const vessel of this._vessels.values()) {
      const cell = vessel.dequeue();
      if (cell) {
        // Forward to next node (in a real implementation)
        // Here we simulate delivery if we're the destination
        if (cell.to === this.nodeId) {
          this._deliverLocally(cell);
        }
      }
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.4 — STATS AND STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  getStats() {
    return {
      nodeId: this.nodeId,
      running: this._running,
      vesselCount: this._vessels.size,
      nodeCount: this._nodes.size,
      routeCount: this._routingTable.size,
      pendingDeliveries: this._pendingDeliveries.length,
      deadLetters: this._deadLetters.length,
      ...this._stats,
    };
  }
  
  getVessels() {
    return Array.from(this._vessels.values()).map(v => v.toJSON());
  }
  
  getRoutingTable() {
    return Array.from(this._routingTable.entries()).map(([dest, route]) => ({
      destination: dest,
      ...route,
    }));
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
  ROUTE_TYPES,
  FLOW_STATES,
  MESSAGE_PRIORITY,
  
  // Classes
  Vessel,
  BloodCell,
  VeinProtocol,
};

export default VeinProtocol;
