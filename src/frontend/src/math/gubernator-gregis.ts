// ─── NOVA / PARALLAX — Gubernator Gregis: Sovereign Governance Infrastructure ─
// Enterprise Maps · Salesforce Answer Layer · 14 ASIs · 40 Scripts · 35 APIs
// Client / Governance Infrastructure · CRM Organism
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PHI, PHI_INV, TAU } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type ASIStatus = 'ACTIVE' | 'IDLE' | 'DEGRADED' | 'OFFLINE';

export type GovernanceAPICategory =
  | 'Client' | 'Governance' | 'Finance' | 'Analytics'
  | 'Security' | 'Integration' | 'Regulatory';

export type GovernanceScriptCategory =
  | 'Policy' | 'Compliance' | 'Audit' | 'ClientOps'
  | 'Data' | 'Risk' | 'Integration' | 'Finance'
  | 'Security' | 'Reporting';

export interface MiniHeart {
  beat: number;
  phase: number;
  bpm: number;
  kuramotoOrder: number;
  amplitude: number;
}

export interface MicroRegion {
  name: string;
  activation: number;
  lif: number;
}

export interface MiniBrain {
  regions: MicroRegion[];
  chemicals: { dopamine: number; serotonin: number; acetylcholine: number };
  coherenceField: number;
}

export interface ASIController {
  id: string;
  name: string;
  domain: string;
  status: ASIStatus;
  callCount: number;
  lastActive: number;
}

export interface GovernanceAPI {
  id: string;
  name: string;
  category: GovernanceAPICategory;
  method: 'GET' | 'POST' | 'PUT' | 'DELETE';
  callCount: number;
  avgLatencyMs: number;
}

export interface GovernanceScript {
  id: string;
  name: string;
  category: GovernanceScriptCategory;
  interval: number;
  runCount: number;
  lastRun: number;
  status: 'IDLE' | 'RUNNING';
}

export interface Client {
  id: string;
  name: string;
  tier: 'ENTERPRISE' | 'PROFESSIONAL' | 'STANDARD' | 'STARTER';
  industry: string;
  createdAt: number;
  status: 'ACTIVE' | 'CHURNED' | 'PROSPECT';
  health: number;
}

export interface EnterpriseLayer {
  name: string;
  components: string[];
}

export interface EnterpriseMap {
  asis: number;
  apis: number;
  scripts: number;
  clients: number;
  layers: EnterpriseLayer[];
  categories: {
    apis: Record<string, number>;
    scripts: Record<string, number>;
  };
}

export interface GovernanceDashboard {
  asiStatus: { id: string; name: string; status: ASIStatus }[];
  apiCount: number;
  scriptCount: number;
  clientCount: number;
  totalScriptRuns: number;
  totalAPICalls: number;
  coherence: number;
  health: number;
}

export interface GubernatorVitals {
  heart: MiniHeart;
  brain: MiniBrain;
  asis: number;
  apis: number;
  scripts: number;
  clients: number;
  dashboard: GovernanceDashboard;
}

export interface GubernatorSummary {
  asis: number;
  apis: number;
  scripts: number;
  clients: number;
  vitals: GubernatorVitals;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const HEARTBEAT_MS = 873;

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: MINI-HEART & MINI-BRAIN
// ═══════════════════════════════════════════════════════════════════════════════

export function makeMiniHeart(): MiniHeart {
  return { beat: 0, phase: 0.0, bpm: 60000 / HEARTBEAT_MS, kuramotoOrder: 0.0, amplitude: 1.0 };
}

export function tickMiniHeart(h: MiniHeart): void {
  h.beat++;
  h.phase = (h.phase + PHI_INV) % TAU;
  h.kuramotoOrder = Math.abs(Math.cos(h.phase));
  h.amplitude = clamp(h.amplitude + (Math.random() - 0.5) * 0.01, 0.8, 1.0);
}

export function makeMiniBrain(): MiniBrain {
  return {
    regions: [
      { name: 'Sensory',     activation: 0.0, lif: -70.0 },
      { name: 'Associative', activation: 0.0, lif: -70.0 },
      { name: 'Executive',   activation: 0.0, lif: -70.0 },
      { name: 'Motor',       activation: 0.0, lif: -70.0 },
      { name: 'Memory',      activation: 0.0, lif: -70.0 },
    ],
    chemicals: { dopamine: 0.5, serotonin: 0.5, acetylcholine: 0.5 },
    coherenceField: 0.0,
  };
}

export function tickMiniBrain(b: MiniBrain): void {
  for (const r of b.regions) {
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0;
    if (r.lif >= -55.0) {
      r.activation = Math.min(1.0, r.activation + 0.2);
      r.lif = -70.0;
    }
    r.activation *= 0.95;
  }
  b.chemicals.dopamine      = clamp(b.chemicals.dopamine + (Math.random() - 0.5) * 0.02, 0, 1);
  b.chemicals.serotonin     = clamp(b.chemicals.serotonin + (Math.random() - 0.5) * 0.02, 0, 1);
  b.chemicals.acetylcholine = clamp(b.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02, 0, 1);
  const sum = b.regions.reduce((s, r) => s + r.activation, 0);
  b.coherenceField = sum / b.regions.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: 14 ASI CONTROLLERS
// ═══════════════════════════════════════════════════════════════════════════════

function buildASIs(): ASIController[] {
  const defs: [string, string, string][] = [
    ['ASI-01', 'PRAEFECTUS',   'Executive Governance'],
    ['ASI-02', 'STRATEGICUS',  'Strategic Planning'],
    ['ASI-03', 'FISCALIS',     'Financial Oversight'],
    ['ASI-04', 'SECURITAS',    'Security & Compliance'],
    ['ASI-05', 'RELATOR',      'Client Relations'],
    ['ASI-06', 'ANALYTICUS',   'Data Analytics'],
    ['ASI-07', 'INTEGRATOR',   'System Integration'],
    ['ASI-08', 'PROVISOR',     'Resource Provisioning'],
    ['ASI-09', 'REGULARIS',    'Regulatory Compliance'],
    ['ASI-10', 'MERCATOR',     'Market Intelligence'],
    ['ASI-11', 'ARBITER',      'Dispute Resolution'],
    ['ASI-12', 'DOCUMENTOR',   'Document Management'],
    ['ASI-13', 'COMMUNICATOR', 'Communications Hub'],
    ['ASI-14', 'AUDITOR',      'Audit & Accountability'],
  ];
  return defs.map(([id, name, domain]) => ({
    id, name, domain, status: 'ACTIVE' as ASIStatus, callCount: 0, lastActive: Date.now(),
  }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: 35 GOVERNANCE APIS
// ═══════════════════════════════════════════════════════════════════════════════

function buildAPIs(): GovernanceAPI[] {
  const defs: [string, string, GovernanceAPICategory, 'GET'|'POST'|'PUT'|'DELETE'][] = [
    ['API-01', 'client.create',        'Client',      'POST'],
    ['API-02', 'client.read',          'Client',      'GET'],
    ['API-03', 'client.update',        'Client',      'PUT'],
    ['API-04', 'client.delete',        'Client',      'DELETE'],
    ['API-05', 'client.search',        'Client',      'GET'],
    ['API-06', 'governance.policies',  'Governance',  'GET'],
    ['API-07', 'governance.enforce',   'Governance',  'POST'],
    ['API-08', 'governance.audit',     'Governance',  'GET'],
    ['API-09', 'governance.compliance','Governance',  'GET'],
    ['API-10', 'governance.exceptions','Governance',  'POST'],
    ['API-11', 'finance.invoices',     'Finance',     'GET'],
    ['API-12', 'finance.payments',     'Finance',     'POST'],
    ['API-13', 'finance.revenue',      'Finance',     'GET'],
    ['API-14', 'finance.forecast',     'Finance',     'GET'],
    ['API-15', 'finance.budget',       'Finance',     'GET'],
    ['API-16', 'analytics.dashboard',  'Analytics',   'GET'],
    ['API-17', 'analytics.reports',    'Analytics',   'GET'],
    ['API-18', 'analytics.metrics',    'Analytics',   'GET'],
    ['API-19', 'analytics.trends',     'Analytics',   'GET'],
    ['API-20', 'analytics.predict',    'Analytics',   'POST'],
    ['API-21', 'security.scan',        'Security',    'POST'],
    ['API-22', 'security.incidents',   'Security',    'GET'],
    ['API-23', 'security.access',      'Security',    'GET'],
    ['API-24', 'security.certificates','Security',    'GET'],
    ['API-25', 'security.keys',        'Security',    'GET'],
    ['API-26', 'integration.salesforce','Integration','POST'],
    ['API-27', 'integration.erp',      'Integration', 'POST'],
    ['API-28', 'integration.crm',      'Integration', 'POST'],
    ['API-29', 'integration.webhook',  'Integration', 'POST'],
    ['API-30', 'integration.sync',     'Integration', 'POST'],
    ['API-31', 'regulatory.gdpr',      'Regulatory',  'GET'],
    ['API-32', 'regulatory.sox',       'Regulatory',  'GET'],
    ['API-33', 'regulatory.hipaa',     'Regulatory',  'GET'],
    ['API-34', 'regulatory.iso27001',  'Regulatory',  'GET'],
    ['API-35', 'regulatory.fedramp',   'Regulatory',  'GET'],
  ];
  return defs.map(([id, name, category, method]) => ({
    id, name, category, method, callCount: 0, avgLatencyMs: 0,
  }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: 40 GOVERNANCE SCRIPTS
// ═══════════════════════════════════════════════════════════════════════════════

function buildScripts(): GovernanceScript[] {
  const defs: [string, string, GovernanceScriptCategory, number][] = [
    ['GS-01', 'policy-enforcer',       'Policy',      10],
    ['GS-02', 'policy-validator',      'Policy',      15],
    ['GS-03', 'policy-propagator',     'Policy',      20],
    ['GS-04', 'policy-versioner',      'Policy',      50],
    ['GS-05', 'compliance-scanner',    'Compliance',  10],
    ['GS-06', 'compliance-reporter',   'Compliance',  30],
    ['GS-07', 'compliance-remediator', 'Compliance',  20],
    ['GS-08', 'compliance-certifier',  'Compliance',  60],
    ['GS-09', 'audit-logger',          'Audit',        3],
    ['GS-10', 'audit-analyzer',        'Audit',       15],
    ['GS-11', 'audit-reporter',        'Audit',       30],
    ['GS-12', 'audit-archiver',        'Audit',      100],
    ['GS-13', 'client-onboarding',     'ClientOps',    5],
    ['GS-14', 'client-health-check',   'ClientOps',    8],
    ['GS-15', 'client-engagement',     'ClientOps',   12],
    ['GS-16', 'client-renewal',        'ClientOps',   30],
    ['GS-17', 'client-escalation',     'ClientOps',    5],
    ['GS-18', 'data-classifier',       'Data',        10],
    ['GS-19', 'data-anonymizer',       'Data',        20],
    ['GS-20', 'data-retention',        'Data',        60],
    ['GS-21', 'data-lineage',          'Data',        30],
    ['GS-22', 'risk-assessor',         'Risk',        15],
    ['GS-23', 'risk-mitigator',        'Risk',        20],
    ['GS-24', 'risk-monitor',          'Risk',         8],
    ['GS-25', 'risk-reporter',         'Risk',        30],
    ['GS-26', 'salesforce-sync',       'Integration', 10],
    ['GS-27', 'erp-bridge',            'Integration', 15],
    ['GS-28', 'crm-updater',           'Integration', 10],
    ['GS-29', 'webhook-dispatcher',    'Integration',  3],
    ['GS-30', 'api-health-check',      'Integration',  5],
    ['GS-31', 'invoice-generator',     'Finance',     20],
    ['GS-32', 'payment-reconciler',    'Finance',     15],
    ['GS-33', 'revenue-calculator',    'Finance',     10],
    ['GS-34', 'forecast-modeler',      'Finance',     60],
    ['GS-35', 'access-reviewer',       'Security',    20],
    ['GS-36', 'cert-rotator',          'Security',   100],
    ['GS-37', 'anomaly-detector',      'Security',     5],
    ['GS-38', 'board-report-gen',      'Reporting',  200],
    ['GS-39', 'kpi-tracker',           'Reporting',   10],
    ['GS-40', 'dashboard-updater',     'Reporting',    5],
  ];
  return defs.map(([id, name, category, interval]) => ({
    id, name, category, interval, runCount: 0, lastRun: 0, status: 'IDLE' as const,
  }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: GUBERNATOR STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface GubernatorState {
  heart: MiniHeart;
  brain: MiniBrain;
  asis: ASIController[];
  apis: GovernanceAPI[];
  scripts: GovernanceScript[];
  clients: Client[];
}

function makeGubernatorState(): GubernatorState {
  return {
    heart: makeMiniHeart(),
    brain: makeMiniBrain(),
    asis: buildASIs(),
    apis: buildAPIs(),
    scripts: buildScripts(),
    clients: [],
  };
}

const _state = makeGubernatorState();

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: ENGINE OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════

export function tickGubernator(): void {
  tickMiniHeart(_state.heart);
  tickMiniBrain(_state.brain);
}

export function queryAPI(apiId: string): GovernanceAPI | { error: string } {
  const api = _state.apis.find(a => a.id === apiId);
  if (!api) return { error: `API not found: ${apiId}` };
  api.callCount++;
  api.avgLatencyMs = api.avgLatencyMs * 0.9 + (Math.random() * 50 * PHI_INV + 5) * 0.1;
  return { ...api };
}

export function runScript(scriptId: string): GovernanceScript | { error: string } {
  const s = _state.scripts.find(x => x.id === scriptId);
  if (!s) return { error: `Script not found: ${scriptId}` };
  s.runCount++;
  s.lastRun = _state.heart.beat;
  return { ...s };
}

export function addClient(
  name: string,
  tier: Client['tier'] = 'STANDARD',
  industry = 'Technology'
): Client {
  const client: Client = {
    id: `CLT-${Date.now().toString(36)}`,
    name,
    tier,
    industry,
    createdAt: Date.now(),
    status: 'ACTIVE',
    health: 1.0,
  };
  _state.clients.push(client);
  return client;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: QUERY ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════════

function groupByCategory<T extends { category: string }>(items: T[]): Record<string, number> {
  const groups: Record<string, number> = {};
  for (const item of items) {
    groups[item.category] = (groups[item.category] || 0) + 1;
  }
  return groups;
}

export function getEnterpriseMap(): EnterpriseMap {
  return {
    asis: _state.asis.length,
    apis: _state.apis.length,
    scripts: _state.scripts.length,
    clients: _state.clients.length,
    layers: [
      { name: 'Presentation', components: ['Dashboard', 'Reports', 'Alerts'] },
      { name: 'API Gateway',  components: _state.apis.slice(0, 5).map(a => a.name) },
      { name: 'ASI Fleet',    components: _state.asis.map(a => a.name) },
      { name: 'Script Engine', components: ['Policy', 'Compliance', 'Audit', 'Data', 'Risk'] },
      { name: 'Data Layer',   components: ['Client DB', 'Audit Log', 'Policy Store', 'Analytics'] },
    ],
    categories: {
      apis: groupByCategory(_state.apis),
      scripts: groupByCategory(_state.scripts),
    },
  };
}

export function getGovernanceDashboard(): GovernanceDashboard {
  const totalScriptRuns = _state.scripts.reduce((s, x) => s + x.runCount, 0);
  const totalAPICalls = _state.apis.reduce((s, x) => s + x.callCount, 0);
  return {
    asiStatus: _state.asis.map(a => ({ id: a.id, name: a.name, status: a.status })),
    apiCount: _state.apis.length,
    scriptCount: _state.scripts.length,
    clientCount: _state.clients.length,
    totalScriptRuns,
    totalAPICalls,
    coherence: _state.brain.coherenceField,
    health: clamp(
      (_state.brain.coherenceField * PHI + (totalScriptRuns > 0 ? 0.5 : 0)) / (PHI + 1),
      0, 1
    ),
  };
}

export function getGubernatorVitals(): GubernatorVitals {
  return {
    heart: { ..._state.heart },
    brain: {
      regions: _state.brain.regions.map(r => ({ ...r })),
      chemicals: { ..._state.brain.chemicals },
      coherenceField: _state.brain.coherenceField,
    },
    asis: _state.asis.length,
    apis: _state.apis.length,
    scripts: _state.scripts.length,
    clients: _state.clients.length,
    dashboard: getGovernanceDashboard(),
  };
}

export function getGubernatorSummary(): GubernatorSummary {
  return {
    asis: _state.asis.length,
    apis: _state.apis.length,
    scripts: _state.scripts.length,
    clients: _state.clients.length,
    vitals: getGubernatorVitals(),
  };
}

export function getASIs(): ASIController[] {
  return _state.asis.map(a => ({ ...a }));
}

export function getAPIs(): GovernanceAPI[] {
  return _state.apis.map(a => ({ ...a }));
}

export function getScripts(): GovernanceScript[] {
  return _state.scripts.map(s => ({ ...s }));
}

export function getClients(): Client[] {
  return _state.clients.map(c => ({ ...c }));
}
