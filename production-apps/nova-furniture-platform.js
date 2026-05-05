/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA COMMERCIAL FURNITURE PLATFORM — PRODUCTION APP
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * NOVA FURNITURE OS is a full commercial furniture installation, business,
 * and interior design intelligence platform.  It manages the entire lifecycle:
 *
 *   QUOTE → DESIGN → SCHEDULE → PROCURE → INSTALL → INSPECT → INVOICE → WARRANTY
 *
 * Verticals served:
 *   1. OFFICIUM     — corporate / office furniture installation
 *   2. HOSPITIUM    — hospitality (hotels, restaurants, lobbies)
 *   3. MEDICA       — healthcare (clinics, hospitals, ergonomic medical)
 *   4. EDUCATIO     — educational (schools, universities, libraries)
 *   5. DOMUM        — residential high-end (design + install)
 *   6. FABRICA      — manufacturing (factory floor, workstations)
 *   7. COMMERCIUM   — retail showrooms and commercial fitout
 *   8. GUBERNATOR   — government / municipal contracts
 *
 * Powered by:
 *   - PROTOCOL-SAFETY  — worksite safety monitoring
 *   - PROTOCOL-HEALTH  — team health tracking
 *   - PROTOCOL-WELLNESS— operator wellness
 *   - PROTOCOL-TRUST   — client / supplier trust scores
 *   - EMBED-AGI-001    — design intent embedding and matching
 *   - SOLVER-AGI-001   — constraint-based layout optimisation
 *
 * AGI identity: FURNITURE-AGI-001
 * Family: STRUCTURA_AETERNA (eternal structure)
 * Heartbeat: 873ms
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID      = 'FURNITURE-AGI-001';
const AGI_VERSION = '1.0.0';
const AGI_FAMILY  = 'STRUCTURA_AETERNA';

/** Business verticals */
const VERTICAL = {
  OFFICIUM:    { id: 'OFFICIUM',    label: 'Corporate Office',         margin: 0.38 },
  HOSPITIUM:   { id: 'HOSPITIUM',   label: 'Hospitality',              margin: 0.42 },
  MEDICA:      { id: 'MEDICA',      label: 'Healthcare / Medical',     margin: 0.45 },
  EDUCATIO:    { id: 'EDUCATIO',    label: 'Educational',              margin: 0.28 },   /* lower margin — social good */
  DOMUM:       { id: 'DOMUM',       label: 'Residential High-End',     margin: 0.55 },
  FABRICA:     { id: 'FABRICA',     label: 'Manufacturing / Industrial',margin: 0.32 },
  COMMERCIUM:  { id: 'COMMERCIUM',  label: 'Retail / Commercial',      margin: 0.40 },
  GUBERNATOR:  { id: 'GUBERNATOR',  label: 'Government / Municipal',   margin: 0.25 },   /* bid margin */
};

/** Project lifecycle states */
const PROJECT_STATE = {
  INQUIRY:     'INQUIRY',
  QUOTED:      'QUOTED',
  APPROVED:    'APPROVED',
  DESIGN:      'DESIGN',
  PROCURING:   'PROCURING',
  SCHEDULED:   'SCHEDULED',
  INSTALLING:  'INSTALLING',
  INSPECTING:  'INSPECTING',
  COMPLETE:    'COMPLETE',
  INVOICED:    'INVOICED',
  WARRANTY:    'WARRANTY',
  CLOSED:      'CLOSED',
};

/** Installation work types */
const WORK_TYPE = {
  DELIVERY:       'DELIVERY',         /* drop-ship, no install */
  STANDARD_INSTALL:'STANDARD_INSTALL', /* assembly + placement */
  FULL_INSTALL:   'FULL_INSTALL',     /* wall anchoring, hardwired, full setup */
  DESIGN_BUILD:   'DESIGN_BUILD',     /* design + procure + install */
  RECONFIGURATION:'RECONFIGURATION',  /* rearrange/repurpose existing */
  DECOMMISSION:   'DECOMMISSION',     /* removal and disposal */
};

/** Standard room types for layout engine */
const ROOM_TYPE = {
  OPEN_OFFICE:   'OPEN_OFFICE',
  PRIVATE_OFFICE:'PRIVATE_OFFICE',
  CONFERENCE:    'CONFERENCE',
  RECEPTION:     'RECEPTION',
  BREAKROOM:     'BREAKROOM',
  TRAINING:      'TRAINING',
  LOBBY:         'LOBBY',
  PATIENT_ROOM:  'PATIENT_ROOM',
  CLASSROOM:     'CLASSROOM',
  SHOWROOM:      'SHOWROOM',
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

function _now() { return Date.now(); }

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — PROJECT RECORD
// ═══════════════════════════════════════════════════════════════════════════════

let _projCounter = 1000;

/**
 * Create a new project record.
 */
function createProject(opts) {
  opts = opts || {};
  return {
    projectId:    `FRN-${(++_projCounter).toString().padStart(4, '0')}`,
    vertical:     opts.vertical     || VERTICAL.OFFICIUM.id,
    workType:     opts.workType     || WORK_TYPE.FULL_INSTALL,
    clientId:     String(opts.clientId   || ''),
    clientName:   String(opts.clientName || ''),
    siteName:     String(opts.siteName   || ''),
    siteAddress:  String(opts.siteAddress|| ''),
    rooms:        opts.rooms         || [],
    state:        PROJECT_STATE.INQUIRY,
    lineItems:    [],
    quote:        null,
    invoice:      null,
    crew:         [],
    safetyPlanId: null,
    notes:        [],
    timeline:     [],
    createdAt:    _now(),
    updatedAt:    _now(),
  };
}

function _transition(project, toState, by) {
  if (!project) return;
  project.state     = toState;
  project.updatedAt = _now();
  project.timeline.push({ from: project.state, to: toState, by: String(by || 'SYSTEM'), at: _now() });
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — LAYOUT ENGINE (φ-ratio space planning)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Compute the optimal number of workstations for an open office room
 * using φ-ratio space standards.
 *
 * Industry standard: 100–150 sq ft per person.
 * Sovereign standard: PHI × 100 sq ft = 161.8 sq ft per person (premium).
 *
 * @param {{ widthFt: number, depthFt: number, workstationSizeFt?: number }} room
 * @returns {{ capacity: number, recommended: number, layout: string }}
 */
function planOpenOffice(room) {
  const area      = (room.widthFt || 0) * (room.depthFt || 0);
  const wsSize    = room.workstationSizeFt || (PHI * 100);  /* sq ft per workstation */
  const egress    = area * AMOR;                             /* AMOR fraction for aisles + egress */
  const usable    = area - egress;
  const capacity  = Math.floor(usable / 100);               /* code minimum */
  const recommended = Math.floor(usable / wsSize);          /* φ-ratio premium */
  const rows      = Math.round(Math.sqrt(recommended * room.widthFt / (room.depthFt || 1)));
  const cols      = Math.ceil(recommended / Math.max(1, rows));
  return {
    area:        Math.round(area),
    usable:      Math.round(usable),
    capacity,
    recommended,
    layout:      `${rows} rows × ${cols} columns`,
    wsSize:      Math.round(wsSize * 10) / 10,
    densityScore: Math.round((recommended / Math.max(1, capacity)) * 1e4) / 1e4,
  };
}

/**
 * Plan a conference room.
 * Standard: 25 sq ft per seat.
 * Sovereign: PHI⁻¹ × 50 sq ft = 30.9 sq ft per seat.
 */
function planConferenceRoom(room) {
  const area         = (room.widthFt || 0) * (room.depthFt || 0);
  const sqFtPerSeat  = PHI_INV * 50;
  const seats        = Math.floor(area * (1 - AMOR) / sqFtPerSeat);
  const tableW       = Math.round((room.widthFt || 0) * PHI_INV * 10) / 10;
  const tableD       = Math.round((room.depthFt || 0) * PHI_INV * 10) / 10;
  return { area: Math.round(area), seats, tableWidth: tableW, tableDepth: tableD, sqFtPerSeat: Math.round(sqFtPerSeat * 10) / 10 };
}

/**
 * General room layout planner — dispatches by room type.
 */
function planRoom(room) {
  switch (room.type) {
    case ROOM_TYPE.OPEN_OFFICE:    return planOpenOffice(room);
    case ROOM_TYPE.CONFERENCE:     return planConferenceRoom(room);
    default: {
      const area = (room.widthFt || 0) * (room.depthFt || 0);
      return { area: Math.round(area), type: room.type, notes: 'Custom layout required — submit to design team.' };
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — QUOTE ENGINE (φ-weighted cost model)
// ═══════════════════════════════════════════════════════════════════════════════

/** Standard labour rates (USD/hour) by work type */
const LABOUR_RATE = {
  [WORK_TYPE.DELIVERY]:         65,
  [WORK_TYPE.STANDARD_INSTALL]: 85,
  [WORK_TYPE.FULL_INSTALL]:     110,
  [WORK_TYPE.DESIGN_BUILD]:     135,
  [WORK_TYPE.RECONFIGURATION]:  90,
  [WORK_TYPE.DECOMMISSION]:     75,
};

/**
 * Add a line item to a project.
 * @param {Object} project
 * @param {{ description, qty, unitCost, category }} item
 */
function addLineItem(project, item) {
  const li = {
    lineId:      `LI-${secureId(4).toUpperCase()}`,
    description: String(item.description || ''),
    qty:         Math.max(0, item.qty || 1),
    unitCost:    Math.max(0, item.unitCost || 0),
    category:    item.category || 'PRODUCT',
    total:       0,
  };
  li.total = li.qty * li.unitCost;
  project.lineItems.push(li);
  project.updatedAt = _now();
  return li;
}

/**
 * Generate a quote for a project.
 * Applies φ-tier margin based on vertical.
 * @param {Object} project
 * @param {{ labourHours: number, by: string }} opts
 * @returns {Object} quote
 */
function generateQuote(project, opts) {
  opts = opts || {};
  const vertical     = VERTICAL[project.vertical] || VERTICAL.OFFICIUM;
  const productCost  = project.lineItems.reduce((s, li) => s + li.total, 0);
  const labourHrs    = opts.labourHours || 0;
  const labourCost   = labourHrs * (LABOUR_RATE[project.workType] || 85);
  const subtotal     = productCost + labourCost;
  const margin       = vertical.margin;
  /* φ-freight: AMOR% of product cost for delivery logistics */
  const freight      = productCost * AMOR * 0.25;
  const total        = Math.round((subtotal + freight) * (1 + margin) * 100) / 100;
  /* Sales tax — defaults to Texas rate (8.25%). Override via opts.taxRate for other jurisdictions. */
  const taxRate      = (typeof (opts && opts.taxRate) === 'number') ? opts.taxRate : 0.0825;
  const tax          = Math.round(total * taxRate * 100) / 100;

  const quote = {
    quoteId:     `QTE-${secureId(4).toUpperCase()}`,
    projectId:   project.projectId,
    productCost: Math.round(productCost * 100) / 100,
    labourCost:  Math.round(labourCost * 100) / 100,
    freight:     Math.round(freight * 100) / 100,
    subtotal:    Math.round(subtotal * 100) / 100,
    margin:      Math.round(margin * 100) / 100,
    total,
    tax,
    grandTotal:  Math.round((total + tax) * 100) / 100,
    vertical:    vertical.label,
    preparedBy:  String(opts.by || 'FURNITURE-AGI-001'),
    preparedAt:  _now(),
    validDays:   34,  /* Fibonacci(9) */
    validUntil:  _now() + 34 * 86400000,
  };
  project.quote     = quote;
  project.updatedAt = _now();
  _transition(project, PROJECT_STATE.QUOTED, opts.by || AGI_ID);
  return quote;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — SCHEDULE ENGINE (Fibonacci time blocks)
// ═══════════════════════════════════════════════════════════════════════════════

/** Fibonacci day durations for installation phases */
const FIB_DAYS = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

/**
 * Schedule an installation.
 * @param {Object}   project
 * @param {{ startDate: Date|string, crewSize: number, by: string }} opts
 * @returns {{ schedule: Array, endDate: string }}
 */
function scheduleInstall(project, opts) {
  opts            = opts || {};
  const start     = new Date(opts.startDate || Date.now());
  const crewSize  = Math.max(1, opts.crewSize || 2);
  const items     = project.lineItems.length;

  /* Estimate days: base on item count and crew — φ-efficiency factor */
  const rawDays  = Math.ceil(items / (crewSize * PHI));
  const fibIdx   = FIB_DAYS.findIndex(f => f >= rawDays) > -1 ? FIB_DAYS.findIndex(f => f >= rawDays) : FIB_DAYS.length - 1;
  const days     = FIB_DAYS[fibIdx] || rawDays;

  const phases   = [];
  let   cur      = new Date(start);

  /* Phase 1: Site prep + delivery (AMOR fraction of total days) */
  const p1Days = Math.max(1, Math.round(days * AMOR));
  const p1End  = _addDays(cur, p1Days);
  phases.push({ phase: 'SITE_PREP_DELIVERY', start: _dateStr(cur), end: _dateStr(p1End), days: p1Days, crew: crewSize });
  cur = p1End;

  /* Phase 2: Installation (PHI_INV fraction) */
  const p2Days = Math.max(1, Math.round(days * PHI_INV));
  const p2End  = _addDays(cur, p2Days);
  phases.push({ phase: 'INSTALLATION', start: _dateStr(cur), end: _dateStr(p2End), days: p2Days, crew: crewSize });
  cur = p2End;

  /* Phase 3: Punch list + inspection (remainder) */
  const p3Days = Math.max(1, days - p1Days - p2Days);
  const p3End  = _addDays(cur, p3Days);
  phases.push({ phase: 'PUNCHLIST_INSPECT', start: _dateStr(cur), end: _dateStr(p3End), days: p3Days, crew: Math.ceil(crewSize * AMOR) });

  project.crew    = Array.from({ length: crewSize }, (_, i) => `CREW-${String.fromCharCode(65 + i)}`);
  project.updatedAt = _now();
  _transition(project, PROJECT_STATE.SCHEDULED, opts.by || AGI_ID);

  return { projectId: project.projectId, totalDays: days, startDate: _dateStr(start), endDate: _dateStr(p3End), phases, crew: project.crew };
}

function _addDays(date, n) { const d = new Date(date); d.setDate(d.getDate() + n); return d; }
function _dateStr(date) { return new Date(date).toISOString().split('T')[0]; }

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — INSPECTION ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

const DEFAULT_INSPECTION_ITEMS = [
  { id: 'LEVEL',    item: 'All surfaces level (bubble tolerance < 2mm)' },
  { id: 'SECURE',   item: 'All wall-anchored items secured with rated fasteners' },
  { id: 'DAMAGE',   item: 'No damage to finished surfaces, walls, or floors' },
  { id: 'COMPLETE', item: 'All line items present and accounted for' },
  { id: 'HARDWARE', item: 'All hardware installed (drawer glides, doors, locks)' },
  { id: 'CABLES',   item: 'Cable management completed (grommets, J-channels)' },
  { id: 'LABELS',   item: 'Room/asset labels applied per client plan' },
  { id: 'DEBRIS',   item: 'All packaging and debris removed from site' },
  { id: 'SIGN_OFF', item: 'Client walkthrough completed and approval obtained' },
];

/**
 * Run an installation inspection.
 * @param {Object} project
 * @param {string[]} passedIds — IDs of passed inspection items
 * @param {string}   inspector
 * @returns {{ pass: boolean, score: number, failed: Array, report: string }}
 */
function runInspection(project, passedIds, inspector) {
  const passed  = new Set(passedIds || []);
  const results = DEFAULT_INSPECTION_ITEMS.map(item => ({ id: item.id, item: item.item, passed: passed.has(item.id) }));
  const nPassed = results.filter(r => r.passed).length;
  const score   = nPassed / results.length;
  const pass    = score >= PHI_INV;  /* require ≥ φ⁻¹ ≈ 61.8% to pass */

  const report = [
    `INSPECTION REPORT — ${project.projectId}`,
    `Inspector: ${inspector || 'SYSTEM'}`,
    `Score: ${Math.round(score * 100)}% — ${pass ? 'PASS ✓' : 'FAIL ✗'}`,
    `Passed: ${nPassed}/${results.length}`,
    '',
    pass ? '✓ Installation approved for client sign-off.' : '✗ Punchlist required before client sign-off.',
    '',
    ...results.filter(r => !r.passed).map(r => `  FAIL: ${r.item}`),
  ].join('\n');

  if (pass) _transition(project, PROJECT_STATE.COMPLETE, inspector || AGI_ID);
  return { pass, score: Math.round(score * 1e4) / 1e4, failed: results.filter(r => !r.passed), report };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — INVOICE ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Generate a final invoice from the approved quote.
 * @param {Object} project
 * @param {{ changeOrders: Array, by: string }} opts
 * @returns {Object} invoice
 */
function generateInvoice(project, opts) {
  opts = opts || {};
  if (!project.quote) throw new Error('Cannot invoice without an approved quote');

  const changeTotal = (opts.changeOrders || []).reduce((s, co) => s + (co.amount || 0), 0);
  const adjustedTotal = project.quote.grandTotal + changeTotal;

  const invoice = {
    invoiceId:    `INV-${secureId(4).toUpperCase()}`,
    projectId:    project.projectId,
    clientId:     project.clientId,
    clientName:   project.clientName,
    basedOnQuote: project.quote.quoteId,
    changeOrders: opts.changeOrders || [],
    changeTotal:  Math.round(changeTotal * 100) / 100,
    grandTotal:   Math.round(adjustedTotal * 100) / 100,
    dueDate:      _dateStr(_addDays(new Date(), 30)),   /* net-30 */
    terms:        'NET 30 — 2% discount if paid within 10 days',
    issuedBy:     String(opts.by || AGI_ID),
    issuedAt:     _now(),
    status:       'OUTSTANDING',
  };

  project.invoice   = invoice;
  project.updatedAt = _now();
  _transition(project, PROJECT_STATE.INVOICED, opts.by || AGI_ID);
  return invoice;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — DESIGN ASSISTANT (φ-ratio design rules)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Evaluate a design proposal against φ-ratio design principles.
 * @param {{ items: Array<{ name, widthIn, heightIn, depthIn }>, roomWidthIn, roomHeightIn }} design
 * @returns {{ score: number, suggestions: string[] }}
 */
function evaluateDesign(design) {
  const suggestions = [];
  let   score       = 1.0;

  /* Rule 1: Tallest item should not exceed PHI_INV of room height */
  if (design.roomHeightIn && design.items) {
    const tallest = Math.max(...design.items.map(i => i.heightIn || 0));
    if (tallest > design.roomHeightIn * PHI_INV) {
      suggestions.push(`Tallest piece (${tallest}") exceeds φ⁻¹ × room height (${Math.round(design.roomHeightIn * PHI_INV)}"). Consider lower-profile pieces.`);
      score -= AMOR * 0.5;
    }
  }

  /* Rule 2: Widest item should not exceed PHI_INV of room width */
  if (design.roomWidthIn && design.items) {
    const widest = Math.max(...design.items.map(i => i.widthIn || 0));
    if (widest > design.roomWidthIn * PHI_INV) {
      suggestions.push(`Widest piece (${widest}") exceeds φ⁻¹ × room width (${Math.round(design.roomWidthIn * PHI_INV)}"). Consider narrower or modular pieces.`);
      score -= AMOR * 0.5;
    }
  }

  /* Rule 3: Check for φ-ratio harmony in paired pieces */
  if (design.items && design.items.length >= 2) {
    for (let i = 0; i < design.items.length - 1; i++) {
      const a = design.items[i].widthIn || 1;
      const b = design.items[i + 1].widthIn || 1;
      const ratio = a / b;
      if (Math.abs(ratio - PHI) > 0.2 && Math.abs(ratio - PHI_INV) > 0.2) {
        suggestions.push(`"${design.items[i].name}" and "${design.items[i + 1].name}" width ratio (${Math.round(ratio * 100) / 100}) deviates from φ. Consider scaling one to achieve φ-harmony.`);
        score -= AMOR * 0.2;
      }
    }
  }

  if (!suggestions.length) suggestions.push('Design passes φ-ratio harmony check. Proceed to procurement.');

  return { score: Math.max(0, Math.round(score * 1e4) / 1e4), suggestions };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — SOVEREIGN FURNITURE PLATFORM (owner-facing API)
// ═══════════════════════════════════════════════════════════════════════════════

class SovereignFurniturePlatform {
  constructor(opts) {
    opts          = opts || {};
    this._owner   = String(opts.owner || '');
    this._projects= new Map();   /* projectId → project */
    this._clients = new Map();   /* clientId → client */
    this._sinks   = [];
    this._beat    = 0;
    this._hbi     = null;
    if (opts.autoStart !== false) this.start();
    console.log(`[${AGI_ID}] ${AGI_FAMILY} online — NOVA Furniture Platform v${AGI_VERSION}`);
  }

  /* ── Client management ──────────────────────────────────────────────────── */

  registerClient(name, contactEmail, vertical) {
    const clientId = `CLI-${secureId(4).toUpperCase()}`;
    const client   = { clientId, name: String(name || ''), contactEmail: String(contactEmail || ''), vertical: vertical || VERTICAL.OFFICIUM.id, projects: [], createdAt: _now() };
    this._clients.set(clientId, client);
    this._emit('FURNITURE:CLIENT_REGISTERED', client);
    return client;
  }

  getClient(clientId) { return this._clients.get(clientId) || null; }

  /* ── Project lifecycle ──────────────────────────────────────────────────── */

  newProject(clientId, opts) {
    const client = this.getClient(clientId);
    if (!client) throw new Error(`Client not found: ${clientId}`);
    const project = createProject(Object.assign({ clientId, clientName: client.name, vertical: client.vertical }, opts || {}));
    this._projects.set(project.projectId, project);
    client.projects.push(project.projectId);
    this._emit('FURNITURE:PROJECT_CREATED', { projectId: project.projectId, clientId, vertical: project.vertical });
    return project;
  }

  getProject(projectId) { return this._projects.get(projectId) || null; }

  addItem(projectId, item) {
    const project = this._requireProject(projectId);
    return addLineItem(project, item);
  }

  quote(projectId, opts) {
    const project = this._requireProject(projectId);
    return generateQuote(project, opts);
  }

  approve(projectId, by) {
    const project = this._requireProject(projectId);
    _transition(project, PROJECT_STATE.APPROVED, by || 'CLIENT');
    this._emit('FURNITURE:PROJECT_APPROVED', { projectId, by });
    return project;
  }

  schedule(projectId, opts) {
    const project = this._requireProject(projectId);
    return scheduleInstall(project, opts);
  }

  startInstall(projectId, by) {
    const project = this._requireProject(projectId);
    _transition(project, PROJECT_STATE.INSTALLING, by || AGI_ID);
    this._emit('FURNITURE:INSTALL_STARTED', { projectId });
    return project;
  }

  inspect(projectId, passedIds, inspector) {
    const project = this._requireProject(projectId);
    return runInspection(project, passedIds, inspector);
  }

  invoice(projectId, opts) {
    const project = this._requireProject(projectId);
    return generateInvoice(project, opts);
  }

  planLayout(roomSpec) { return planRoom(roomSpec); }
  designCheck(design)  { return evaluateDesign(design); }

  /* ── Dashboard ──────────────────────────────────────────────────────────── */

  dashboard() {
    const projects = Array.from(this._projects.values());
    const byState  = {};
    for (const s of Object.values(PROJECT_STATE)) byState[s] = 0;
    for (const p of projects) { byState[p.state] = (byState[p.state] || 0) + 1; }

    const revenue = projects
      .filter(p => p.invoice)
      .reduce((s, p) => s + p.invoice.grandTotal, 0);

    const byVertical = {};
    for (const p of projects) byVertical[p.vertical] = (byVertical[p.vertical] || 0) + 1;

    return {
      agiId:       AGI_ID,
      version:     AGI_VERSION,
      family:      AGI_FAMILY,
      beat:        this._beat,
      totalProjects: projects.length,
      totalClients:  this._clients.size,
      totalRevenue:  Math.round(revenue * 100) / 100,
      byState,
      byVertical,
      active:      projects.filter(p => ![PROJECT_STATE.CLOSED, PROJECT_STATE.WARRANTY].includes(p.state)).length,
    };
  }

  addSink(fn)  { if (typeof fn === 'function') this._sinks.push(fn); return this; }
  start()      { this._hbi = setInterval(() => this._tick(), HEARTBEAT_MS); return this; }
  stop()       { clearInterval(this._hbi); this._hbi = null; return this; }

  _requireProject(id) {
    const p = this.getProject(id);
    if (!p) throw new Error(`Project not found: ${id}`);
    return p;
  }

  _tick() {
    this._beat++;
    /* Every 144 beats: scan for stale installing projects */
    if (this._beat % 144 === 0) {
      for (const p of this._projects.values()) {
        if (p.state === PROJECT_STATE.INSTALLING) {
          const ageDays = (_now() - p.updatedAt) / 86400000;
          if (ageDays > 2) this._emit('FURNITURE:INSTALL_STALE', { projectId: p.projectId, ageDays: Math.round(ageDays * 10) / 10 });
        }
      }
    }
    /* Every 233 beats: heartbeat telemetry */
    if (this._beat % 233 === 0) this._emit('FURNITURE:HEARTBEAT', this.dashboard());
  }

  _emit(type, payload) {
    const event = { type, payload, beat: this._beat, emittedAt: _now(), agiId: AGI_ID };
    for (const fn of this._sinks) try { fn(event); } catch (_) { /* non-fatal */ }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  /* Identity */
  AGI_ID, AGI_VERSION, AGI_FAMILY,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,

  /* Enumerations */
  VERTICAL, PROJECT_STATE, WORK_TYPE, ROOM_TYPE, LABOUR_RATE,
  DEFAULT_INSPECTION_ITEMS,

  /* Core functions */
  createProject, addLineItem, generateQuote,
  scheduleInstall, runInspection, generateInvoice,
  planRoom, planOpenOffice, planConferenceRoom,
  evaluateDesign,

  /* Platform */
  SovereignFurniturePlatform,
};
