/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-HEARTBEAT — TIMING SYNCHRONIZATION PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * The HEARTBEAT protocol provides timing synchronization across the organism.
 * The 873ms period is derived from φ⁴ × Schumann resonance period.
 * 
 * Mathematical Foundation:
 *   - φ = 1.6180339887498948482 (Golden Ratio)
 *   - φ⁴ ≈ 6.854
 *   - Schumann fundamental frequency ≈ 7.83 Hz
 *   - Schumann period = 1000/7.83 ≈ 127.7ms
 *   - HEARTBEAT = φ⁴ × 127.7ms ≈ 873ms
 * 
 * This is NOVA's SOVEREIGN creation — NOT an ICP feature.
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_SQUARED = PHI * PHI;
const PHI_CUBED = PHI_SQUARED * PHI;
const PHI_FOURTH = PHI_CUBED * PHI;
const PHI_INV = 0.6180339887498948482;

const SCHUMANN_FREQUENCY = 7.83; // Hz
const SCHUMANN_PERIOD_MS = 1000 / SCHUMANN_FREQUENCY; // ≈127.7ms

const HEARTBEAT_MS = Math.round(PHI_FOURTH * SCHUMANN_PERIOD_MS); // ≈873ms

const BEAT_TYPES = {
  SYSTOLE: 'SYSTOLE',     // Contraction (primary beat)
  DIASTOLE: 'DIASTOLE',   // Relaxation (secondary beat)
  SYNC: 'SYNC',           // Synchronization pulse
};

const RHYTHM_STATES = {
  NORMAL: 'NORMAL',
  TACHYCARDIA: 'TACHYCARDIA',   // Too fast
  BRADYCARDIA: 'BRADYCARDIA',   // Too slow
  ARRHYTHMIA: 'ARRHYTHMIA',     // Irregular
  ASYSTOLE: 'ASYSTOLE',         // Stopped
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — BEAT
// ═══════════════════════════════════════════════════════════════════════════════

class Beat {
  constructor(sequence, type = BEAT_TYPES.SYSTOLE) {
    this.id = `beat_${sequence}_${Date.now()}`;
    this.sequence = sequence;
    this.type = type;
    this.timestamp = Date.now();
    this.scheduledTime = null;
    this.actualTime = null;
    this.drift = 0;
  }
  
  /**
   * Record actual execution time
   */
  execute() {
    this.actualTime = Date.now();
    if (this.scheduledTime) {
      this.drift = this.actualTime - this.scheduledTime;
    }
    return this;
  }
  
  toJSON() {
    return {
      id: this.id,
      sequence: this.sequence,
      type: this.type,
      timestamp: this.timestamp,
      scheduledTime: this.scheduledTime,
      actualTime: this.actualTime,
      drift: this.drift,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — HEARTBEAT PROTOCOL
// ═══════════════════════════════════════════════════════════════════════════════

class HeartbeatProtocol {
  constructor(config = {}) {
    this.period = config.period || HEARTBEAT_MS;
    this.tolerance = config.tolerance || 50; // ms tolerance for drift
    
    this._sequence = 0;
    this._state = RHYTHM_STATES.ASYSTOLE;
    this._interval = null;
    
    this._subscribers = new Map();
    this._beats = [];
    this._maxBeats = config.maxBeats || 1000;
    
    this._stats = {
      totalBeats: 0,
      missedBeats: 0,
      driftSum: 0,
      maxDrift: 0,
      startTime: null,
    };
    
    this._lastBeatTime = null;
    this._nextBeatTime = null;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.1 — LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Start the heartbeat
   */
  start() {
    if (this._state !== RHYTHM_STATES.ASYSTOLE) return this;
    
    this._stats.startTime = Date.now();
    this._state = RHYTHM_STATES.NORMAL;
    
    // Schedule first beat
    this._scheduleBeat();
    
    return this;
  }
  
  /**
   * Stop the heartbeat
   */
  stop() {
    if (this._interval) {
      clearTimeout(this._interval);
      this._interval = null;
    }
    
    this._state = RHYTHM_STATES.ASYSTOLE;
    return this;
  }
  
  /**
   * Schedule the next beat
   */
  _scheduleBeat() {
    const now = Date.now();
    
    // Calculate exact time for next beat
    if (this._lastBeatTime) {
      this._nextBeatTime = this._lastBeatTime + this.period;
      // If we're late, schedule for next period
      while (this._nextBeatTime <= now) {
        this._nextBeatTime += this.period;
        this._stats.missedBeats++;
      }
    } else {
      this._nextBeatTime = now;
    }
    
    const delay = Math.max(0, this._nextBeatTime - now);
    
    this._interval = setTimeout(() => {
      this._beat();
      this._scheduleBeat();
    }, delay);
  }
  
  /**
   * Execute a heartbeat
   */
  _beat() {
    const beat = new Beat(++this._sequence, BEAT_TYPES.SYSTOLE);
    beat.scheduledTime = this._nextBeatTime;
    beat.execute();
    
    this._lastBeatTime = beat.actualTime;
    
    // Track stats
    this._stats.totalBeats++;
    this._stats.driftSum += Math.abs(beat.drift);
    this._stats.maxDrift = Math.max(this._stats.maxDrift, Math.abs(beat.drift));
    
    // Check rhythm state
    this._checkRhythm(beat);
    
    // Store beat
    this._beats.push(beat);
    while (this._beats.length > this._maxBeats) {
      this._beats.shift();
    }
    
    // Notify subscribers
    this._notify(beat);
    
    return beat;
  }
  
  /**
   * Check and update rhythm state
   */
  _checkRhythm(beat) {
    if (Math.abs(beat.drift) > this.tolerance) {
      // Significant drift detected
      const recentBeats = this._beats.slice(-10);
      const avgDrift = recentBeats.reduce((sum, b) => sum + Math.abs(b.drift), 0) / recentBeats.length;
      
      if (avgDrift > this.tolerance * 2) {
        this._state = RHYTHM_STATES.ARRHYTHMIA;
      } else if (beat.drift > 0) {
        this._state = RHYTHM_STATES.BRADYCARDIA; // Running slow
      } else {
        this._state = RHYTHM_STATES.TACHYCARDIA; // Running fast
      }
    } else if (this._state !== RHYTHM_STATES.NORMAL) {
      // Check if we've recovered
      const recentBeats = this._beats.slice(-5);
      const allNormal = recentBeats.every(b => Math.abs(b.drift) <= this.tolerance);
      if (allNormal) {
        this._state = RHYTHM_STATES.NORMAL;
      }
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.2 — SUBSCRIPTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Subscribe to heartbeats
   */
  subscribe(callback, config = {}) {
    const id = config.id || `sub_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    const interval = config.interval || 1; // Every nth beat
    
    this._subscribers.set(id, {
      callback,
      interval,
      lastCalled: 0,
    });
    
    return () => this.unsubscribe(id);
  }
  
  /**
   * Unsubscribe from heartbeats
   */
  unsubscribe(id) {
    this._subscribers.delete(id);
    return this;
  }
  
  /**
   * Notify all subscribers
   */
  _notify(beat) {
    for (const [id, sub] of this._subscribers) {
      if (beat.sequence % sub.interval === 0) {
        try {
          sub.callback(beat, this);
          sub.lastCalled = beat.sequence;
        } catch (e) {
          console.error(`Heartbeat subscriber error (${id}):`, e);
        }
      }
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.3 — SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Get next beat time
   */
  getNextBeatTime() {
    return this._nextBeatTime;
  }
  
  /**
   * Get time until next beat
   */
  getTimeUntilNextBeat() {
    if (!this._nextBeatTime) return null;
    return Math.max(0, this._nextBeatTime - Date.now());
  }
  
  /**
   * Synchronize with another heartbeat
   */
  syncWith(otherTimestamp) {
    const now = Date.now();
    const offset = otherTimestamp - now;
    
    // Adjust our next beat time
    if (this._nextBeatTime) {
      const adjustment = offset % this.period;
      this._nextBeatTime += adjustment;
    }
    
    return this;
  }
  
  /**
   * Get current phase (0-1)
   */
  getPhase() {
    if (!this._lastBeatTime) return 0;
    const elapsed = Date.now() - this._lastBeatTime;
    return (elapsed % this.period) / this.period;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.4 — DERIVED TIMINGS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Get φ-scaled intervals
   */
  getPhiIntervals() {
    return {
      heartbeat: this.period,                           // 873ms
      fast: Math.round(this.period * PHI_INV),         // ~539ms
      faster: Math.round(this.period * PHI_INV * PHI_INV), // ~333ms
      slow: Math.round(this.period * PHI),             // ~1412ms
      slower: Math.round(this.period * PHI_SQUARED),   // ~2285ms
      minute: Math.round(this.period * 69),            // ~60 seconds (69 heartbeats)
      hour: Math.round(this.period * 69 * 60),         // ~1 hour
    };
  }
  
  /**
   * Schedule a task for a specific beat
   */
  scheduleAtBeat(targetSequence, callback) {
    const beatsDiff = targetSequence - this._sequence;
    if (beatsDiff <= 0) {
      callback();
      return;
    }
    
    const delay = beatsDiff * this.period - (Date.now() - this._lastBeatTime);
    setTimeout(callback, delay);
    
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §3.5 — STATE AND STATS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  getState() {
    return this._state;
  }
  
  getStats() {
    const uptime = this._stats.startTime 
      ? Date.now() - this._stats.startTime 
      : 0;
    
    return {
      state: this._state,
      sequence: this._sequence,
      period: this.period,
      uptime,
      subscriberCount: this._subscribers.size,
      ...this._stats,
      avgDrift: this._stats.totalBeats > 0 
        ? this._stats.driftSum / this._stats.totalBeats 
        : 0,
      beatsPerMinute: this._stats.totalBeats > 0 && uptime > 0
        ? Math.round(this._stats.totalBeats / (uptime / 60000))
        : 0,
    };
  }
  
  getRecentBeats(count = 10) {
    return this._beats.slice(-count).map(b => b.toJSON());
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — SYNCHRONIZATION UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Create a synchronized clock
 */
function createSynchronizedClock(masterHeartbeat) {
  return {
    now: () => {
      const phase = masterHeartbeat.getPhase();
      const lastBeat = masterHeartbeat._lastBeatTime;
      return lastBeat + (phase * masterHeartbeat.period);
    },
    
    schedule: (callback, beatsFromNow) => {
      const targetSequence = masterHeartbeat._sequence + beatsFromNow;
      masterHeartbeat.scheduleAtBeat(targetSequence, callback);
    },
    
    interval: (callback, everyNBeats) => {
      return masterHeartbeat.subscribe(callback, { interval: everyNBeats });
    },
  };
}

/**
 * Phase lock multiple heartbeats
 */
function phaseLock(heartbeats) {
  if (heartbeats.length === 0) return;
  
  const master = heartbeats[0];
  const masterTime = master._lastBeatTime;
  
  for (let i = 1; i < heartbeats.length; i++) {
    heartbeats[i].syncWith(masterTime);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_SQUARED,
  PHI_CUBED,
  PHI_FOURTH,
  PHI_INV,
  SCHUMANN_FREQUENCY,
  SCHUMANN_PERIOD_MS,
  HEARTBEAT_MS,
  BEAT_TYPES,
  RHYTHM_STATES,
  
  // Classes
  Beat,
  HeartbeatProtocol,
  
  // Utilities
  createSynchronizedClock,
  phaseLock,
};

export default HeartbeatProtocol;
