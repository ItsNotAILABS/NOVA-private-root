// ─── NOVA / PARALLAX — Production Engine: Sovereign Pipeline Infrastructure ──
// Product Factory · Build Pipeline · Deploy Pipeline · Pipeline Math Layer
// 30 Products × 10 Categories × 12 Pipeline Stages × 6 Environments
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PHI, PHI_INV, PI, TAU } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type PipelineStage =
  | 'PLAN' | 'BUILD' | 'TEST' | 'SCAN' | 'CERTIFY' | 'PACKAGE'
  | 'STAGE' | 'CANARY' | 'DEPLOY' | 'VERIFY' | 'MONITOR' | 'COMPLETE';

export type ProductCategory =
  | 'SDK' | 'EXTENSION' | 'SERVICE' | 'CLI' | 'LIBRARY'
  | 'FIRMWARE' | 'PLATFORM' | 'AGENT' | 'PROTOCOL' | 'RESEARCH';

export type EnvironmentId =
  | 'DEV' | 'STAGING' | 'CANARY' | 'PRODUCTION' | 'SOVEREIGN' | 'EDGE';

export type PipelineStatus = 'PENDING' | 'IN_PROGRESS' | 'COMPLETE' | 'FAILED' | 'ROLLED_BACK';

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
  lif: number;  // membrane potential mV
}

export interface MicroChemical {
  dopamine: number;
  serotonin: number;
  acetylcholine: number;
}

export interface MiniBrain {
  regions: MicroRegion[];
  chemicals: MicroChemical;
  coherenceField: number;
}

export interface Product {
  id: string;
  name: string;
  category: ProductCategory;
  version: string;
  status: 'ACTIVE' | 'SUNSET' | 'BETA';
}

export interface Environment {
  id: EnvironmentId;
  name: string;
  tier: number;
}

export interface Artifact {
  id: string;
  type: 'WASM' | 'JS' | 'DOCKER' | 'BINARY';
  size: number;
  hash: string;
}

export interface Pipeline {
  pipelineId: string;
  productId: string;
  product: string;
  stage: PipelineStage;
  stageIndex: number;
  startedAt: number;
  updatedAt: number;
  artifacts: Artifact[];
  status: PipelineStatus;
}

export interface DeployRecord {
  deployId: string;
  productId: string;
  product: string;
  envId: EnvironmentId;
  env: string;
  deployedAt: number;
  status: 'DEPLOYED' | 'ROLLED_BACK';
  version: string;
}

export interface PipelineMetrics {
  totalBuilds: number;
  successRate: number;
  avgLatencyMs: number;
  totalDeploys: number;
  environments: number;
  products: number;
  phiThroughput: number;
  coherence: number;
  shannonEntropy: number;
}

export interface ProductionVitals {
  heart: MiniHeart;
  brain: MiniBrain;
  pipelines: number;
  builds: number;
  deploys: number;
  metrics: PipelineMetrics;
}

export interface ProductionEngineSummary {
  products: number;
  categories: number;
  stages: number;
  environments: number;
  pipelines: number;
  builds: number;
  deploys: number;
  vitals: ProductionVitals;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const HEARTBEAT_MS = 873;

const STAGES: PipelineStage[] = [
  'PLAN', 'BUILD', 'TEST', 'SCAN', 'CERTIFY', 'PACKAGE',
  'STAGE', 'CANARY', 'DEPLOY', 'VERIFY', 'MONITOR', 'COMPLETE'
];

const CATEGORIES: ProductCategory[] = [
  'SDK', 'EXTENSION', 'SERVICE', 'CLI', 'LIBRARY',
  'FIRMWARE', 'PLATFORM', 'AGENT', 'PROTOCOL', 'RESEARCH'
];

const ENVIRONMENTS: Environment[] = [
  { id: 'DEV',        name: 'Development',  tier: 1 },
  { id: 'STAGING',    name: 'Staging',      tier: 2 },
  { id: 'CANARY',     name: 'Canary',       tier: 3 },
  { id: 'PRODUCTION', name: 'Production',   tier: 4 },
  { id: 'SOVEREIGN',  name: 'Sovereign',    tier: 5 },
  { id: 'EDGE',       name: 'Edge',         tier: 6 },
];

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: MINI-HEART FACTORY
// ═══════════════════════════════════════════════════════════════════════════════

export function makeMiniHeart(): MiniHeart {
  return {
    beat: 0,
    phase: 0.0,
    bpm: 60000 / HEARTBEAT_MS,
    kuramotoOrder: 0.0,
    amplitude: 1.0,
  };
}

export function tickMiniHeart(h: MiniHeart): void {
  h.beat++;
  h.phase = (h.phase + PHI_INV) % TAU;
  h.kuramotoOrder = Math.abs(Math.cos(h.phase));
  h.amplitude = clamp(h.amplitude + (Math.random() - 0.5) * 0.01, 0.8, 1.0);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: MINI-BRAIN FACTORY
// ═══════════════════════════════════════════════════════════════════════════════

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
// SECTION 5: PRODUCT CATALOG
// ═══════════════════════════════════════════════════════════════════════════════

const PRODUCT_NAMES: string[] = [
  'NOVA Core SDK',            'NOVA Browser Extension',     'NOVA Terminal',
  'NOVA CLI',                 'NOVA Desktop App',           'NOVA Mobile App',
  'NOVA API Gateway',         'NOVA Auth Service',          'NOVA Data Pipeline',
  'NOVA ML Engine',           'NOVA Edge Runtime',          'NOVA IoT Firmware',
  'NOVA Mesh Protocol',       'NOVA Consensus Layer',       'NOVA Governance SDK',
  'NOVA Analytics Dashboard', 'NOVA Monitoring Agent',      'NOVA Security Scanner',
  'NOVA CI/CD Plugin',        'NOVA Container Runtime',     'NOVA Serverless Runtime',
  'NOVA Quantum Bridge',      'NOVA Neural Compiler',       'NOVA Knowledge Graph',
  'NOVA Digital Twin',        'NOVA Simulation Engine',     'NOVA Marketplace SDK',
  'NOVA Payment Gateway',     'NOVA Identity Service',      'NOVA Research Platform',
];

function buildCatalog(): Product[] {
  return PRODUCT_NAMES.map((name, i) => ({
    id:       `PROD-${String(i + 1).padStart(3, '0')}`,
    name,
    category: CATEGORIES[i % CATEGORIES.length],
    version:  '1.0.0',
    status:   'ACTIVE' as const,
  }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: PIPELINE MATH LAYER
// ═══════════════════════════════════════════════════════════════════════════════

/** Shannon entropy of stage distribution */
function shannonEntropy(stageCounts: number[]): number {
  const total = stageCounts.reduce((a, b) => a + b, 0);
  if (total === 0) return 0;
  let H = 0;
  for (const c of stageCounts) {
    if (c > 0) {
      const p = c / total;
      H -= p * Math.log2(p);
    }
  }
  return H;
}

/** φ-weighted pipeline throughput */
function phiThroughput(totalBuilds: number, successCount: number): number {
  return totalBuilds * PHI_INV + successCount * (1 - PHI_INV);
}

/** Pipeline velocity: stages per unit time, golden-scaled */
function pipelineVelocity(stageIndex: number, elapsedMs: number): number {
  if (elapsedMs <= 0) return 0;
  return (stageIndex / STAGES.length) * PHI * (1000 / elapsedMs);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: PRODUCTION ENGINE STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface ProductionState {
  heart: MiniHeart;
  brain: MiniBrain;
  products: Product[];
  pipelines: Map<string, Pipeline>;
  deployHistory: DeployRecord[];
  buildCount: number;
}

function makeProductionState(): ProductionState {
  return {
    heart: makeMiniHeart(),
    brain: makeMiniBrain(),
    products: buildCatalog(),
    pipelines: new Map(),
    deployHistory: [],
    buildCount: 0,
  };
}

const _state = makeProductionState();

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: ENGINE OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════

export function tickProductionEngine(): void {
  tickMiniHeart(_state.heart);
  tickMiniBrain(_state.brain);
}

export function startBuild(productId: string): Pipeline | { error: string } {
  const prod = _state.products.find(p => p.id === productId);
  if (!prod) return { error: `Product not found: ${productId}` };

  const plId = `PL-${Date.now().toString(36)}`;
  const now = Date.now();
  const pipeline: Pipeline = {
    pipelineId: plId,
    productId,
    product: prod.name,
    stage: 'PLAN',
    stageIndex: 0,
    startedAt: now,
    updatedAt: now,
    artifacts: [],
    status: 'IN_PROGRESS',
  };
  _state.pipelines.set(productId, pipeline);
  _state.buildCount++;
  return pipeline;
}

export function advancePipeline(productId: string): Pipeline | null {
  const p = _state.pipelines.get(productId);
  if (!p || p.status !== 'IN_PROGRESS') return null;
  if (p.stageIndex < STAGES.length - 1) {
    p.stageIndex++;
    p.stage = STAGES[p.stageIndex];
    p.updatedAt = Date.now();
    if (p.stageIndex === 5) {
      p.artifacts.push({
        id: `ART-${Date.now().toString(36)}`,
        type: 'WASM',
        size: Math.floor(Math.random() * 1000000) + 50000,
        hash: `sha256-${Math.random().toString(36).slice(2, 18)}`,
      });
    }
    if (p.stageIndex >= STAGES.length - 1) {
      p.status = 'COMPLETE';
    }
  }
  return p;
}

export function deployProduct(
  productId: string,
  envId: EnvironmentId
): DeployRecord | { error: string } {
  const prod = _state.products.find(p => p.id === productId);
  if (!prod) return { error: `Product not found: ${productId}` };
  const env = ENVIRONMENTS.find(e => e.id === envId);
  if (!env) return { error: `Environment not found: ${envId}` };

  const record: DeployRecord = {
    deployId: `DEP-${Date.now().toString(36)}`,
    productId,
    product: prod.name,
    envId,
    env: env.name,
    deployedAt: Date.now(),
    status: 'DEPLOYED',
    version: prod.version,
  };
  _state.deployHistory.push(record);
  return record;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: QUERY ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════════

export function getProductionMetrics(): PipelineMetrics {
  let successCount = 0;
  const latencies: number[] = [];
  const stageCounts = new Array(STAGES.length).fill(0);

  _state.pipelines.forEach(p => {
    stageCounts[p.stageIndex]++;
    if (p.status === 'COMPLETE') {
      successCount++;
      latencies.push(p.updatedAt - p.startedAt);
    }
  });

  const avgLatency = latencies.length > 0
    ? latencies.reduce((a, b) => a + b, 0) / latencies.length
    : 0;

  return {
    totalBuilds: _state.buildCount,
    successRate: _state.buildCount > 0 ? successCount / _state.buildCount : 0,
    avgLatencyMs: avgLatency,
    totalDeploys: _state.deployHistory.length,
    environments: ENVIRONMENTS.length,
    products: _state.products.length,
    phiThroughput: phiThroughput(_state.buildCount, successCount),
    coherence: _state.brain.coherenceField,
    shannonEntropy: shannonEntropy(stageCounts),
  };
}

export function getProductionVitals(): ProductionVitals {
  return {
    heart: { ..._state.heart },
    brain: {
      regions: _state.brain.regions.map(r => ({ ...r })),
      chemicals: { ..._state.brain.chemicals },
      coherenceField: _state.brain.coherenceField,
    },
    pipelines: _state.pipelines.size,
    builds: _state.buildCount,
    deploys: _state.deployHistory.length,
    metrics: getProductionMetrics(),
  };
}

export function getProductionSummary(): ProductionEngineSummary {
  return {
    products: _state.products.length,
    categories: CATEGORIES.length,
    stages: STAGES.length,
    environments: ENVIRONMENTS.length,
    pipelines: _state.pipelines.size,
    builds: _state.buildCount,
    deploys: _state.deployHistory.length,
    vitals: getProductionVitals(),
  };
}

export function getProductCatalog(): Product[] {
  return _state.products.map(p => ({ ...p }));
}

export function getEnvironments(): Environment[] {
  return [...ENVIRONMENTS];
}

export function getPipelineStages(): PipelineStage[] {
  return [...STAGES];
}
