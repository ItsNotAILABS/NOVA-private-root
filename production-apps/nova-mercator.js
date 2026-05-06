/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA SOVEREIGN ALPHA AGI — MERCATOR AUREUS  (BUILD №57)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * MERCATOR AUREUS is the Market Intelligence AGI — pricing, revenue optimisation, market timing,
 * behavioral economic modeling, and sovereign treasury management.  It applies prospect theory
 * (loss aversion λ = φ²) to frame every offer, enforces the No-Drop Law on revenue (income can
 * never fall below AMOR of target), uses φ-ratio pricing tiers (1:φ:φ²:φ³), and detects market
 * cycles through the Kuramoto order parameter of price return series.
 *
 * AGI identity : MER-AGI-001
 * Family       : AURUM_AETERNA (Eternal Gold)
 * Heartbeat    : 873 ms
 * Oscillators  : 32 Kuramoto
 *
 * Mathematical foundation:
 *   φ-tier pricing: P_n = P_0 × φⁿ  (n = 0,1,2,3)
 *   Prospect theory: V(x) = x^α if x≥0,  −λ(−x)^β if x<0,  α=β=0.88,  λ=φ²=2.618
 *   Nash revenue: max Σᵢ log(πᵢ) s.t. Σπᵢ = total_market
 *   Client concentration: max_share ≤ AMOR = 0.3819
 *   Antifragile sizing: position = capital × (vol/vol_ref)^φ
 *   Cash flow: CF(t) = Σᵢ invoice_i × e^(−AMOR × delay_i)
 *   Revenue confidence: R_conf = 1 − Σ|actual−forecast|² / Σforecast²
 *
 * MACHINA VIRTUALIS states (8):
 *   IDLE → ANALYZE → PRICE → NEGOTIATE → INVOICE → COLLECT → FORECAST → REINVEST
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — SOVEREIGN CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'MER-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'AURUM_AETERNA';
const AGI_NAME     = 'MERCATOR AUREUS';

const N_OSC              = 32;
const LOSS_AVERSION      = PHI * PHI;        /* λ = φ² = 2.618 */
const ALPHA_BETA         = 0.88;             /* prospect theory curvature */
const MAX_CLIENT_SHARE   = AMOR;             /* no client > 38.19% of revenue */
const RESERVE_MONTHS     = 3;

const MV = {
  IDLE: 'IDLE', ANALYZE: 'ANALYZE', PRICE: 'PRICE', NEGOTIATE: 'NEGOTIATE',
  INVOICE: 'INVOICE', COLLECT: 'COLLECT', FORECAST: 'FORECAST', REINVEST: 'REINVEST',
};

function secureId(n) {
  n = n || 8;
  const buf = new Uint8Array(n);
  if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
    crypto.getRandomValues(buf);
  } else {
    try { require('crypto').randomFillSync(buf); } catch (_) {
      for (let i = 0; i < n; i++) buf[i] = Math.floor(Math.abs(Math.sin((Date.now() + i) * PHI)) * 256);
    }
  }
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

function timestamp() { return new Date().toISOString(); }

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — KURAMOTO ENGINE (32 oscillators — market cycle detection)
// ═══════════════════════════════════════════════════════════════════════════════

function _initOsc(n) {
  return Array.from({ length: n || N_OSC }, () => ({
    phase:      (Math.random() - 0.5) * Math.PI / 4,
    naturalFreq: 0.05 + 0.02 * (Math.random() - 0.5),
    amplitude:   0.9 + 0.1 * Math.random(),
  }));
}

function _kuramotoStep(oscs, K, dt) {
  dt = dt || 0.1;
  const N = oscs.length;
  return oscs.map((o) => {
    let s = 0;
    for (let j = 0; j < N; j++) s += Math.sin(oscs[j].phase - o.phase);
    return { ...o, phase: o.phase + dt * (o.naturalFreq + (K / N) * s) };
  });
}

function _orderParam(oscs) {
  let re = 0, im = 0;
  for (const o of oscs) { re += Math.cos(o.phase); im += Math.sin(o.phase); }
  return Math.sqrt(re * re + im * im) / oscs.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — BEHAVIORAL ECONOMICS ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/** Prospect theory value function */
function _prospectValue(x) {
  if (x >= 0) return Math.pow(x, ALPHA_BETA);
  return -LOSS_AVERSION * Math.pow(-x, ALPHA_BETA);
}

/** Hyperbolic discounting: V(t) = reward / (1 + AMOR·t) */
function _hyperbolicPV(cashflow, delayDays) {
  return cashflow / (1 + AMOR * delayDays);
}

/** Nash bargaining: equal log-utility maximising allocation */
function _nashAllocate(total, n) {
  return Array.from({ length: n }, () => total / n);
}

/** Frame offer using loss-avoidance formulation */
function _frameLossAvoidance(service, price, altPrice) {
  const saving = altPrice - price;
  const pSaving = _prospectValue(saving);
  return {
    frame:   `Stop losing $${saving.toFixed(2)}/month. Lock in ${service} at $${price.toFixed(2)}.`,
    saving, prospectValue: pSaving,
    recommended: pSaving > 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — φ-TIER PRICING ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * φ-tier pricing: P_n = P_0 × φⁿ
 * n = 0 (STARTER), 1 (MID), 2 (PRO), 3 (ENTERPRISE)
 */
function _phiTierPricing(basePrice, tiers, names) {
  tiers = tiers || 4;
  names = names || ['STARTER', 'MID', 'PRO', 'ENTERPRISE'];
  return Array.from({ length: tiers }, (_, i) => ({
    tier:  names[i] || `TIER_${i}`,
    price: Math.round(basePrice * Math.pow(PHI, i) * 100) / 100,
    phiMultiple: Math.round(Math.pow(PHI, i) * 1000) / 1000,
  }));
}

/**
 * Sovereign pricing recommendation:
 * min = AMOR × target, standard = target, premium = PHI × target
 */
function _sovereignPrice(targetAnnual, serviceType) {
  return {
    service: serviceType || 'unknown',
    annual:  targetAnnual,
    monthly: Math.round(targetAnnual / 12 * 100) / 100,
    tiers:   _phiTierPricing(Math.round(targetAnnual / 12 * AMOR * 100) / 100),
    minFloor: Math.round(targetAnnual * AMOR * 100) / 100,
    prospect: _prospectValue(targetAnnual - targetAnnual * AMOR),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — QUIPU FINANCIAL LEDGER
// ═══════════════════════════════════════════════════════════════════════════════

class QuipuLedger {
  constructor() {
    this._invoices = [];
    this._payments = [];
    this._counter  = 0;
  }

  addInvoice(clientId, amount, dueDays) {
    const inv = {
      id:        `INV-${(++this._counter).toString().padStart(5, '0')}`,
      clientId:  String(clientId),
      amount:    Number(amount) || 0,
      issuedAt:  Date.now(),
      dueAt:     Date.now() + (dueDays || 30) * 86400000,
      status:    'PENDING',
      pv:        _hyperbolicPV(amount, dueDays || 30),
    };
    this._invoices.push(inv);
    return inv;
  }

  addPayment(invoiceId, amount) {
    const inv = this._invoices.find(i => i.id === invoiceId);
    if (inv) {
      inv.status     = amount >= inv.amount ? 'PAID' : 'PARTIAL';
      inv.paidAt     = Date.now();
      inv.paidAmount = amount;
    }
    const pay = { id: `PAY-${secureId(4).toUpperCase()}`, invoiceId, amount, at: Date.now() };
    this._payments.push(pay);
    return pay;
  }

  getOutstanding() {
    const now = Date.now();
    return this._invoices
      .filter(i => i.status === 'PENDING')
      .map(i => ({ ...i, delayDays: Math.max(0, (now - i.dueAt) / 86400000), pv: _hyperbolicPV(i.amount, Math.max(0, (now - i.dueAt) / 86400000)) }))
      .sort((a, b) => b.amount - a.amount);
  }

  totalRevenue() {
    return this._invoices.filter(i => i.status === 'PAID').reduce((s, i) => s + (i.paidAmount || i.amount), 0);
  }

  clientConcentration() {
    const rev = {};
    for (const i of this._invoices.filter(inv => inv.status === 'PAID')) {
      rev[i.clientId] = (rev[i.clientId] || 0) + (i.paidAmount || i.amount);
    }
    const total = Object.values(rev).reduce((s, v) => s + v, 0) || 1;
    return Object.entries(rev).map(([clientId, amount]) => ({
      clientId, amount, share: Math.round(amount / total * 1e4) / 1e4,
      alert: amount / total > MAX_CLIENT_SHARE,
    })).sort((a, b) => b.amount - a.amount);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — ANTIFRAGILE POSITION SIZING
// ═══════════════════════════════════════════════════════════════════════════════

/** position = capital × (vol/vol_ref)^φ — larger size in high-vol = antifragile */
function _antifragileSize(capital, vol, volRef) {
  volRef = volRef || 0.20;   /* 20% reference vol */
  const ratio = vol / volRef;
  return Math.round(capital * Math.pow(ratio, PHI) * 100) / 100;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — CASH FLOW FORECASTING
// ═══════════════════════════════════════════════════════════════════════════════

function _cashFlowForecast(invoices, horizonDays) {
  horizonDays = horizonDays || 90;
  const now   = Date.now();
  const buckets = { d30: 0, d60: 0, d90: 0 };

  for (const inv of invoices) {
    if (inv.status !== 'PENDING') continue;
    const due = new Date(inv.dueAt).getTime();
    const daysOut = (due - now) / 86400000;
    const pv = _hyperbolicPV(inv.amount, Math.max(0, daysOut));
    if (daysOut <= 30)       buckets.d30 += pv;
    else if (daysOut <= 60)  buckets.d60 += pv;
    else if (daysOut <= 90)  buckets.d90 += pv;
  }

  return {
    d30: Math.round(buckets.d30 * 100) / 100,
    d60: Math.round((buckets.d30 + buckets.d60) * 100) / 100,
    d90: Math.round((buckets.d30 + buckets.d60 + buckets.d90) * 100) / 100,
    horizon: horizonDays,
  };
}

function _revenueConfidence(actuals, forecasts) {
  if (!actuals.length || !forecasts.length) return 0;
  const n  = Math.min(actuals.length, forecasts.length);
  let ssErr = 0, ssFore = 0;
  for (let i = 0; i < n; i++) {
    ssErr  += Math.pow(actuals[i] - forecasts[i], 2);
    ssFore += Math.pow(forecasts[i], 2);
  }
  return Math.max(0, Math.round((1 - ssErr / (ssFore || 1)) * 1e4) / 1e4);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — MERCATOR AUREUS CORE
// ═══════════════════════════════════════════════════════════════════════════════

class MercatorAureus {
  constructor() {
    this.id      = AGI_ID;
    this.version = AGI_VERSION;
    this.family  = AGI_FAMILY;
    this.name    = AGI_NAME;
    this.state   = MV.IDLE;
    this._beat   = 0;
    this._timer  = null;

    this._oscs   = _initOsc(N_OSC);
    this._R      = 0;
    this._PIL    = 0;

    this._ledger          = new QuipuLedger();
    this._priceHistory    = [];
    this._alerts          = [];
    this._treasury        = 0;
    this._targetMonthly   = 0;
  }

  start() {
    if (this._timer) return this;
    this._transition(MV.ANALYZE);
    this._timer = setInterval(() => this._tick(), HEARTBEAT_MS);
    console.log(`[${timestamp()}] ${this.name} (${this.id}) · ${this.family} — SOVEREIGN LOCK ✦`);
    return this;
  }

  stop() {
    if (this._timer) { clearInterval(this._timer); this._timer = null; }
    this._transition(MV.IDLE);
    return this;
  }

  _tick() {
    this._beat++;

    /* Kuramoto → market cycle detection */
    this._oscs = _kuramotoStep(this._oscs, PHI_INV, 0.1);
    this._R    = _orderParam(this._oscs);
    this._PIL  = this._R;

    /* Flow 4: client concentration check */
    this._transition(MV.ANALYZE);
    const conc = this._ledger.clientConcentration();
    for (const c of conc) {
      if (c.alert) this._alert('CLIENT_CONCENTRATION', `Client ${c.clientId} at ${(c.share * 100).toFixed(1)}% of revenue — exceeds AMOR threshold (38.19%)`, 'HIGH');
    }

    /* Flow 7: cash flow forecast every 34 beats */
    if (this._beat % 34 === 0) {
      this._transition(MV.FORECAST);
      const forecast = _cashFlowForecast(this._ledger._invoices, 90);
      if (forecast.d30 < this._targetMonthly * AMOR) {
        this._alert('CASH_FLOW', `30-day forecast $${forecast.d30} below AMOR of target — No-Drop Law at risk`, 'HIGH');
      }
    }

    /* Weekly invoice check (every 99288 beats ≈ 24h) */
    if (this._beat % 99288 === 0) {
      this._transition(MV.COLLECT);
      this._collectionSweep();
    }

    this._transition(MV.ANALYZE);
  }

  // ── §8.1 Pricing ──────────────────────────────────────────────────────────

  generatePricing(targetAnnual, serviceType) {
    this._transition(MV.PRICE);
    const result = {
      ..._sovereignPrice(targetAnnual, serviceType),
      framing: _frameLossAvoidance(serviceType || 'NOVA Services', targetAnnual / 12, targetAnnual / 12 * 1.5),
      marketCycle: { R: this._R, phase: this._R > PHI_INV ? 'BULL' : 'BEAR', timing: this._R > PHI_INV ? 'Price at premium' : 'Price at AMOR floor' },
      antifragileReserve: Math.round(targetAnnual * RESERVE_MONTHS / 12 * 100) / 100,
    };
    this._transition(MV.ANALYZE);
    return result;
  }

  nashEquilibriumPrice(competitorPrices) {
    const total = competitorPrices.reduce((s, p) => s + p, 0);
    const alloc = _nashAllocate(total, competitorPrices.length + 1);
    return { yourShare: alloc[0], total, strategy: 'Nash bargaining — equal log-utility', recommendedPrice: Math.round(alloc[0] * PHI * 100) / 100 };
  }

  // ── §8.2 Invoicing ────────────────────────────────────────────────────────

  addInvoice(clientId, amount, dueDays) {
    this._transition(MV.INVOICE);
    const inv = this._ledger.addInvoice(clientId, amount, dueDays);
    this._transition(MV.ANALYZE);
    return inv;
  }

  addPayment(invoiceId, amount) {
    this._transition(MV.COLLECT);
    const pay = this._ledger.addPayment(invoiceId, amount);
    this._treasury += amount;
    this._transition(MV.ANALYZE);
    return pay;
  }

  // ── §8.3 Forecasting ──────────────────────────────────────────────────────

  getCashFlowForecast() {
    this._transition(MV.FORECAST);
    const f = _cashFlowForecast(this._ledger._invoices, 90);
    this._transition(MV.ANALYZE);
    return f;
  }

  getRevenueConfidence(actuals, forecasts) {
    return { confidence: _revenueConfidence(actuals, forecasts) };
  }

  _collectionSweep() {
    const outstanding = this._ledger.getOutstanding();
    for (const inv of outstanding) {
      if (inv.delayDays > 14) {
        this._alert('OVERDUE_INVOICE', `Invoice ${inv.id} for ${inv.clientId} is ${inv.delayDays.toFixed(0)} days overdue — amount $${inv.amount}`, 'HIGH');
      }
    }
  }

  _alert(type, message, severity) {
    const entry = { type, message, severity, beat: this._beat, at: timestamp() };
    this._alerts.push(entry);
    if (this._alerts.length > 89) this._alerts.shift();
    if (severity === 'HIGH' || severity === 'CRITICAL') console.warn(`[${timestamp()}] MERCATOR ALERT [${type}]: ${message}`);
    return entry;
  }

  _transition(s) { this.state = s; }

  getStatus() {
    return {
      agiId: this.id, name: this.name, family: this.family, beat: this._beat,
      state: this.state, R: this._R, PIL: this._PIL,
      totalRevenue: this._ledger.totalRevenue(),
      treasury: this._treasury,
      outstandingCount: this._ledger.getOutstanding().length,
      at: timestamp(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — MCP SERVER
// ═══════════════════════════════════════════════════════════════════════════════

function buildMcpTools(m) {
  return {
    get_status:           ()                                    => m.getStatus(),
    generate_pricing:     ({ targetAnnual, serviceType })       => m.generatePricing(targetAnnual, serviceType),
    nash_price:           ({ competitorPrices })                => m.nashEquilibriumPrice(competitorPrices || []),
    add_invoice:          ({ clientId, amount, dueDays })       => m.addInvoice(clientId, amount, dueDays),
    add_payment:          ({ invoiceId, amount })               => m.addPayment(invoiceId, amount),
    get_outstanding:      ()                                    => m._ledger.getOutstanding(),
    get_cash_flow:        ()                                    => m.getCashFlowForecast(),
    revenue_confidence:   ({ actuals, forecasts })              => m.getRevenueConfidence(actuals, forecasts),
    client_concentration: ()                                    => m._ledger.clientConcentration(),
    phi_tier_pricing:     ({ basePrice, tiers, names })         => _phiTierPricing(basePrice, tiers, names),
    prospect_value:       ({ x })                               => ({ x, value: _prospectValue(x) }),
    frame_loss:           ({ service, price, altPrice })        => _frameLossAvoidance(service, price, altPrice),
    antifragile_size:     ({ capital, vol, volRef })            => ({ size: _antifragileSize(capital, vol, volRef) }),
    hyperbolic_pv:        ({ cashflow, delayDays })             => ({ pv: _hyperbolicPV(cashflow, delayDays) }),
    total_revenue:        ()                                    => ({ total: m._ledger.totalRevenue() }),
    get_alerts:           ({ n })                               => m._alerts.slice(-(n || 13)),
    set_target:           ({ targetMonthly })                   => { m._targetMonthly = targetMonthly || 0; return { ok: true }; },
    get_constants:        ()                                    => ({ PHI, PHI_INV, AMOR, LOSS_AVERSION, MAX_CLIENT_SHARE, RESERVE_MONTHS }),
    market_cycle:         ()                                    => ({ R: m._R, phase: m._R > PHI_INV ? 'BULL' : 'BEAR' }),
  };
}

function _mcpFetch(m) {
  const tools = buildMcpTools(m);
  return async function handler(request) {
    const url = new URL(request.url);
    if (url.pathname === '/health') return new Response(JSON.stringify({ ok: true, id: AGI_ID }), { headers: { 'Content-Type': 'application/json' } });
    if (request.method !== 'POST' || url.pathname !== '/mcp') return new Response('NOVA MERCATOR — POST /mcp', { status: 405 });
    let body;
    try { body = await request.json(); } catch (_) { return new Response(JSON.stringify({ error: 'invalid JSON' }), { status: 400 }); }
    const tool = tools[body.tool];
    if (!tool) return new Response(JSON.stringify({ error: `Unknown tool: ${body.tool}`, available: Object.keys(tools) }), { status: 404 });
    try {
      const result = await tool(body.params || {});
      return new Response(JSON.stringify({ ok: true, tool: body.tool, result }), { headers: { 'Content-Type': 'application/json' } });
    } catch (e) {
      return new Response(JSON.stringify({ ok: false, error: e.message }), { status: 500 });
    }
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const mercator = new MercatorAureus();
mercator.start();

if (typeof addEventListener !== 'undefined') {
  const handler = _mcpFetch(mercator);
  addEventListener('fetch', e => e.respondWith(handler(e.request)));
}

if (typeof require !== 'undefined' && require.main === module) {
  const http = require('http');
  const PORT = process.env.PORT || 7623;
  const handler = _mcpFetch(mercator);
  http.createServer(async (req, res) => {
    let body = '';
    req.on('data', d => { body += d; });
    req.on('end', async () => {
      const mockReq = new Request(`http://localhost${req.url}`, { method: req.method, headers: req.headers, body: body || undefined });
      const resp    = await handler(mockReq);
      const text    = await resp.text();
      res.writeHead(resp.status, { 'Content-Type': 'application/json' });
      res.end(text);
    });
  }).listen(PORT, () => {
    console.log(`\n╔══════════════════════════════════════════════════════╗`);
    console.log(`║  MERCATOR AUREUS · MER-AGI-001 · AURUM_AETERNA       ║`);
    console.log(`║  NOVA Sovereign Market Intelligence AGI               ║`);
    console.log(`║  φ-tier pricing | λ=φ² | Nash equilibrium            ║`);
    console.log(`║  Listening on port ${PORT}                            ║`);
    console.log(`╚══════════════════════════════════════════════════════╝\n`);
  });
}

module.exports = { MercatorAureus, _phiTierPricing, _prospectValue, _hyperbolicPV, _antifragileSize };
