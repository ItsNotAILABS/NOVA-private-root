/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-analytics — METRICS AND MONITORING SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides analytics and monitoring:
 *   - Metrics collection
 *   - Performance monitoring
 *   - Health checks
 *   - Alerting
 *   - Dashboarding data
 *   - Time series data
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const METRIC_TYPES = {
  COUNTER: 'COUNTER',     // Monotonically increasing
  GAUGE: 'GAUGE',         // Point-in-time value
  HISTOGRAM: 'HISTOGRAM', // Distribution of values
  TIMER: 'TIMER',         // Duration measurements
};

const ALERT_LEVELS = {
  INFO: 'INFO',
  WARNING: 'WARNING',
  ERROR: 'ERROR',
  CRITICAL: 'CRITICAL',
};

const HEALTH_STATUS = {
  HEALTHY: 'HEALTHY',
  DEGRADED: 'DEGRADED',
  UNHEALTHY: 'UNHEALTHY',
  UNKNOWN: 'UNKNOWN',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — METRIC
// ═══════════════════════════════════════════════════════════════════════════════

class Metric {
  constructor(name, type, config = {}) {
    this.name = name;
    this.type = type;
    this.description = config.description || '';
    this.labels = config.labels || {};
    this.unit = config.unit || '';
    
    this.value = 0;
    this.values = []; // For histogram
    this.count = 0;
    this.sum = 0;
    this.min = Infinity;
    this.max = -Infinity;
    
    this.createdAt = Date.now();
    this.updatedAt = Date.now();
  }
  
  /**
   * Increment counter
   */
  inc(amount = 1) {
    if (this.type !== METRIC_TYPES.COUNTER && this.type !== METRIC_TYPES.GAUGE) {
      throw new Error(`Cannot increment ${this.type} metric`);
    }
    this.value += amount;
    this.updatedAt = Date.now();
    return this;
  }
  
  /**
   * Decrement gauge
   */
  dec(amount = 1) {
    if (this.type !== METRIC_TYPES.GAUGE) {
      throw new Error(`Cannot decrement ${this.type} metric`);
    }
    this.value -= amount;
    this.updatedAt = Date.now();
    return this;
  }
  
  /**
   * Set gauge value
   */
  set(value) {
    if (this.type !== METRIC_TYPES.GAUGE) {
      throw new Error(`Cannot set ${this.type} metric`);
    }
    this.value = value;
    this.updatedAt = Date.now();
    return this;
  }
  
  /**
   * Observe a value (for histogram/timer)
   */
  observe(value) {
    if (this.type !== METRIC_TYPES.HISTOGRAM && this.type !== METRIC_TYPES.TIMER) {
      throw new Error(`Cannot observe ${this.type} metric`);
    }
    
    this.values.push(value);
    this.count++;
    this.sum += value;
    this.min = Math.min(this.min, value);
    this.max = Math.max(this.max, value);
    this.updatedAt = Date.now();
    
    // Keep last 1000 values
    while (this.values.length > 1000) {
      this.values.shift();
    }
    
    return this;
  }
  
  /**
   * Get current value
   */
  getValue() {
    switch (this.type) {
      case METRIC_TYPES.COUNTER:
      case METRIC_TYPES.GAUGE:
        return this.value;
      case METRIC_TYPES.HISTOGRAM:
      case METRIC_TYPES.TIMER:
        return {
          count: this.count,
          sum: this.sum,
          avg: this.count > 0 ? this.sum / this.count : 0,
          min: this.min === Infinity ? 0 : this.min,
          max: this.max === -Infinity ? 0 : this.max,
          p50: this._percentile(50),
          p90: this._percentile(90),
          p95: this._percentile(95),
          p99: this._percentile(99),
        };
      default:
        return this.value;
    }
  }
  
  _percentile(p) {
    if (this.values.length === 0) return 0;
    const sorted = [...this.values].sort((a, b) => a - b);
    const index = Math.ceil((p / 100) * sorted.length) - 1;
    return sorted[Math.max(0, index)];
  }
  
  /**
   * Reset the metric
   */
  reset() {
    if (this.type === METRIC_TYPES.COUNTER) {
      throw new Error('Cannot reset counter');
    }
    
    this.value = 0;
    this.values = [];
    this.count = 0;
    this.sum = 0;
    this.min = Infinity;
    this.max = -Infinity;
    this.updatedAt = Date.now();
    
    return this;
  }
  
  toJSON() {
    return {
      name: this.name,
      type: this.type,
      description: this.description,
      labels: this.labels,
      unit: this.unit,
      value: this.getValue(),
      updatedAt: this.updatedAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — TIME SERIES
// ═══════════════════════════════════════════════════════════════════════════════

class TimeSeries {
  constructor(name, config = {}) {
    this.name = name;
    this.points = [];
    this.maxPoints = config.maxPoints || 1000;
    this.resolution = config.resolution || HEARTBEAT_MS;
    this.aggregation = config.aggregation || 'avg'; // avg, sum, min, max, last
  }
  
  /**
   * Add a data point
   */
  add(value, timestamp = Date.now()) {
    this.points.push({ timestamp, value });
    
    // Keep max points
    while (this.points.length > this.maxPoints) {
      this.points.shift();
    }
    
    return this;
  }
  
  /**
   * Get points in a time range
   */
  getRange(start, end = Date.now()) {
    return this.points.filter(p => p.timestamp >= start && p.timestamp <= end);
  }
  
  /**
   * Get aggregated data for a time range
   */
  aggregate(start, end, bucketSize = this.resolution) {
    const points = this.getRange(start, end);
    const buckets = new Map();
    
    for (const point of points) {
      const bucket = Math.floor(point.timestamp / bucketSize) * bucketSize;
      if (!buckets.has(bucket)) {
        buckets.set(bucket, []);
      }
      buckets.get(bucket).push(point.value);
    }
    
    const result = [];
    for (const [timestamp, values] of buckets) {
      let value;
      switch (this.aggregation) {
        case 'sum':
          value = values.reduce((a, b) => a + b, 0);
          break;
        case 'min':
          value = Math.min(...values);
          break;
        case 'max':
          value = Math.max(...values);
          break;
        case 'last':
          value = values[values.length - 1];
          break;
        case 'avg':
        default:
          value = values.reduce((a, b) => a + b, 0) / values.length;
      }
      result.push({ timestamp, value });
    }
    
    return result.sort((a, b) => a.timestamp - b.timestamp);
  }
  
  /**
   * Get latest value
   */
  latest() {
    if (this.points.length === 0) return null;
    return this.points[this.points.length - 1];
  }
  
  /**
   * Calculate rate of change
   */
  rate(window = 60000) {
    const now = Date.now();
    const points = this.getRange(now - window, now);
    
    if (points.length < 2) return 0;
    
    const first = points[0];
    const last = points[points.length - 1];
    const timeDiff = (last.timestamp - first.timestamp) / 1000; // seconds
    
    if (timeDiff === 0) return 0;
    return (last.value - first.value) / timeDiff;
  }
  
  toJSON() {
    return {
      name: this.name,
      pointCount: this.points.length,
      resolution: this.resolution,
      aggregation: this.aggregation,
      latest: this.latest(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — HEALTH CHECK
// ═══════════════════════════════════════════════════════════════════════════════

class HealthCheck {
  constructor(name, checkFn, config = {}) {
    this.name = name;
    this.checkFn = checkFn;
    this.interval = config.interval || HEARTBEAT_MS * 10;
    this.timeout = config.timeout || 5000;
    this.critical = config.critical || false;
    
    this.status = HEALTH_STATUS.UNKNOWN;
    this.lastCheck = null;
    this.lastError = null;
    this.consecutiveFailures = 0;
    
    this._intervalId = null;
  }
  
  /**
   * Run the health check
   */
  async check() {
    const startTime = Date.now();
    
    try {
      const result = await Promise.race([
        this.checkFn(),
        new Promise((_, reject) => 
          setTimeout(() => reject(new Error('Health check timeout')), this.timeout)
        ),
      ]);
      
      this.status = HEALTH_STATUS.HEALTHY;
      this.lastError = null;
      this.consecutiveFailures = 0;
      
      return {
        name: this.name,
        status: this.status,
        duration: Date.now() - startTime,
        result,
      };
    } catch (error) {
      this.consecutiveFailures++;
      this.lastError = error.message;
      
      if (this.consecutiveFailures >= 3) {
        this.status = HEALTH_STATUS.UNHEALTHY;
      } else {
        this.status = HEALTH_STATUS.DEGRADED;
      }
      
      return {
        name: this.name,
        status: this.status,
        duration: Date.now() - startTime,
        error: error.message,
      };
    } finally {
      this.lastCheck = Date.now();
    }
  }
  
  /**
   * Start periodic checks
   */
  start() {
    if (this._intervalId) return this;
    
    this._intervalId = setInterval(() => this.check(), this.interval);
    this.check(); // Run immediately
    
    return this;
  }
  
  /**
   * Stop periodic checks
   */
  stop() {
    if (this._intervalId) {
      clearInterval(this._intervalId);
      this._intervalId = null;
    }
    return this;
  }
  
  toJSON() {
    return {
      name: this.name,
      status: this.status,
      critical: this.critical,
      lastCheck: this.lastCheck,
      lastError: this.lastError,
      consecutiveFailures: this.consecutiveFailures,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — ALERT
// ═══════════════════════════════════════════════════════════════════════════════

class Alert {
  constructor(name, condition, config = {}) {
    this.name = name;
    this.condition = condition;
    this.level = config.level || ALERT_LEVELS.WARNING;
    this.message = config.message || `Alert: ${name}`;
    this.cooldown = config.cooldown || 60000;
    
    this.isActive = false;
    this.activatedAt = null;
    this.lastTriggered = null;
    this.triggerCount = 0;
    
    this._handlers = [];
  }
  
  /**
   * Evaluate the alert condition
   */
  evaluate(value) {
    const shouldFire = this.condition(value);
    
    if (shouldFire && !this.isActive) {
      // Check cooldown
      if (this.lastTriggered && Date.now() - this.lastTriggered < this.cooldown) {
        return false;
      }
      
      this.isActive = true;
      this.activatedAt = Date.now();
      this.lastTriggered = Date.now();
      this.triggerCount++;
      
      this._fire(value);
      return true;
    } else if (!shouldFire && this.isActive) {
      this.isActive = false;
      this._resolve(value);
    }
    
    return false;
  }
  
  /**
   * Add an alert handler
   */
  onAlert(handler) {
    this._handlers.push(handler);
    return this;
  }
  
  _fire(value) {
    const event = {
      type: 'fired',
      name: this.name,
      level: this.level,
      message: this.message,
      value,
      timestamp: Date.now(),
    };
    
    for (const handler of this._handlers) {
      try {
        handler(event);
      } catch (e) {
        console.error('Alert handler error:', e);
      }
    }
  }
  
  _resolve(value) {
    const event = {
      type: 'resolved',
      name: this.name,
      level: this.level,
      message: `${this.message} - Resolved`,
      value,
      duration: Date.now() - this.activatedAt,
      timestamp: Date.now(),
    };
    
    for (const handler of this._handlers) {
      try {
        handler(event);
      } catch (e) {
        console.error('Alert handler error:', e);
      }
    }
  }
  
  toJSON() {
    return {
      name: this.name,
      level: this.level,
      isActive: this.isActive,
      activatedAt: this.activatedAt,
      lastTriggered: this.lastTriggered,
      triggerCount: this.triggerCount,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — ANALYTICS MANAGER
// ═══════════════════════════════════════════════════════════════════════════════

class AnalyticsManager {
  constructor(config = {}) {
    this._metrics = new Map();
    this._timeSeries = new Map();
    this._healthChecks = new Map();
    this._alerts = new Map();
    
    this._heartbeatInterval = null;
    this._running = false;
    
    // Built-in metrics
    this._setupBuiltInMetrics();
  }
  
  _setupBuiltInMetrics() {
    this.counter('analytics.heartbeat_count', { description: 'Number of heartbeats' });
    this.gauge('analytics.metric_count', { description: 'Total number of metrics' });
    this.gauge('analytics.health_check_count', { description: 'Total number of health checks' });
    this.gauge('analytics.alert_count', { description: 'Total number of alerts' });
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §6.1 — METRICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create a counter metric
   */
  counter(name, config = {}) {
    const metric = new Metric(name, METRIC_TYPES.COUNTER, config);
    this._metrics.set(name, metric);
    return metric;
  }
  
  /**
   * Create a gauge metric
   */
  gauge(name, config = {}) {
    const metric = new Metric(name, METRIC_TYPES.GAUGE, config);
    this._metrics.set(name, metric);
    return metric;
  }
  
  /**
   * Create a histogram metric
   */
  histogram(name, config = {}) {
    const metric = new Metric(name, METRIC_TYPES.HISTOGRAM, config);
    this._metrics.set(name, metric);
    return metric;
  }
  
  /**
   * Create a timer metric
   */
  timer(name, config = {}) {
    const metric = new Metric(name, METRIC_TYPES.TIMER, { ...config, unit: 'ms' });
    this._metrics.set(name, metric);
    return metric;
  }
  
  /**
   * Get a metric
   */
  getMetric(name) {
    return this._metrics.get(name);
  }
  
  /**
   * Time a function
   */
  async time(name, fn) {
    const timer = this.getMetric(name) || this.timer(name);
    const start = Date.now();
    try {
      return await fn();
    } finally {
      timer.observe(Date.now() - start);
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §6.2 — TIME SERIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create or get a time series
   */
  series(name, config = {}) {
    if (!this._timeSeries.has(name)) {
      this._timeSeries.set(name, new TimeSeries(name, config));
    }
    return this._timeSeries.get(name);
  }
  
  /**
   * Record a time series point
   */
  record(name, value, timestamp = Date.now()) {
    return this.series(name).add(value, timestamp);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §6.3 — HEALTH CHECKS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Register a health check
   */
  healthCheck(name, checkFn, config = {}) {
    const check = new HealthCheck(name, checkFn, config);
    this._healthChecks.set(name, check);
    return check;
  }
  
  /**
   * Run all health checks
   */
  async runHealthChecks() {
    const results = [];
    
    for (const check of this._healthChecks.values()) {
      const result = await check.check();
      results.push(result);
    }
    
    return results;
  }
  
  /**
   * Get overall health status
   */
  async getHealthStatus() {
    const results = await this.runHealthChecks();
    
    const criticalUnhealthy = results.some(r => 
      this._healthChecks.get(r.name)?.critical && r.status === HEALTH_STATUS.UNHEALTHY
    );
    
    if (criticalUnhealthy) {
      return { status: HEALTH_STATUS.UNHEALTHY, checks: results };
    }
    
    const anyUnhealthy = results.some(r => r.status === HEALTH_STATUS.UNHEALTHY);
    if (anyUnhealthy) {
      return { status: HEALTH_STATUS.DEGRADED, checks: results };
    }
    
    const anyDegraded = results.some(r => r.status === HEALTH_STATUS.DEGRADED);
    if (anyDegraded) {
      return { status: HEALTH_STATUS.DEGRADED, checks: results };
    }
    
    return { status: HEALTH_STATUS.HEALTHY, checks: results };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §6.4 — ALERTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create an alert
   */
  alert(name, condition, config = {}) {
    const alert = new Alert(name, condition, config);
    this._alerts.set(name, alert);
    return alert;
  }
  
  /**
   * Check all alerts with current metric values
   */
  checkAlerts() {
    const fired = [];
    
    for (const [name, alert] of this._alerts) {
      // Get associated metric if any
      const metric = this._metrics.get(name);
      if (metric) {
        const value = metric.getValue();
        if (alert.evaluate(value)) {
          fired.push(alert);
        }
      }
    }
    
    return fired;
  }
  
  /**
   * Get active alerts
   */
  getActiveAlerts() {
    return Array.from(this._alerts.values()).filter(a => a.isActive);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §6.5 — LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Start analytics collection
   */
  start() {
    if (this._running) return this;
    
    this._running = true;
    
    // Start heartbeat
    this._heartbeatInterval = setInterval(() => {
      this._tick();
    }, HEARTBEAT_MS);
    
    // Start health checks
    for (const check of this._healthChecks.values()) {
      check.start();
    }
    
    return this;
  }
  
  /**
   * Stop analytics collection
   */
  stop() {
    this._running = false;
    
    if (this._heartbeatInterval) {
      clearInterval(this._heartbeatInterval);
      this._heartbeatInterval = null;
    }
    
    for (const check of this._healthChecks.values()) {
      check.stop();
    }
    
    return this;
  }
  
  _tick() {
    this.getMetric('analytics.heartbeat_count')?.inc();
    this.getMetric('analytics.metric_count')?.set(this._metrics.size);
    this.getMetric('analytics.health_check_count')?.set(this._healthChecks.size);
    this.getMetric('analytics.alert_count')?.set(this._alerts.size);
    
    this.checkAlerts();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §6.6 — REPORTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Get all metrics as JSON
   */
  getMetrics() {
    const result = {};
    for (const [name, metric] of this._metrics) {
      result[name] = metric.toJSON();
    }
    return result;
  }
  
  /**
   * Get complete stats
   */
  getStats() {
    return {
      running: this._running,
      metricCount: this._metrics.size,
      timeSeriesCount: this._timeSeries.size,
      healthCheckCount: this._healthChecks.size,
      alertCount: this._alerts.size,
      activeAlerts: this.getActiveAlerts().length,
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
  METRIC_TYPES,
  ALERT_LEVELS,
  HEALTH_STATUS,
  
  // Classes
  Metric,
  TimeSeries,
  HealthCheck,
  Alert,
  AnalyticsManager,
};

export default {
  METRIC_TYPES,
  ALERT_LEVELS,
  HEALTH_STATUS,
  Metric,
  TimeSeries,
  HealthCheck,
  Alert,
  AnalyticsManager,
};
