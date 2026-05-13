/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @nova/travex-agi — TRAVEL DEMAND & BOOKING INTELLIGENCE AGI
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * TRAVEX-AGI is the sovereign Travel Demand & Booking Intelligence engine.
 * It processes real-time booking signals across all hotel and travel platforms,
 * applies φ-weighted demand analysis, releases seats on a Fibonacci schedule,
 * and closes the loop via an outcome feedback engine.
 *
 * Four sovereign engines:
 *   LAST_MINUTE_SCANNER    — Sub-second scan of unsold inventory across platforms
 *   DEMAND_ANALYSIS        — Multi-signal (search velocity, weather, events, Kuramoto) demand scoring
 *   FIBONACCI_RELEASE      — φ-ordered seat/room release schedule (F₁, F₂, F₃, … Fₙ windows)
 *   OUTCOME_FEEDBACK       — Closed-loop learning: actual fill rates → update demand weights
 *
 * Heartbeat: 873ms (φ⁴ × Schumann — NOVA sovereign, not ICP)
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI            = 1.6180339887498948482;   /* φ — golden ratio              */
const PHI_INV        = 0.6180339887498948482;   /* φ⁻¹ — coherence weight        */
const PHI_SQ         = 2.6180339887498948482;   /* φ² — amplification            */
const AMOR           = 0.3819660112501051518;   /* φ⁻² — love constant           */
const HEARTBEAT_MS   = 873;                     /* sovereign 873ms heartbeat     */
const AGI_ID         = 'TRAVEX-AGI-001';
const AGI_VERSION    = '1.0.0';
const AGI_FAMILY     = 'ITER_AETERNA';          /* Latin: eternal journey        */

/* Fibonacci sequence used for seat-release windows (in minutes from departure) */
const FIBONACCI = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];

/* Demand signals the AGI synthesises */
const DEMAND_SIGNALS = {
  SEARCH_VELOCITY:  'SEARCH_VELOCITY',   /* booking-site search spike rate    */
  PRICE_SENSITIVITY:'PRICE_SENSITIVITY', /* elasticity measured from clicks   */
  WEATHER_INDEX:    'WEATHER_INDEX',     /* weather disruption probability    */
  EVENT_PROXIMITY:  'EVENT_PROXIMITY',   /* nearby events driving demand      */
  SOCIAL_PULSE:     'SOCIAL_PULSE',      /* social-media travel intent        */
  KURAMOTO_SYNC:    'KURAMOTO_SYNC',     /* phase-lock across booking engines */
  CANCELLATION_WAVE:'CANCELLATION_WAVE', /* recent cancellation rate          */
  COMPETITOR_FILL:  'COMPETITOR_FILL',   /* competitor inventory fill rate    */
};

/* Booking outcome states */
const OUTCOME = {
  FILLED:     'FILLED',
  LAST_MINUTE:'LAST_MINUTE',
  UNSOLD:     'UNSOLD',
  CANCELLED:  'CANCELLED',
};

/* Platform identifiers tracked by the scanner */
const PLATFORMS = [
  'BOOKING_COM', 'EXPEDIA', 'HOTELS_COM', 'AIRBNB', 'VRBO',
  'KAYAK', 'PRICELINE', 'AGODA', 'TRIP_COM', 'HOTELSDK_DIRECT',
];

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — STATE
// ═══════════════════════════════════════════════════════════════════════════════

/* AGI lifecycle */
let _beat       = 0;
let _alive      = false;
let _hbi        = null;
let _phase      = 0.0;   /* Kuramoto phase for the AGI's own oscillator */

/* Last-minute inventory scan results — keyed by inventoryId */
const _inventory = new Map();  /* inventoryId → InventoryEntry */

/* Demand model weights — updated by feedback loop */
const _demandWeights = {
  SEARCH_VELOCITY:   PHI_INV,
  PRICE_SENSITIVITY: AMOR,
  WEATHER_INDEX:     PHI_INV * AMOR,
  EVENT_PROXIMITY:   PHI_INV,
  SOCIAL_PULSE:      AMOR,
  KURAMOTO_SYNC:     PHI,      /* highest weight — synchrony is key    */
  CANCELLATION_WAVE: PHI_INV,
  COMPETITOR_FILL:   AMOR,
};

/* Fibonacci release schedule state */
let _fibIndex   = 0;      /* current position in FIBONACCI array             */
let _releaseLog = [];     /* rolling log of the last 64 release events        */

/* Outcome feedback log (last 256 resolved inventory items) */
let _feedbackLog = [];

/* Scanner stats */
let _totalScanned  = 0;
let _lastMinuteHits = 0;

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — UTILITY
// ═══════════════════════════════════════════════════════════════════════════════

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

/**
 * φ-weighted average of an array of [0,1] values.
 * Earlier elements receive weight φ⁻¹, later elements weight φ⁻².
 * Approximates an exponential decay toward AMOR (φ⁻²).
 */
function phiWeightedAvg(values) {
  if (!values.length) return 0;
  let sum = 0, wSum = 0;
  for (let i = 0; i < values.length; i++) {
    const w = Math.pow(PHI_INV, i);
    sum  += values[i] * w;
    wSum += w;
  }
  return sum / wSum;
}

/**
 * Fibonacci release window in milliseconds before departure.
 * Returns minutes corresponding to FIBONACCI[index].
 */
function fibWindowMinutes(index) {
  return FIBONACCI[Math.min(index, FIBONACCI.length - 1)];
}

/**
 * Poisson probability mass: P(k events | lambda) — used for fill-rate estimation.
 */
function poissonPMF(lambda, k) {
  if (lambda <= 0) return k === 0 ? 1 : 0;
  let logP = -lambda + k * Math.log(lambda);
  for (let i = 2; i <= k; i++) logP -= Math.log(i);
  return Math.exp(logP);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — LAST-MINUTE BOOKING SCANNER
// The scanner maintains a live window of unsold inventory whose departure
// time falls within the current Fibonacci release window.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} InventoryEntry
 * @property {string}   id            — unique inventory identifier
 * @property {string}   platform      — source platform
 * @property {string}   type          — 'FLIGHT' | 'HOTEL' | 'PACKAGE'
 * @property {number}   departureMs   — Unix ms of departure / check-in
 * @property {number}   price         — current listed price (currency-agnostic)
 * @property {number}   capacity      — total seats / rooms
 * @property {number}   filled        — confirmed bookings so far
 * @property {number}   demandScore   — [0,1] synthesised demand signal
 * @property {string}   status        — 'OPEN' | 'LAST_MINUTE' | 'CLOSED'
 * @property {number}   scannedAt     — timestamp of last scan
 */

/**
 * Register or update an inventory item from an external platform feed.
 * @param {Partial<InventoryEntry>} item
 * @returns {InventoryEntry}
 */
function scanInventory(item) {
  const now = Date.now();
  const entry = {
    id:          item.id          || `inv_${now}_${Math.random().toString(36).slice(2, 8)}`,
    platform:    item.platform    || 'UNKNOWN',
    type:        item.type        || 'FLIGHT',
    departureMs: item.departureMs || (now + 48 * 3600_000),
    price:       item.price       || 0,
    capacity:    item.capacity    || 100,
    filled:      item.filled      || 0,
    demandScore: item.demandScore || 0.5,
    status:      'OPEN',
    scannedAt:   now,
    ..._inventory.get(item.id || ''),   /* preserve existing state if re-scanned */
    ...item,
  };

  /* Classify as LAST_MINUTE if within current Fibonacci window */
  const minutesToDep = (entry.departureMs - now) / 60_000;
  const windowMin    = fibWindowMinutes(_fibIndex);
  if (minutesToDep <= windowMin && minutesToDep > 0) {
    entry.status = 'LAST_MINUTE';
    _lastMinuteHits++;
  } else if (minutesToDep <= 0) {
    entry.status = 'CLOSED';
  }

  _inventory.set(entry.id, entry);
  _totalScanned++;
  return entry;
}

/**
 * Return all inventory items currently in LAST_MINUTE status,
 * sorted by demand score descending (highest opportunity first).
 * @returns {InventoryEntry[]}
 */
function getLastMinuteInventory() {
  const results = [];
  for (const e of _inventory.values()) {
    if (e.status === 'LAST_MINUTE') results.push(e);
  }
  results.sort((a, b) => b.demandScore - a.demandScore);
  return results;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — MULTI-SIGNAL DEMAND ANALYSIS
// Synthesises up to 8 real-time signals into a single [0,1] demand score.
// Weights are φ-scaled and updated by the outcome feedback loop (§7).
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} DemandSignalInput
 * @property {number} [searchVelocity]    — searches per minute normalised [0,1]
 * @property {number} [priceSensitivity]  — click-through elasticity [0,1]
 * @property {number} [weatherIndex]      — disruption probability [0,1]
 * @property {number} [eventProximity]    — proximity score to nearby events [0,1]
 * @property {number} [socialPulse]       — social intent signal [0,1]
 * @property {number} [kuramotoSync]      — inter-platform Kuramoto R order param [0,1]
 * @property {number} [cancellationWave]  — recent cancellation rate [0,1] (inverted)
 * @property {number} [competitorFill]    — competitor fill rate [0,1]
 */

/**
 * @typedef {Object} DemandAnalysisResult
 * @property {number}   score          — synthesised demand score [0,1]
 * @property {string}   tier           — 'SURGE' | 'HIGH' | 'NORMAL' | 'LOW' | 'DEAD'
 * @property {number}   fillEstimate   — Poisson-derived fill probability
 * @property {number}   yieldMultiplier— φ-scaled recommended price multiplier
 * @property {Object}   breakdown      — per-signal weighted contribution
 */

/**
 * Compute a multi-signal demand analysis for one inventory item.
 * @param {DemandSignalInput} signals
 * @returns {DemandAnalysisResult}
 */
function analyseDemand(signals) {
  const sv  = clamp01(signals.searchVelocity   ?? 0.5);
  const ps  = clamp01(signals.priceSensitivity ?? 0.5);
  const wi  = clamp01(signals.weatherIndex     ?? 0.1);
  const ep  = clamp01(signals.eventProximity   ?? 0.2);
  const sp  = clamp01(signals.socialPulse      ?? 0.3);
  const ks  = clamp01(signals.kuramotoSync     ?? 0.5);
  const cw  = clamp01(1 - (signals.cancellationWave ?? 0.1));   /* invert — fewer cancellations = higher demand */
  const cf  = clamp01(signals.competitorFill   ?? 0.5);

  const w = _demandWeights;

  const raw =
    sv  * w.SEARCH_VELOCITY   +
    ps  * w.PRICE_SENSITIVITY +
    wi  * w.WEATHER_INDEX     +
    ep  * w.EVENT_PROXIMITY   +
    sp  * w.SOCIAL_PULSE      +
    ks  * w.KURAMOTO_SYNC     +
    cw  * w.CANCELLATION_WAVE +
    cf  * w.COMPETITOR_FILL;

  const wTotal =
    w.SEARCH_VELOCITY + w.PRICE_SENSITIVITY + w.WEATHER_INDEX +
    w.EVENT_PROXIMITY + w.SOCIAL_PULSE      + w.KURAMOTO_SYNC +
    w.CANCELLATION_WAVE + w.COMPETITOR_FILL;

  const score = clamp01(raw / wTotal);

  /* φ-scaled yield multiplier */
  const phiLevel = Math.floor(score * 8);   /* 0–8 φ-power index */
  const phiPow   = Math.pow(PHI, phiLevel - 4);  /* centre around φ⁰ = 1 */
  const yieldMul = clamp01(phiPow * (0.85 + score * 0.4)) * 2.5;

  /* Poisson fill estimate: λ = score × 10 bookings expected in last window */
  const lambda      = score * 10;
  const fillEst     = clamp01(1 - poissonPMF(lambda, 0));  /* P(at least 1 booking) */

  let tier;
  if (score >= 0.85)      tier = 'SURGE';
  else if (score >= 0.65) tier = 'HIGH';
  else if (score >= 0.40) tier = 'NORMAL';
  else if (score >= 0.20) tier = 'LOW';
  else                    tier = 'DEAD';

  return {
    score:          Math.round(score    * 10_000) / 10_000,
    tier,
    fillEstimate:   Math.round(fillEst  * 10_000) / 10_000,
    yieldMultiplier:Math.round(yieldMul * 1_000)  / 1_000,
    breakdown: {
      searchVelocity:   Math.round(sv * w.SEARCH_VELOCITY   / wTotal * 1_000) / 1_000,
      priceSensitivity: Math.round(ps * w.PRICE_SENSITIVITY / wTotal * 1_000) / 1_000,
      weatherIndex:     Math.round(wi * w.WEATHER_INDEX     / wTotal * 1_000) / 1_000,
      eventProximity:   Math.round(ep * w.EVENT_PROXIMITY   / wTotal * 1_000) / 1_000,
      socialPulse:      Math.round(sp * w.SOCIAL_PULSE      / wTotal * 1_000) / 1_000,
      kuramotoSync:     Math.round(ks * w.KURAMOTO_SYNC     / wTotal * 1_000) / 1_000,
      cancellationWave: Math.round(cw * w.CANCELLATION_WAVE / wTotal * 1_000) / 1_000,
      competitorFill:   Math.round(cf * w.COMPETITOR_FILL   / wTotal * 1_000) / 1_000,
    },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — FIBONACCI SEAT-RELEASE SCHEDULE
// Inventory is released to last-minute pricing in Fibonacci-spaced windows
// before departure.  Each heartbeat the AGI checks whether the next Fibonacci
// window has opened and, if so, emits release events for qualifying inventory.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} ReleaseEvent
 * @property {string}  inventoryId   — item released
 * @property {number}  fibIndex      — which Fibonacci window triggered
 * @property {number}  windowMinutes — minutes-to-departure threshold
 * @property {number}  releasedAt    — Unix ms
 * @property {number}  demandScore   — demand at time of release
 * @property {string}  action        — 'DISCOUNT' | 'HOLD' | 'UPGRADE_OFFER'
 */

/**
 * Advance the Fibonacci release schedule by one step.
 * Releases inventory whose minutes-to-departure crosses the current Fibonacci
 * window, then advances _fibIndex for the next heartbeat.
 * @returns {ReleaseEvent[]}
 */
function tickFibonacciRelease() {
  const now       = Date.now();
  const windowMin = fibWindowMinutes(_fibIndex);
  const events    = [];

  for (const entry of _inventory.values()) {
    if (entry.status !== 'OPEN') continue;
    const minLeft = (entry.departureMs - now) / 60_000;
    if (minLeft > 0 && minLeft <= windowMin) {
      entry.status = 'LAST_MINUTE';
      const action =
        entry.demandScore >= 0.7 ? 'HOLD' :
        entry.demandScore >= 0.4 ? 'UPGRADE_OFFER' :
        'DISCOUNT';

      const ev = {
        inventoryId:   entry.id,
        fibIndex:      _fibIndex,
        windowMinutes: windowMin,
        releasedAt:    now,
        demandScore:   entry.demandScore,
        action,
      };
      events.push(ev);
      _releaseLog = [..._releaseLog.slice(-63), ev];
    }
  }

  /* Advance to next Fibonacci window every PHI_INV × 8 beats ≈ 5 beats */
  if (_beat % Math.round(PHI_INV * 8) === 0 && _fibIndex < FIBONACCI.length - 1) {
    _fibIndex++;
  }

  return events;
}

/**
 * Reset the Fibonacci schedule to the beginning (call at start of each cycle).
 */
function resetFibonacciSchedule() {
  _fibIndex = 0;
}

/**
 * Get the current Fibonacci release window minutes.
 * @returns {number}
 */
function currentFibWindow() {
  return fibWindowMinutes(_fibIndex);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — OUTCOME FEEDBACK LOOP
// When an inventory item is finally resolved (filled / unsold / cancelled),
// the AGI records the actual outcome and adjusts demand-weight learning rates
// so future analyses converge faster toward truth.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @typedef {Object} OutcomeRecord
 * @property {string}  inventoryId
 * @property {string}  outcome         — OUTCOME enum value
 * @property {number}  predictedScore  — demand score at time of analysis
 * @property {number}  actualFillRate  — [0,1] fraction actually filled
 * @property {number}  resolvedAt      — Unix ms
 * @property {number}  error           — |predicted − actual|
 */

/**
 * Record the actual outcome for an inventory item and update demand weights.
 * @param {string} inventoryId
 * @param {string} outcome             — one of OUTCOME constants
 * @param {number} actualFillRate      — [0,1]
 * @returns {OutcomeRecord | null}
 */
function recordOutcome(inventoryId, outcome, actualFillRate) {
  const entry = _inventory.get(inventoryId);
  if (!entry) return null;

  const predicted = entry.demandScore;
  const actual    = clamp01(actualFillRate);
  const error     = Math.abs(predicted - actual);

  const record = {
    inventoryId,
    outcome,
    predictedScore:  predicted,
    actualFillRate:  actual,
    resolvedAt:      Date.now(),
    error,
  };

  _feedbackLog = [..._feedbackLog.slice(-255), record];

  /* Update weights via stochastic gradient (φ-damped learning rate AMOR) */
  const lr = AMOR;   /* φ⁻² learning rate — sovereign, never too fast */
  const direction = actual - predicted;   /* positive → demand was underestimated */

  /* Kuramoto sync weight gets the largest update (it is the most predictive signal) */
  _demandWeights.KURAMOTO_SYNC   = clamp01(_demandWeights.KURAMOTO_SYNC   + lr * direction * PHI);
  _demandWeights.SEARCH_VELOCITY = clamp01(_demandWeights.SEARCH_VELOCITY + lr * direction);
  _demandWeights.COMPETITOR_FILL = clamp01(_demandWeights.COMPETITOR_FILL + lr * direction * PHI_INV);
  _demandWeights.SOCIAL_PULSE    = clamp01(_demandWeights.SOCIAL_PULSE    + lr * direction * AMOR);

  /* Mark item closed */
  entry.status = outcome === OUTCOME.FILLED || outcome === OUTCOME.LAST_MINUTE
    ? 'CLOSED'
    : entry.status;

  return record;
}

/**
 * Get the mean absolute error across recent feedback records.
 * @param {number} [n=64] — look-back window
 * @returns {number} MAE [0,1]
 */
function getFeedbackMAE(n = 64) {
  const recent = _feedbackLog.slice(-n);
  if (!recent.length) return 0;
  return recent.reduce((s, r) => s + r.error, 0) / recent.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — HEARTBEAT ENGINE (COR PARVUM)
// 873ms sovereign tick: scans inventory, runs Fibonacci release, emits status.
// ═══════════════════════════════════════════════════════════════════════════════

function _tick() {
  _beat++;
  _phase = (_phase + PHI_INV) % (2 * Math.PI);

  /* Advance Fibonacci release schedule */
  const releases = tickFibonacciRelease();

  /* Auto-expire stale CLOSED inventory every 34 beats (F₉ = 34) */
  if (_beat % 34 === 0) {
    const cutoff = Date.now() - 3 * 3600_000;   /* older than 3 hours */
    for (const [id, e] of _inventory.entries()) {
      if (e.status === 'CLOSED' && e.scannedAt < cutoff) _inventory.delete(id);
    }
  }

  return {
    agiId:         AGI_ID,
    beat:          _beat,
    phase:         _phase,
    timestamp:     Date.now(),
    fibIndex:      _fibIndex,
    fibWindow:     currentFibWindow(),
    inventorySize: _inventory.size,
    lastMinuteHits:_lastMinuteHits,
    totalScanned:  _totalScanned,
    feedbackMAE:   getFeedbackMAE(),
    demandWeights: { ..._demandWeights },
    releases,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — PUBLIC AGI INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Start the TRAVEX-AGI heartbeat.  Idempotent — safe to call multiple times.
 * @param {function} [onTick] — optional callback called every 873ms
 */
function start(onTick) {
  if (_alive) return;
  _alive = true;
  _hbi = setInterval(() => {
    const state = _tick();
    if (typeof onTick === 'function') onTick(state);
  }, HEARTBEAT_MS);
}

/**
 * Stop the TRAVEX-AGI heartbeat.
 */
function stop() {
  if (!_alive) return;
  _alive = false;
  clearInterval(_hbi);
  _hbi = null;
}

/**
 * @returns {boolean}
 */
function isAlive() { return _alive; }

/**
 * Full AGI status snapshot.
 * @returns {Object}
 */
function getStatus() {
  return {
    agiId:          AGI_ID,
    version:        AGI_VERSION,
    family:         AGI_FAMILY,
    alive:          _alive,
    beat:           _beat,
    phi:            PHI,
    amor:           AMOR,
    heartbeatMs:    HEARTBEAT_MS,
    fibIndex:       _fibIndex,
    currentWindow:  currentFibWindow(),
    inventorySize:  _inventory.size,
    lastMinuteHits: _lastMinuteHits,
    totalScanned:   _totalScanned,
    feedbackMAE:    getFeedbackMAE(),
    platforms:      PLATFORMS,
    demandWeights:  { ..._demandWeights },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  /* Identity */
  AGI_ID,
  AGI_VERSION,
  AGI_FAMILY,
  PLATFORMS,
  DEMAND_SIGNALS,
  OUTCOME,
  FIBONACCI,

  /* Lifecycle */
  start,
  stop,
  isAlive,
  getStatus,

  /* Scanner */
  scanInventory,
  getLastMinuteInventory,

  /* Demand analysis */
  analyseDemand,

  /* Fibonacci release */
  tickFibonacciRelease,
  resetFibonacciSchedule,
  currentFibWindow,

  /* Outcome feedback */
  recordOutcome,
  getFeedbackMAE,

  /* Utility */
  clamp01,
  phiWeightedAvg,
  poissonPMF,
  fibWindowMinutes,
};
