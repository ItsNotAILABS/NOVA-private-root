/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-streaming — REAL-TIME DATA STREAMS SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides real-time streaming capabilities:
 *   - Data streams
 *   - Backpressure handling
 *   - Stream transformations
 *   - Stream merging and splitting
 *   - Windowing and batching
 *   - Reactive patterns
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const STREAM_STATES = {
  IDLE: 'IDLE',
  FLOWING: 'FLOWING',
  PAUSED: 'PAUSED',
  ENDED: 'ENDED',
  ERROR: 'ERROR',
};

const BACKPRESSURE_STRATEGIES = {
  BUFFER: 'BUFFER',     // Buffer items
  DROP: 'DROP',         // Drop newest items
  DROP_OLDEST: 'DROP_OLDEST', // Drop oldest items
  ERROR: 'ERROR',       // Error on overflow
  BLOCK: 'BLOCK',       // Block producer
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — STREAM ITEM
// ═══════════════════════════════════════════════════════════════════════════════

class StreamItem {
  constructor(value, config = {}) {
    this.id = config.id || `item_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.value = value;
    this.timestamp = Date.now();
    this.metadata = config.metadata || {};
    this.sequence = config.sequence || 0;
  }
  
  /**
   * Transform the value
   */
  map(fn) {
    return new StreamItem(fn(this.value), {
      id: this.id,
      metadata: this.metadata,
      sequence: this.sequence,
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      value: this.value,
      timestamp: this.timestamp,
      sequence: this.sequence,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — STREAM
// ═══════════════════════════════════════════════════════════════════════════════

class Stream {
  constructor(config = {}) {
    this.id = config.id || `stream_${Date.now()}`;
    this.name = config.name || this.id;
    
    this._buffer = [];
    this._bufferLimit = config.bufferLimit || 1000;
    this._backpressureStrategy = config.backpressureStrategy || BACKPRESSURE_STRATEGIES.BUFFER;
    
    this._subscribers = [];
    this._transformers = [];
    this._state = STREAM_STATES.IDLE;
    this._sequence = 0;
    
    this._itemCount = 0;
    this._droppedCount = 0;
    this._errorCount = 0;
    
    this._endPromise = null;
    this._endResolve = null;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.1 — PRODUCER METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Push a value to the stream
   */
  push(value, metadata = {}) {
    if (this._state === STREAM_STATES.ENDED) {
      throw new Error('Cannot push to ended stream');
    }
    
    const item = new StreamItem(value, {
      metadata,
      sequence: ++this._sequence,
    });
    
    // Apply transformers
    let transformedItem = item;
    for (const transformer of this._transformers) {
      transformedItem = transformer(transformedItem);
      if (!transformedItem) return null; // Filter out
    }
    
    // Handle backpressure
    if (this._buffer.length >= this._bufferLimit) {
      switch (this._backpressureStrategy) {
        case BACKPRESSURE_STRATEGIES.DROP:
          this._droppedCount++;
          return null;
        case BACKPRESSURE_STRATEGIES.DROP_OLDEST:
          this._buffer.shift();
          this._droppedCount++;
          break;
        case BACKPRESSURE_STRATEGIES.ERROR:
          this._state = STREAM_STATES.ERROR;
          throw new Error('Stream buffer overflow');
        case BACKPRESSURE_STRATEGIES.BLOCK:
          // In a real implementation, this would block
          return null;
        case BACKPRESSURE_STRATEGIES.BUFFER:
        default:
          // Continue buffering
          break;
      }
    }
    
    this._buffer.push(transformedItem);
    this._itemCount++;
    
    // Deliver to subscribers if flowing
    if (this._state === STREAM_STATES.FLOWING) {
      this._deliver();
    }
    
    return transformedItem;
  }
  
  /**
   * Push multiple values
   */
  pushMany(values, metadata = {}) {
    return values.map(v => this.push(v, metadata));
  }
  
  /**
   * End the stream
   */
  end() {
    this._state = STREAM_STATES.ENDED;
    
    // Deliver remaining items
    this._deliver();
    
    // Notify subscribers
    for (const sub of this._subscribers) {
      if (sub.onEnd) {
        try {
          sub.onEnd();
        } catch (e) {
          console.error('Stream end handler error:', e);
        }
      }
    }
    
    if (this._endResolve) {
      this._endResolve();
    }
    
    return this;
  }
  
  /**
   * Error the stream
   */
  error(err) {
    this._state = STREAM_STATES.ERROR;
    this._errorCount++;
    
    for (const sub of this._subscribers) {
      if (sub.onError) {
        try {
          sub.onError(err);
        } catch (e) {
          console.error('Stream error handler error:', e);
        }
      }
    }
    
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.2 — CONSUMER METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Subscribe to the stream
   */
  subscribe(onData, onEnd = null, onError = null) {
    const subscription = {
      id: `sub_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      onData,
      onEnd,
      onError,
      active: true,
    };
    
    this._subscribers.push(subscription);
    
    // Start flowing if first subscriber
    if (this._state === STREAM_STATES.IDLE) {
      this._state = STREAM_STATES.FLOWING;
      this._deliver();
    }
    
    // Return unsubscribe function
    return () => {
      subscription.active = false;
      this._subscribers = this._subscribers.filter(s => s.id !== subscription.id);
    };
  }
  
  /**
   * Pause the stream
   */
  pause() {
    if (this._state === STREAM_STATES.FLOWING) {
      this._state = STREAM_STATES.PAUSED;
    }
    return this;
  }
  
  /**
   * Resume the stream
   */
  resume() {
    if (this._state === STREAM_STATES.PAUSED) {
      this._state = STREAM_STATES.FLOWING;
      this._deliver();
    }
    return this;
  }
  
  /**
   * Wait for stream to end
   */
  async toEnd() {
    if (this._state === STREAM_STATES.ENDED) {
      return;
    }
    
    if (!this._endPromise) {
      this._endPromise = new Promise(resolve => {
        this._endResolve = resolve;
      });
    }
    
    return this._endPromise;
  }
  
  /**
   * Collect all items into array
   */
  async toArray() {
    const items = [];
    
    this.subscribe(item => items.push(item.value));
    await this.toEnd();
    
    return items;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.3 — TRANSFORMATION METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Map values
   */
  map(fn) {
    const mapped = new Stream({ name: `${this.name}.map` });
    
    this.subscribe(
      item => mapped.push(fn(item.value), item.metadata),
      () => mapped.end(),
      err => mapped.error(err)
    );
    
    return mapped;
  }
  
  /**
   * Filter values
   */
  filter(predicate) {
    const filtered = new Stream({ name: `${this.name}.filter` });
    
    this.subscribe(
      item => {
        if (predicate(item.value)) {
          filtered.push(item.value, item.metadata);
        }
      },
      () => filtered.end(),
      err => filtered.error(err)
    );
    
    return filtered;
  }
  
  /**
   * Reduce/fold values
   */
  reduce(reducer, initialValue) {
    let accumulator = initialValue;
    const result = new Stream({ name: `${this.name}.reduce` });
    
    this.subscribe(
      item => {
        accumulator = reducer(accumulator, item.value);
        result.push(accumulator);
      },
      () => result.end(),
      err => result.error(err)
    );
    
    return result;
  }
  
  /**
   * Take first n items
   */
  take(n) {
    let count = 0;
    const taken = new Stream({ name: `${this.name}.take(${n})` });
    
    const unsubscribe = this.subscribe(
      item => {
        if (count < n) {
          taken.push(item.value, item.metadata);
          count++;
          if (count >= n) {
            unsubscribe();
            taken.end();
          }
        }
      },
      () => taken.end(),
      err => taken.error(err)
    );
    
    return taken;
  }
  
  /**
   * Skip first n items
   */
  skip(n) {
    let count = 0;
    const skipped = new Stream({ name: `${this.name}.skip(${n})` });
    
    this.subscribe(
      item => {
        if (count >= n) {
          skipped.push(item.value, item.metadata);
        }
        count++;
      },
      () => skipped.end(),
      err => skipped.error(err)
    );
    
    return skipped;
  }
  
  /**
   * Buffer items
   */
  buffer(size) {
    const buffer = [];
    const buffered = new Stream({ name: `${this.name}.buffer(${size})` });
    
    this.subscribe(
      item => {
        buffer.push(item.value);
        if (buffer.length >= size) {
          buffered.push([...buffer]);
          buffer.length = 0;
        }
      },
      () => {
        if (buffer.length > 0) {
          buffered.push([...buffer]);
        }
        buffered.end();
      },
      err => buffered.error(err)
    );
    
    return buffered;
  }
  
  /**
   * Window by time
   */
  window(ms) {
    const windowed = new Stream({ name: `${this.name}.window(${ms})` });
    let buffer = [];
    
    const flush = () => {
      if (buffer.length > 0) {
        windowed.push([...buffer]);
        buffer = [];
      }
    };
    
    const interval = setInterval(flush, ms);
    
    this.subscribe(
      item => {
        buffer.push(item.value);
      },
      () => {
        clearInterval(interval);
        flush();
        windowed.end();
      },
      err => {
        clearInterval(interval);
        windowed.error(err);
      }
    );
    
    return windowed;
  }
  
  /**
   * Debounce emissions
   */
  debounce(ms) {
    const debounced = new Stream({ name: `${this.name}.debounce(${ms})` });
    let timeout = null;
    let lastItem = null;
    
    this.subscribe(
      item => {
        lastItem = item;
        if (timeout) clearTimeout(timeout);
        timeout = setTimeout(() => {
          if (lastItem) {
            debounced.push(lastItem.value, lastItem.metadata);
          }
        }, ms);
      },
      () => {
        if (timeout) clearTimeout(timeout);
        if (lastItem) {
          debounced.push(lastItem.value, lastItem.metadata);
        }
        debounced.end();
      },
      err => {
        if (timeout) clearTimeout(timeout);
        debounced.error(err);
      }
    );
    
    return debounced;
  }
  
  /**
   * Throttle emissions
   */
  throttle(ms) {
    const throttled = new Stream({ name: `${this.name}.throttle(${ms})` });
    let lastEmit = 0;
    
    this.subscribe(
      item => {
        const now = Date.now();
        if (now - lastEmit >= ms) {
          throttled.push(item.value, item.metadata);
          lastEmit = now;
        }
      },
      () => throttled.end(),
      err => throttled.error(err)
    );
    
    return throttled;
  }
  
  /**
   * Distinct values
   */
  distinct(keyFn = v => v) {
    const seen = new Set();
    const distinct = new Stream({ name: `${this.name}.distinct` });
    
    this.subscribe(
      item => {
        const key = keyFn(item.value);
        if (!seen.has(key)) {
          seen.add(key);
          distinct.push(item.value, item.metadata);
        }
      },
      () => distinct.end(),
      err => distinct.error(err)
    );
    
    return distinct;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.4 — INTERNAL METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  _deliver() {
    while (this._buffer.length > 0 && this._state === STREAM_STATES.FLOWING) {
      const item = this._buffer.shift();
      
      for (const sub of this._subscribers) {
        if (sub.active && sub.onData) {
          try {
            sub.onData(item);
          } catch (e) {
            console.error('Stream subscriber error:', e);
          }
        }
      }
    }
  }
  
  getState() {
    return {
      id: this.id,
      name: this.name,
      state: this._state,
      bufferSize: this._buffer.length,
      bufferLimit: this._bufferLimit,
      subscriberCount: this._subscribers.length,
      itemCount: this._itemCount,
      droppedCount: this._droppedCount,
      errorCount: this._errorCount,
      sequence: this._sequence,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — STREAM UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Merge multiple streams
 */
function merge(...streams) {
  const merged = new Stream({ name: 'merged' });
  let endedCount = 0;
  
  for (const stream of streams) {
    stream.subscribe(
      item => merged.push(item.value, item.metadata),
      () => {
        endedCount++;
        if (endedCount >= streams.length) {
          merged.end();
        }
      },
      err => merged.error(err)
    );
  }
  
  return merged;
}

/**
 * Combine latest values from multiple streams
 */
function combineLatest(...streams) {
  const combined = new Stream({ name: 'combineLatest' });
  const latest = new Array(streams.length).fill(undefined);
  const hasValue = new Array(streams.length).fill(false);
  let endedCount = 0;
  
  for (let i = 0; i < streams.length; i++) {
    streams[i].subscribe(
      item => {
        latest[i] = item.value;
        hasValue[i] = true;
        
        if (hasValue.every(h => h)) {
          combined.push([...latest]);
        }
      },
      () => {
        endedCount++;
        if (endedCount >= streams.length) {
          combined.end();
        }
      },
      err => combined.error(err)
    );
  }
  
  return combined;
}

/**
 * Zip streams together
 */
function zip(...streams) {
  const zipped = new Stream({ name: 'zip' });
  const buffers = streams.map(() => []);
  let endedCount = 0;
  
  const tryEmit = () => {
    while (buffers.every(b => b.length > 0)) {
      const values = buffers.map(b => b.shift());
      zipped.push(values);
    }
  };
  
  for (let i = 0; i < streams.length; i++) {
    streams[i].subscribe(
      item => {
        buffers[i].push(item.value);
        tryEmit();
      },
      () => {
        endedCount++;
        if (endedCount >= streams.length) {
          zipped.end();
        }
      },
      err => zipped.error(err)
    );
  }
  
  return zipped;
}

/**
 * Create a stream from an array
 */
function fromArray(array) {
  const stream = new Stream({ name: 'fromArray' });
  
  setTimeout(() => {
    for (const item of array) {
      stream.push(item);
    }
    stream.end();
  }, 0);
  
  return stream;
}

/**
 * Create a stream from an interval
 */
function interval(ms) {
  const stream = new Stream({ name: `interval(${ms})` });
  let count = 0;
  
  const id = setInterval(() => {
    stream.push(count++);
  }, ms);
  
  // Allow stopping the interval
  const originalEnd = stream.end.bind(stream);
  stream.end = () => {
    clearInterval(id);
    return originalEnd();
  };
  
  return stream;
}

/**
 * Create a stream from a promise
 */
function fromPromise(promise) {
  const stream = new Stream({ name: 'fromPromise' });
  
  promise
    .then(value => {
      stream.push(value);
      stream.end();
    })
    .catch(err => stream.error(err));
  
  return stream;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  STREAM_STATES,
  BACKPRESSURE_STRATEGIES,
  
  // Classes
  StreamItem,
  Stream,
  
  // Utilities
  merge,
  combineLatest,
  zip,
  fromArray,
  interval,
  fromPromise,
};

export default {
  STREAM_STATES,
  BACKPRESSURE_STRATEGIES,
  StreamItem,
  Stream,
  merge,
  combineLatest,
  zip,
  fromArray,
  interval,
  fromPromise,
};
