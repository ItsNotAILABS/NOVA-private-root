/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-events — EVENT SYSTEM SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides a comprehensive event system:
 *   - Event emission and subscription
 *   - Event sourcing
 *   - Event replay
 *   - Event filtering
 *   - Dead letter queue
 *   - Event persistence
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

import { PHI, PHI_INV, HEARTBEAT_MS, createEntityId } from '../../medina-core/src/index.js';

const EVENT_PRIORITY = {
  CRITICAL: 1.0,
  HIGH: PHI_INV,           // ~0.618
  NORMAL: PHI_INV * PHI_INV, // ~0.382
  LOW: 0.2,
  BACKGROUND: 0.1,
};

const EVENT_STATUS = {
  PENDING: 'PENDING',
  DELIVERED: 'DELIVERED',
  FAILED: 'FAILED',
  DEAD_LETTER: 'DEAD_LETTER',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — EVENT
// ═══════════════════════════════════════════════════════════════════════════════

class Event {
  constructor(type, data, config = {}) {
    this.id = config.id || createEntityId('evt');
    this.type = type;
    this.data = data;
    this.source = config.source || 'unknown';
    this.priority = config.priority || EVENT_PRIORITY.NORMAL;
    this.correlationId = config.correlationId || null;
    this.causationId = config.causationId || null;
    
    this.timestamp = Date.now();
    this.version = config.version || 1;
    this.metadata = config.metadata || {};
    
    this.status = EVENT_STATUS.PENDING;
    this.deliveryAttempts = 0;
    this.deliveredAt = null;
    this.error = null;
  }
  
  /**
   * Mark event as delivered
   */
  delivered() {
    this.status = EVENT_STATUS.DELIVERED;
    this.deliveredAt = Date.now();
    return this;
  }
  
  /**
   * Mark event as failed
   */
  failed(error) {
    this.deliveryAttempts++;
    this.error = error;
    if (this.deliveryAttempts >= 3) {
      this.status = EVENT_STATUS.DEAD_LETTER;
    } else {
      this.status = EVENT_STATUS.FAILED;
    }
    return this;
  }
  
  /**
   * Create a derived event
   */
  derive(type, data, config = {}) {
    return new Event(type, data, {
      ...config,
      correlationId: this.correlationId || this.id,
      causationId: this.id,
      source: config.source || this.source,
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      data: this.data,
      source: this.source,
      priority: this.priority,
      correlationId: this.correlationId,
      causationId: this.causationId,
      timestamp: this.timestamp,
      version: this.version,
      metadata: this.metadata,
      status: this.status,
      deliveryAttempts: this.deliveryAttempts,
      deliveredAt: this.deliveredAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — EVENT HANDLER
// ═══════════════════════════════════════════════════════════════════════════════

class EventHandler {
  constructor(id, handler, config = {}) {
    this.id = id;
    this.handler = handler;
    this.filter = config.filter || null;
    this.priority = config.priority || EVENT_PRIORITY.NORMAL;
    this.maxConcurrency = config.maxConcurrency || 1;
    this.timeout = config.timeout || 30000;
    
    this.handledCount = 0;
    this.failedCount = 0;
    this.lastHandled = null;
    this._activeCalls = 0;
  }
  
  /**
   * Check if handler should process event
   */
  shouldHandle(event) {
    if (!this.filter) return true;
    
    if (typeof this.filter === 'function') {
      return this.filter(event);
    }
    
    if (typeof this.filter === 'string') {
      return event.type === this.filter || event.type.startsWith(this.filter + '.');
    }
    
    if (Array.isArray(this.filter)) {
      return this.filter.some(f => 
        event.type === f || event.type.startsWith(f + '.')
      );
    }
    
    return true;
  }
  
  /**
   * Handle an event
   */
  async handle(event) {
    if (this._activeCalls >= this.maxConcurrency) {
      throw new Error('Handler at max concurrency');
    }
    
    this._activeCalls++;
    
    try {
      const result = await Promise.race([
        this.handler(event),
        new Promise((_, reject) => 
          setTimeout(() => reject(new Error('Handler timeout')), this.timeout)
        ),
      ]);
      
      this.handledCount++;
      this.lastHandled = Date.now();
      
      return result;
    } catch (error) {
      this.failedCount++;
      throw error;
    } finally {
      this._activeCalls--;
    }
  }
  
  toJSON() {
    return {
      id: this.id,
      priority: this.priority,
      maxConcurrency: this.maxConcurrency,
      handledCount: this.handledCount,
      failedCount: this.failedCount,
      lastHandled: this.lastHandled,
      activeCalls: this._activeCalls,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — EVENT BUS
// ═══════════════════════════════════════════════════════════════════════════════

class EventBus {
  constructor(config = {}) {
    this._handlers = new Map();
    this._eventLog = [];
    this._deadLetterQueue = [];
    this._eventLogLimit = config.eventLogLimit || 10000;
    this._deadLetterLimit = config.deadLetterLimit || 1000;
    
    this._pendingEvents = [];
    this._processing = false;
  }
  
  /**
   * Subscribe to events
   */
  on(eventType, handler, config = {}) {
    const id = config.id || createEntityId('handler');
    const filter = Object.hasOwn(config, 'filter')
      ? config.filter
      : eventType;
    const eventHandler = new EventHandler(id, handler, {
      ...config,
      filter,
    });
    
    this._handlers.set(id, eventHandler);
    
    return () => this.off(id);
  }
  
  /**
   * Subscribe to all events
   */
  onAll(handler, config = {}) {
    return this.on('*', handler, { ...config, filter: null });
  }
  
  /**
   * Unsubscribe
   */
  off(handlerId) {
    this._handlers.delete(handlerId);
    return this;
  }
  
  /**
   * Subscribe once
   */
  once(eventType, handler, config = {}) {
    const unsubscribe = this.on(eventType, async (event) => {
      unsubscribe();
      return await handler(event);
    }, config);
    return unsubscribe;
  }
  
  /**
   * Emit an event
   */
  emit(type, data, config = {}) {
    const event = new Event(type, data, config);
    this._queueEvent(event);
    return event;
  }
  
  /**
   * Emit and wait for all handlers
   */
  async emitAsync(type, data, config = {}) {
    const event = new Event(type, data, config);
    await this._processEvent(event);
    return event;
  }
  
  /**
   * Queue an event for processing
   */
  _queueEvent(event) {
    this._pendingEvents.push(event);
    
    // Sort by priority
    this._pendingEvents.sort((a, b) => b.priority - a.priority);
    
    // Start processing if not already
    if (!this._processing) {
      this._processQueue();
    }
    
    return event;
  }
  
  /**
   * Process the event queue
   */
  async _processQueue() {
    if (this._processing) return;
    this._processing = true;
    
    while (this._pendingEvents.length > 0) {
      const event = this._pendingEvents.shift();
      await this._processEvent(event);
    }
    
    this._processing = false;
  }
  
  /**
   * Process a single event
   */
  async _processEvent(event) {
    const handlers = this._getHandlersForEvent(event);
    
    // Log the event
    this._eventLog.push(event);
    while (this._eventLog.length > this._eventLogLimit) {
      this._eventLog.shift();
    }
    
    if (handlers.length === 0) {
      event.delivered();
      return event;
    }
    
    // Process handlers by priority
    handlers.sort((a, b) => b.priority - a.priority);
    
    for (const handler of handlers) {
      try {
        await handler.handle(event);
      } catch (error) {
        event.failed(error.message);
        console.error(`Event handler ${handler.id} failed:`, error);
      }
    }
    
    if (event.status === EVENT_STATUS.DEAD_LETTER) {
      this._deadLetterQueue.push(event);
      while (this._deadLetterQueue.length > this._deadLetterLimit) {
        this._deadLetterQueue.shift();
      }
    } else if (event.status !== EVENT_STATUS.FAILED) {
      event.delivered();
    }
    
    return event;
  }
  
  /**
   * Get handlers that should process an event
   */
  _getHandlersForEvent(event) {
    const handlers = [];
    
    for (const handler of this._handlers.values()) {
      if (handler.shouldHandle(event)) {
        handlers.push(handler);
      }
    }
    
    return handlers;
  }
  
  /**
   * Get event log
   */
  getEventLog(options = {}) {
    let events = [...this._eventLog];
    
    if (options.type) {
      events = events.filter(e => e.type === options.type || e.type.startsWith(options.type + '.'));
    }
    
    if (options.since) {
      events = events.filter(e => e.timestamp >= options.since);
    }
    
    if (options.status) {
      events = events.filter(e => e.status === options.status);
    }
    
    if (options.limit) {
      events = events.slice(-options.limit);
    }
    
    return events;
  }
  
  /**
   * Get dead letter queue
   */
  getDeadLetterQueue() {
    return [...this._deadLetterQueue];
  }
  
  /**
   * Retry dead letter events
   */
  async retryDeadLetters() {
    const events = this._deadLetterQueue.splice(0);
    
    for (const event of events) {
      event.status = EVENT_STATUS.PENDING;
      event.deliveryAttempts = 0;
      await this._processEvent(event);
    }
    
    return events.length;
  }
  
  /**
   * Replay events
   */
  async replay(options = {}) {
    const events = this.getEventLog(options);
    
    for (const event of events) {
      const replay = new Event(event.type, event.data, {
        ...event.metadata,
        correlationId: event.id,
        metadata: { ...event.metadata, isReplay: true, originalId: event.id },
      });
      await this._processEvent(replay);
    }
    
    return events.length;
  }
  
  getStats() {
    return {
      handlerCount: this._handlers.size,
      eventLogSize: this._eventLog.length,
      deadLetterCount: this._deadLetterQueue.length,
      pendingEvents: this._pendingEvents.length,
      isProcessing: this._processing,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EVENT STORE (EVENT SOURCING)
// ═══════════════════════════════════════════════════════════════════════════════

class EventStore {
  constructor(config = {}) {
    this._streams = new Map();
    this._globalIndex = [];
    this._snapshots = new Map();
  }
  
  /**
   * Append event to a stream
   */
  append(streamId, type, data, config = {}) {
    if (!this._streams.has(streamId)) {
      this._streams.set(streamId, []);
    }
    
    const stream = this._streams.get(streamId);
    const version = stream.length + 1;
    
    const event = new Event(type, data, {
      ...config,
      version,
      metadata: {
        ...config.metadata,
        streamId,
        streamVersion: version,
      },
    });
    
    stream.push(event);
    this._globalIndex.push({ streamId, eventId: event.id, timestamp: event.timestamp });
    
    return event;
  }
  
  /**
   * Read events from a stream
   */
  read(streamId, options = {}) {
    const stream = this._streams.get(streamId) || [];
    
    let events = [...stream];
    
    if (options.fromVersion) {
      events = events.filter(e => e.version >= options.fromVersion);
    }
    
    if (options.toVersion) {
      events = events.filter(e => e.version <= options.toVersion);
    }
    
    if (options.limit) {
      events = events.slice(0, options.limit);
    }
    
    return events;
  }
  
  /**
   * Get stream version
   */
  getStreamVersion(streamId) {
    const stream = this._streams.get(streamId);
    return stream ? stream.length : 0;
  }
  
  /**
   * Save a snapshot
   */
  saveSnapshot(streamId, state, version) {
    this._snapshots.set(streamId, {
      state,
      version,
      timestamp: Date.now(),
    });
    return this;
  }
  
  /**
   * Get latest snapshot
   */
  getSnapshot(streamId) {
    return this._snapshots.get(streamId) || null;
  }
  
  /**
   * Reconstruct state from events
   */
  fold(streamId, reducer, initialState) {
    const snapshot = this.getSnapshot(streamId);
    const startVersion = snapshot ? snapshot.version + 1 : 1;
    const startState = snapshot ? snapshot.state : initialState;
    
    const events = this.read(streamId, { fromVersion: startVersion });
    
    return events.reduce((state, event) => reducer(state, event), startState);
  }
  
  /**
   * Get all stream IDs
   */
  getStreamIds() {
    return Array.from(this._streams.keys());
  }
  
  /**
   * Get global event index
   */
  getGlobalIndex(options = {}) {
    let index = [...this._globalIndex];
    
    if (options.since) {
      index = index.filter(i => i.timestamp >= options.since);
    }
    
    if (options.limit) {
      index = index.slice(-options.limit);
    }
    
    return index;
  }
  
  getStats() {
    return {
      streamCount: this._streams.size,
      totalEvents: this._globalIndex.length,
      snapshotCount: this._snapshots.size,
    };
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
  EVENT_PRIORITY,
  EVENT_STATUS,
  
  // Classes
  Event,
  EventHandler,
  EventBus,
  EventStore,
};

export default {
  EVENT_PRIORITY,
  EVENT_STATUS,
  Event,
  EventHandler,
  EventBus,
  EventStore,
};
