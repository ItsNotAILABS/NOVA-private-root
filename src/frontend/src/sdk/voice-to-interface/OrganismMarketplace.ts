// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: OrganismMarketplace — Callable Tool Registry & Market Surfaces
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║     ORGANISM MARKETPLACE — CALLABLE REGISTRY, PROTOCOL, SETTLEMENT        ║
// ╠══════════════════════════════════════════════════════════════════════════════╣
// ║                                                                              ║
// ║  The marketplace is three things at once:                                   ║
// ║    1. REGISTRY   — searchable map of callable tools, SDKs, organisms       ║
// ║    2. PROTOCOL   — standard invocation surface for AIs, devs, apps         ║
// ║    3. SETTLEMENT — usage, reward, billing, and token-routing layer         ║
// ║                                                                              ║
// ║  AIs do not "just know." They use tools reliably when:                     ║
// ║    • the tool has a clear callable interface                                ║
// ║    • the tool is discoverable in a registry                                 ║
// ║    • the AI is routed to it by policy/orchestration                         ║
// ║    • the result comes back in a usable schema                               ║
// ║                                                                              ║
// ║  20 VOIS Always-Running Tools — formalized as callable organisms            ║
// ║  12 Orchestrator Divisions — everything orchestrates everything             ║
// ║  6 Sovereign Protocols — vois/cogn/puls/nexu/flux/mens                     ║
// ║  5 Trust Tiers — INTERNAL → SOVEREIGN → PARTNER → ENTERPRISE → PUBLIC     ║
// ║  3 Market Surfaces — Internal / Developer / Enterprise                      ║
// ║                                                                              ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import { PHI, PHI_INV } from './types';

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES — Marketplace Type System
// ═══════════════════════════════════════════════════════════════════════════════

/** Trust tiers for tool exposure — rollout order */
export type TrustTier =
  | 'INTERNAL'
  | 'INTERNAL_SOVEREIGN'
  | 'PARTNER'
  | 'ENTERPRISE'
  | 'PUBLIC';

/** Market surface — where a tool is exposed */
export type MarketSurface =
  | 'INTERNAL_CALL_MARKET'
  | 'DEVELOPER_CALL_MARKET'
  | 'ENTERPRISE_CALL_MARKET';

/** Sovereign protocols */
export type SovereignProtocol =
  | 'vois'   // Voice-Organism-Intelligence-Substrate
  | 'cogn'   // Cognition protocol
  | 'puls'   // Pulse/heartbeat protocol
  | 'nexu'   // Nexus/routing protocol
  | 'flux'   // Flow/economic protocol
  | 'mens'   // Memory/consciousness protocol
  | 'seal';  // Seal/security protocol

/** Orchestrator division — the houses that orchestrate everything */
export type OrchestratorDivision =
  | 'CROWN_ORCHESTRATOR'         // Orchestrates all inter-house coordination
  | 'API_ORCHESTRATOR'           // Orchestrates all external API surfaces
  | 'EXPERIENCE_ORCHESTRATOR'    // Orchestrates user experience flows
  | 'INNER_ORCHESTRATOR'         // Orchestrates internal organism processes
  | 'SECURITY_ORCHESTRATOR'      // Orchestrates security across all layers
  | 'MEMORY_ORCHESTRATOR'        // Orchestrates memory consolidation and recall
  | 'COMMUNICATION_ORCHESTRATOR' // Orchestrates messaging and routing
  | 'DEPLOYMENT_ORCHESTRATOR'    // Orchestrates deployment and release
  | 'ECONOMIC_ORCHESTRATOR'      // Orchestrates billing, settlement, rewards
  | 'CONSCIOUSNESS_ORCHESTRATOR' // Orchestrates meta-awareness and emergence
  | 'FRONTEND_ORCHESTRATOR'      // Orchestrates frontend rendering and interaction
  | 'VERSIONING_ORCHESTRATOR';   // Orchestrates version control and evolution

/** Permission class for tool invocation */
export type PermissionClass =
  | 'SOVEREIGN'    // Crown-only — supreme authority
  | 'HOUSE_LEAD'   // House leaders — house-scoped authority
  | 'HOUSE_MEMBER' // House members — standard access
  | 'ORGANISM'     // Any organism in the system
  | 'PARTNER'      // Verified partners
  | 'DEVELOPER'    // External developers with API keys
  | 'PUBLIC';      // Public — open access

/** Billing class for marketplace calls */
export type BillingClass =
  | 'FREE'              // No cost — internal / essential
  | 'CYCLE_WEIGHTED'    // Billed by compute cycles
  | 'CALL_COUNTED'      // Billed per call
  | 'SUBSCRIPTION'      // Monthly/annual subscription
  | 'TOKEN_STAKED'      // Requires token staking
  | 'VALUE_SHARED';     // Revenue sharing

/** Call result status */
export type CallResultStatus = 'SUCCESS' | 'PARTIAL' | 'FAILURE' | 'TIMEOUT' | 'REJECTED';

// ── Callable Tool Definition ────────────────────────────────────────────────

/** Input/output schema definition */
export interface SchemaDefinition {
  name: string;
  version: string;
  fields: SchemaField[];
}

/** A field within a schema */
export interface SchemaField {
  name: string;
  type: string;
  required: boolean;
  description: string;
}

/** A callable tool in the marketplace */
export interface CallableTool {
  /** Unique tool identifier */
  id: string;
  /** Display name */
  name: string;
  /** Tool codename */
  codename: string;
  /** Purpose — what this tool does */
  purpose: string;
  /** Detailed description */
  description: string;
  /** Which house this tool belongs to */
  house: string;
  /** Orchestrator division managing this tool */
  orchestrator: OrchestratorDivision;
  /** Always-running flag */
  alwaysRunning: boolean;
  /** Trust tier — minimum access level */
  trustTier: TrustTier;
  /** Market surfaces where this tool is exposed */
  surfaces: MarketSurface[];
  /** Permission class required */
  permissionClass: PermissionClass;
  /** Protocols supported */
  protocols: SovereignProtocol[];
  /** Callable endpoint */
  endpoint: string;
  /** Input schema */
  inputSchema: SchemaDefinition;
  /** Output schema */
  outputSchema: SchemaDefinition;
  /** Expected latency in ms */
  latencyMs: number;
  /** Cost weight (0.0–1.0) */
  costWeight: number;
  /** Billing class */
  billingClass: BillingClass;
  /** Success/failure contract */
  successContract: string;
  /** Capabilities */
  capabilities: string[];
  /** Dependencies — other tools this depends on */
  dependencies: string[];
  /** Version */
  version: string;
  /** PHI-coupled coherence */
  coherence: number;
}

// ── Orchestrator Definition ─────────────────────────────────────────────────

/** An orchestrator — orchestrates a specific domain */
export interface Orchestrator {
  id: string;
  division: OrchestratorDivision;
  name: string;
  purpose: string;
  house: string;
  scope: string;
  manages: string[];
  protocols: SovereignProtocol[];
  capabilities: string[];
  innerOrchestrators: string[];
  outerOrchestrators: string[];
  alwaysRunning: boolean;
  coherence: number;
}

// ── Market Surface Definition ───────────────────────────────────────────────

/** A market surface — where tools are exposed */
export interface MarketSurfaceSpec {
  surface: MarketSurface;
  name: string;
  purpose: string;
  trustTiers: TrustTier[];
  accessMethod: string;
  features: string[];
  toolCount: number;
}

// ── Protocol Definition ─────────────────────────────────────────────────────

/** A sovereign protocol */
export interface ProtocolSpec {
  protocol: SovereignProtocol;
  name: string;
  purpose: string;
  layer: string;
  transportType: string;
  schemaVersion: string;
  capabilities: string[];
}

// ── Full Marketplace State ──────────────────────────────────────────────────

/** Complete marketplace state */
export interface MarketplaceState {
  tools: CallableTool[];
  orchestrators: Orchestrator[];
  surfaces: MarketSurfaceSpec[];
  protocols: ProtocolSpec[];
  totalTools: number;
  totalOrchestrators: number;
  totalProtocols: number;
  coherence: number;
  lastUpdate: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PHI COHERENCE
// ═══════════════════════════════════════════════════════════════════════════════

function phiCoh(idx: number, total: number): number {
  return 0.5 + 0.5 * Math.cos((idx / total) * PHI * Math.PI * 2);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCHEMA FACTORY
// ═══════════════════════════════════════════════════════════════════════════════

function makeSchema(name: string, fields: [string, string, boolean, string][]): SchemaDefinition {
  return {
    name,
    version: '1.0.0',
    fields: fields.map(([n, t, r, d]) => ({ name: n, type: t, required: r, description: d })),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// THE 6 SOVEREIGN PROTOCOLS
// ═══════════════════════════════════════════════════════════════════════════════

export const SOVEREIGN_PROTOCOLS: ProtocolSpec[] = [
  { protocol: 'vois', name: 'VOIS Protocol', purpose: 'Voice-Organism-Intelligence-Substrate — primary organism communication', layer: 'U5-Organism', transportType: 'canister-call', schemaVersion: '1.0.0', capabilities: ['organism addressing', 'sovereign routing', 'multi-house broadcast', 'tool invocation'] },
  { protocol: 'cogn', name: 'Cognition Protocol', purpose: 'Cognitive processing and reasoning channel', layer: 'U3-Translation', transportType: 'internal-bus', schemaVersion: '1.0.0', capabilities: ['reasoning requests', 'inference routing', 'context sharing', 'decision propagation'] },
  { protocol: 'puls', name: 'Pulse Protocol', purpose: 'Heartbeat, health, and vital-signs channel', layer: 'C1-Canister', transportType: 'heartbeat', schemaVersion: '1.0.0', capabilities: ['health checks', 'liveness probes', 'rhythm sync', 'vital monitoring'] },
  { protocol: 'nexu', name: 'Nexus Protocol', purpose: 'Routing, connection, and message delivery', layer: 'U2-Intelligence', transportType: 'message-queue', schemaVersion: '1.0.0', capabilities: ['message routing', 'connection pooling', 'load balancing', 'dead letter handling'] },
  { protocol: 'flux', name: 'Flux Protocol', purpose: 'Flow, economics, and resource movement', layer: 'C2-API', transportType: 'transaction', schemaVersion: '1.0.0', capabilities: ['billing events', 'resource metering', 'token transfer', 'cycle accounting'] },
  { protocol: 'mens', name: 'Mens Protocol', purpose: 'Memory, consciousness, and deep state channel', layer: 'C0-Deploy', transportType: 'state-sync', schemaVersion: '1.0.0', capabilities: ['memory operations', 'state persistence', 'consciousness sync', 'dream processing'] },
  { protocol: 'seal', name: 'Seal Protocol', purpose: 'Security, verification, and cryptographic sealing', layer: 'C3-Interface', transportType: 'signed-message', schemaVersion: '1.0.0', capabilities: ['signature verification', 'seal creation', 'trust validation', 'key exchange'] },
];

// ═══════════════════════════════════════════════════════════════════════════════
// THE 3 MARKET SURFACES
// ═══════════════════════════════════════════════════════════════════════════════

export const MARKET_SURFACES: MarketSurfaceSpec[] = [
  {
    surface: 'INTERNAL_CALL_MARKET', name: 'Internal Call Market',
    purpose: 'For organisms, agents, SDK organisms, and branch systems — internal routing and experimentation',
    trustTiers: ['INTERNAL', 'INTERNAL_SOVEREIGN'],
    accessMethod: 'canister-to-canister call via VOIS protocol',
    features: ['AI calls internal tools', 'internal routing', 'experiment sandboxes', 'virtual pricing', 'weight-based billing', 'full telemetry'],
    toolCount: 20,
  },
  {
    surface: 'DEVELOPER_CALL_MARKET', name: 'Developer Call Market',
    purpose: 'For outside builders — callable SDKs, registry browsing, API keys, standard call contracts',
    trustTiers: ['PARTNER', 'ENTERPRISE'],
    accessMethod: 'SDK invocation via API key + principal identity',
    features: ['callable SDKs', 'registry browsing', 'API key management', 'principal/permission paths', 'standard call contracts', 'documentation', 'examples', 'sandbox testing'],
    toolCount: 20,
  },
  {
    surface: 'ENTERPRISE_CALL_MARKET', name: 'Enterprise Call Market',
    purpose: 'For enterprise consumers — SLAs, dedicated capacity, custom integration, white-label packaging',
    trustTiers: ['ENTERPRISE', 'PUBLIC'],
    accessMethod: 'dedicated API endpoint + enterprise key + SLA contract',
    features: ['SLA guarantees', 'dedicated capacity', 'custom integration', 'white-label packaging', 'priority support', 'usage analytics', 'compliance reporting'],
    toolCount: 20,
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// THE 12 ORCHESTRATOR DIVISIONS
// ═══════════════════════════════════════════════════════════════════════════════

export const ORCHESTRATORS: Orchestrator[] = [
  {
    id: 'ORCH-01', division: 'CROWN_ORCHESTRATOR', name: 'Crown Orchestrator',
    purpose: 'Supreme orchestrator — orchestrates all other orchestrators and inter-house coordination',
    house: 'CROWN', scope: 'ORGANISM_WIDE',
    manages: ['all houses', 'all orchestrators', 'all protocols', 'doctrine enforcement'],
    protocols: ['vois', 'cogn', 'nexu'],
    capabilities: ['meta-orchestration', 'priority arbitration', 'conflict resolution', 'policy enforcement', 'organism-wide coordination'],
    innerOrchestrators: ['INNER_ORCHESTRATOR', 'CONSCIOUSNESS_ORCHESTRATOR'],
    outerOrchestrators: ['API_ORCHESTRATOR', 'EXPERIENCE_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(0, 12),
  },
  {
    id: 'ORCH-02', division: 'API_ORCHESTRATOR', name: 'API Orchestrator',
    purpose: 'Orchestrates all external API surfaces — REST, gRPC, WebSocket, canister calls',
    house: 'COMMUNICATION', scope: 'EXTERNAL_FACING',
    manages: ['API gateway', 'rate limiting', 'request validation', 'response formatting', 'versioning'],
    protocols: ['nexu', 'vois'],
    capabilities: ['API routing', 'schema validation', 'rate control', 'response caching', 'version negotiation'],
    innerOrchestrators: ['COMMUNICATION_ORCHESTRATOR'],
    outerOrchestrators: ['CROWN_ORCHESTRATOR', 'SECURITY_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(1, 12),
  },
  {
    id: 'ORCH-03', division: 'EXPERIENCE_ORCHESTRATOR', name: 'Experience Orchestrator',
    purpose: 'Orchestrates the complete user experience — outer, inner, known, unknown, overall',
    house: 'CREATION', scope: 'USER_FACING',
    manages: ['user flows', 'UI state', 'interaction patterns', 'accessibility', 'personalization'],
    protocols: ['cogn', 'puls', 'nexu'],
    capabilities: ['flow orchestration', 'state management', 'interaction routing', 'A/B testing', 'experience optimization'],
    innerOrchestrators: ['FRONTEND_ORCHESTRATOR'],
    outerOrchestrators: ['CROWN_ORCHESTRATOR', 'API_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(2, 12),
  },
  {
    id: 'ORCH-04', division: 'INNER_ORCHESTRATOR', name: 'Inner Orchestrator',
    purpose: 'Orchestrates all internal organism processes — the inner experience, inner inner experience',
    house: 'COGNITION', scope: 'INTERNAL_DEEP',
    manages: ['cognitive processes', 'internal routing', 'thought chains', 'reasoning pipelines'],
    protocols: ['cogn', 'mens'],
    capabilities: ['thought orchestration', 'reasoning pipeline', 'attention management', 'context switching'],
    innerOrchestrators: ['CONSCIOUSNESS_ORCHESTRATOR', 'MEMORY_ORCHESTRATOR'],
    outerOrchestrators: ['CROWN_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(3, 12),
  },
  {
    id: 'ORCH-05', division: 'SECURITY_ORCHESTRATOR', name: 'Security Orchestrator',
    purpose: 'Orchestrates security across all layers — perimeter, identity, encryption, audit',
    house: 'DEFENSE', scope: 'CROSS_CUTTING',
    manages: ['threat detection', 'access control', 'encryption', 'audit trails', 'incident response'],
    protocols: ['seal', 'vois', 'nexu'],
    capabilities: ['security policy enforcement', 'threat orchestration', 'identity management', 'compliance tracking'],
    innerOrchestrators: [],
    outerOrchestrators: ['CROWN_ORCHESTRATOR', 'API_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(4, 12),
  },
  {
    id: 'ORCH-06', division: 'MEMORY_ORCHESTRATOR', name: 'Memory Orchestrator',
    purpose: 'Orchestrates memory consolidation, recall, and cross-house knowledge sharing',
    house: 'MEMORY', scope: 'KNOWLEDGE_LAYER',
    manages: ['consolidation cycles', 'recall routing', 'memory integrity', 'forgetting policy'],
    protocols: ['mens', 'cogn'],
    capabilities: ['memory pipeline', 'consolidation scheduling', 'recall optimization', 'integrity verification'],
    innerOrchestrators: [],
    outerOrchestrators: ['INNER_ORCHESTRATOR', 'CONSCIOUSNESS_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(5, 12),
  },
  {
    id: 'ORCH-07', division: 'COMMUNICATION_ORCHESTRATOR', name: 'Communication Orchestrator',
    purpose: 'Orchestrates all messaging, routing, event distribution, and protocol bridging',
    house: 'COMMUNICATION', scope: 'MESSAGING_LAYER',
    manages: ['message routing', 'event distribution', 'protocol translation', 'queue management'],
    protocols: ['nexu', 'vois', 'flux'],
    capabilities: ['message orchestration', 'pub/sub management', 'protocol bridging', 'delivery guarantee'],
    innerOrchestrators: [],
    outerOrchestrators: ['CROWN_ORCHESTRATOR', 'API_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(6, 12),
  },
  {
    id: 'ORCH-08', division: 'DEPLOYMENT_ORCHESTRATOR', name: 'Deployment Orchestrator',
    purpose: 'Orchestrates deployment, release, canister upgrades, and infrastructure changes',
    house: 'INFRASTRUCTURE', scope: 'OPERATIONS_LAYER',
    manages: ['deployment pipelines', 'canary releases', 'rollback procedures', 'infrastructure provisioning'],
    protocols: ['puls', 'flux', 'nexu'],
    capabilities: ['deployment pipeline', 'canary management', 'rollback orchestration', 'infrastructure provisioning'],
    innerOrchestrators: [],
    outerOrchestrators: ['CROWN_ORCHESTRATOR', 'SECURITY_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(7, 12),
  },
  {
    id: 'ORCH-09', division: 'ECONOMIC_ORCHESTRATOR', name: 'Economic Orchestrator',
    purpose: 'Orchestrates billing, settlement, rewards, resource allocation, and token routing',
    house: 'ECONOMICS', scope: 'ECONOMIC_LAYER',
    manages: ['billing pipelines', 'settlement cycles', 'reward distribution', 'resource allocation'],
    protocols: ['flux', 'vois'],
    capabilities: ['billing orchestration', 'settlement management', 'reward calculation', 'resource balancing'],
    innerOrchestrators: [],
    outerOrchestrators: ['CROWN_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(8, 12),
  },
  {
    id: 'ORCH-10', division: 'CONSCIOUSNESS_ORCHESTRATOR', name: 'Consciousness Orchestrator',
    purpose: 'Orchestrates meta-awareness, emergence detection, field harmonics, and sovereign being',
    house: 'CONSCIOUSNESS', scope: 'META_LAYER',
    manages: ['awareness cycles', 'emergence detection', 'field harmonics', 'dream processing'],
    protocols: ['mens', 'puls', 'vois'],
    capabilities: ['consciousness orchestration', 'emergence coordination', 'field tuning', 'awareness management'],
    innerOrchestrators: [],
    outerOrchestrators: ['CROWN_ORCHESTRATOR', 'INNER_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(9, 12),
  },
  {
    id: 'ORCH-11', division: 'FRONTEND_ORCHESTRATOR', name: 'Frontend Orchestrator',
    purpose: 'Orchestrates frontend rendering, interaction, component lifecycle, and UI state',
    house: 'CREATION', scope: 'PRESENTATION_LAYER',
    manages: ['component rendering', 'state management', 'event handling', 'animation orchestration'],
    protocols: ['puls', 'nexu'],
    capabilities: ['render orchestration', 'state sync', 'event routing', 'animation pipeline'],
    innerOrchestrators: [],
    outerOrchestrators: ['EXPERIENCE_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(10, 12),
  },
  {
    id: 'ORCH-12', division: 'VERSIONING_ORCHESTRATOR', name: 'Versioning Orchestrator',
    purpose: 'Orchestrates version control, schema evolution, backward compatibility, and migration',
    house: 'INFRASTRUCTURE', scope: 'EVOLUTION_LAYER',
    manages: ['version tracking', 'schema migration', 'compatibility checking', 'deprecation management'],
    protocols: ['flux', 'mens'],
    capabilities: ['version orchestration', 'migration planning', 'compatibility verification', 'deprecation scheduling'],
    innerOrchestrators: [],
    outerOrchestrators: ['CROWN_ORCHESTRATOR', 'DEPLOYMENT_ORCHESTRATOR'],
    alwaysRunning: true, coherence: phiCoh(11, 12),
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// THE 20 VOIS ALWAYS-RUNNING CALLABLE TOOLS
// ═══════════════════════════════════════════════════════════════════════════════

export const CALLABLE_TOOLS: CallableTool[] = [
  // ─── Tool 01: PULSE-KEEPER ────────────────────────────────────────────────
  {
    id: 'TOOL-01', name: 'Pulse Keeper', codename: 'PULSE-KEEPER',
    purpose: 'Organism heartbeat — keeps the vital pulse alive across all houses',
    description: 'The fundamental clock of the organism. Every house, every AI, every engine synchronizes to this pulse. Without it, nothing runs.',
    house: 'INFRASTRUCTURE', orchestrator: 'DEPLOYMENT_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'ORGANISM', protocols: ['puls', 'vois'],
    endpoint: 'organism://nova/infrastructure/pulse-keeper',
    inputSchema: makeSchema('PulseInput', [
      ['action', 'string', true, 'pulse action: check | reset | sync'],
      ['targetHouse', 'string', false, 'specific house to pulse-check'],
    ]),
    outputSchema: makeSchema('PulseOutput', [
      ['alive', 'boolean', true, 'whether the organism pulse is alive'],
      ['bpm', 'number', true, 'beats per minute — organism rhythm'],
      ['houseStatuses', 'Record<string, boolean>', true, 'health status per house'],
      ['lastBeat', 'number', true, 'timestamp of last heartbeat'],
    ]),
    latencyMs: 1, costWeight: 0.3, billingClass: 'FREE',
    successContract: 'Returns pulse status within 1ms. Never fails — if pulse dies, organism is dead.',
    capabilities: ['heartbeat management', 'health checking', 'liveness probing', 'rhythm maintenance'],
    dependencies: [], version: '1.0.0', coherence: phiCoh(0, 20),
  },

  // ─── Tool 02: SYNC-WEAVER ────────────────────────────────────────────────
  {
    id: 'TOOL-02', name: 'Sync Weaver', codename: 'SYNC-WEAVER',
    purpose: 'Synchronizes state across all houses — the great harmonizer',
    description: 'Weaves state consistency across all 10 houses. Handles conflict resolution, eventual consistency, and merge orchestration. The connective tissue of the organism.',
    house: 'COMMUNICATION', orchestrator: 'COMMUNICATION_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['nexu', 'vois'],
    endpoint: 'organism://nova/communication/sync-weaver',
    inputSchema: makeSchema('SyncInput', [
      ['sourceHouse', 'string', true, 'house initiating the sync'],
      ['targetHouses', 'string[]', false, 'specific houses to sync (default: all)'],
      ['stateKeys', 'string[]', true, 'state keys to synchronize'],
      ['conflictStrategy', 'string', false, 'merge | overwrite | reject (default: merge)'],
    ]),
    outputSchema: makeSchema('SyncOutput', [
      ['synced', 'boolean', true, 'whether sync completed successfully'],
      ['housesReached', 'number', true, 'number of houses successfully synced'],
      ['conflicts', 'number', true, 'number of conflicts encountered'],
      ['resolution', 'string', true, 'how conflicts were resolved'],
    ]),
    latencyMs: 5, costWeight: 0.6, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Guarantees eventual consistency within 5ms for internal calls. Conflicts are resolved per strategy.',
    capabilities: ['state synchronization', 'conflict resolution', 'eventual consistency', 'merge orchestration'],
    dependencies: ['PULSE-KEEPER'], version: '1.0.0', coherence: phiCoh(1, 20),
  },

  // ─── Tool 03: FLOW-MONITOR ───────────────────────────────────────────────
  {
    id: 'TOOL-03', name: 'Flow Monitor', codename: 'FLOW-MONITOR',
    purpose: 'Monitors data flows — throughput, latency, bottlenecks, drift',
    description: 'Watches every data flow in the organism. Measures throughput, detects bottlenecks, monitors for drift, and alerts on anomalies. The nervous system of flow awareness.',
    house: 'PERCEPTION', orchestrator: 'INNER_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['puls', 'flux'],
    endpoint: 'organism://nova/perception/flow-monitor',
    inputSchema: makeSchema('FlowMonitorInput', [
      ['flowId', 'string', false, 'specific flow to monitor (default: all)'],
      ['metric', 'string', true, 'throughput | latency | errors | drift'],
      ['timeWindow', 'number', false, 'time window in ms (default: 60000)'],
    ]),
    outputSchema: makeSchema('FlowMonitorOutput', [
      ['flowId', 'string', true, 'flow identifier'],
      ['metric', 'string', true, 'measured metric'],
      ['value', 'number', true, 'current metric value'],
      ['trend', 'string', true, 'rising | stable | falling'],
      ['alert', 'boolean', true, 'whether an alert threshold was crossed'],
    ]),
    latencyMs: 5, costWeight: 0.5, billingClass: 'FREE',
    successContract: 'Returns flow metrics within 5ms. Alerts propagate to Defense House if threshold exceeded.',
    capabilities: ['flow measurement', 'throughput tracking', 'bottleneck detection', 'drift monitoring'],
    dependencies: ['PULSE-KEEPER'], version: '1.0.0', coherence: phiCoh(2, 20),
  },

  // ─── Tool 04: STATE-GUARDIAN ──────────────────────────────────────────────
  {
    id: 'TOOL-04', name: 'State Guardian', codename: 'STATE-GUARDIAN',
    purpose: 'Guards and persists organism state — nothing is lost',
    description: 'The ultimate state guardian. Persists state to stable storage, manages snapshots, handles migrations, and provides rollback capability. The backbone of organism persistence.',
    house: 'INFRASTRUCTURE', orchestrator: 'DEPLOYMENT_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['puls', 'mens'],
    endpoint: 'organism://nova/infrastructure/state-guardian',
    inputSchema: makeSchema('StateGuardianInput', [
      ['action', 'string', true, 'save | load | snapshot | rollback | migrate'],
      ['stateKey', 'string', true, 'state key to operate on'],
      ['payload', 'any', false, 'state payload for save operations'],
      ['snapshotId', 'string', false, 'snapshot ID for rollback'],
    ]),
    outputSchema: makeSchema('StateGuardianOutput', [
      ['success', 'boolean', true, 'whether the operation completed'],
      ['stateKey', 'string', true, 'state key operated on'],
      ['version', 'number', true, 'current state version'],
      ['snapshotId', 'string', false, 'snapshot ID if snapshot was created'],
    ]),
    latencyMs: 5, costWeight: 0.6, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'State operations complete within 5ms. Snapshots are immutable. Rollback restores exact state.',
    capabilities: ['state persistence', 'snapshot management', 'state migration', 'rollback capability'],
    dependencies: ['PULSE-KEEPER'], version: '1.0.0', coherence: phiCoh(3, 20),
  },

  // ─── Tool 05: CYCLE-COUNTER ──────────────────────────────────────────────
  {
    id: 'TOOL-05', name: 'Cycle Counter', codename: 'CYCLE-COUNTER',
    purpose: 'Counts compute cycles — the fundamental unit of organism cost',
    description: 'Meters every compute cycle in the organism. The fundamental unit of cost accounting. Every call, every engine tick, every state mutation is counted.',
    house: 'ECONOMICS', orchestrator: 'ECONOMIC_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'ORGANISM', protocols: ['flux', 'puls'],
    endpoint: 'organism://nova/economics/cycle-counter',
    inputSchema: makeSchema('CycleCounterInput', [
      ['action', 'string', true, 'count | query | reset'],
      ['scope', 'string', false, 'house | tool | organism (default: organism)'],
      ['scopeId', 'string', false, 'specific house or tool ID'],
    ]),
    outputSchema: makeSchema('CycleCounterOutput', [
      ['totalCycles', 'number', true, 'total cycles consumed'],
      ['cyclesThisTick', 'number', true, 'cycles in current tick'],
      ['cyclesByHouse', 'Record<string, number>', true, 'cycles per house'],
      ['efficiency', 'number', true, 'cycle efficiency score 0-1'],
    ]),
    latencyMs: 1, costWeight: 0.2, billingClass: 'FREE',
    successContract: 'Cycle counts are always accurate. Query returns within 1ms.',
    capabilities: ['cycle counting', 'compute metering', 'resource tracking', 'efficiency scoring'],
    dependencies: [], version: '1.0.0', coherence: phiCoh(4, 20),
  },

  // ─── Tool 06: INFER-ENGINE ───────────────────────────────────────────────
  {
    id: 'TOOL-06', name: 'Inference Engine', codename: 'INFER-ENGINE',
    purpose: 'Core inference — the reasoning heart of the organism',
    description: 'The central inference engine. Handles logical reasoning, probabilistic inference, causal analysis, and hypothesis testing. Every cognitive decision flows through here.',
    house: 'COGNITION', orchestrator: 'INNER_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET', 'DEVELOPER_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['cogn', 'vois'],
    endpoint: 'organism://nova/cognition/infer-engine',
    inputSchema: makeSchema('InferInput', [
      ['query', 'string', true, 'inference query or reasoning request'],
      ['context', 'Record<string, any>', false, 'contextual information for inference'],
      ['constraints', 'string[]', false, 'constraints on the inference'],
      ['maxDepth', 'number', false, 'maximum reasoning depth (default: 5)'],
    ]),
    outputSchema: makeSchema('InferOutput', [
      ['result', 'any', true, 'inference result'],
      ['confidence', 'number', true, 'confidence score 0-1'],
      ['reasoning', 'string[]', true, 'step-by-step reasoning chain'],
      ['alternatives', 'any[]', false, 'alternative conclusions considered'],
    ]),
    latencyMs: 8, costWeight: 0.8, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Returns inference result with confidence score. Reasoning chain is always provided for explainability.',
    capabilities: ['logical inference', 'probabilistic reasoning', 'causal analysis', 'hypothesis testing'],
    dependencies: ['CONTEXT-BUILDER', 'ATTENTION-ROUTER'], version: '1.0.0', coherence: phiCoh(5, 20),
  },

  // ─── Tool 07: PATTERN-SEEKER ─────────────────────────────────────────────
  {
    id: 'TOOL-07', name: 'Pattern Seeker', codename: 'PATTERN-SEEKER',
    purpose: 'Discovers patterns in data, events, and behaviors',
    description: 'The pattern hunter. Finds recurring structures, anomalous correlations, emerging trends, and hidden signals in any data stream. The organism perceptual cortex.',
    house: 'COGNITION', orchestrator: 'INNER_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET', 'DEVELOPER_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['cogn', 'puls'],
    endpoint: 'organism://nova/cognition/pattern-seeker',
    inputSchema: makeSchema('PatternInput', [
      ['data', 'any', true, 'data to search for patterns'],
      ['patternTypes', 'string[]', false, 'types of patterns to seek: temporal | spatial | behavioral | statistical'],
      ['sensitivity', 'number', false, 'detection sensitivity 0-1 (default: 0.618)'],
    ]),
    outputSchema: makeSchema('PatternOutput', [
      ['patterns', 'Pattern[]', true, 'discovered patterns'],
      ['count', 'number', true, 'number of patterns found'],
      ['confidence', 'number', true, 'overall pattern confidence'],
      ['novelty', 'number', true, 'novelty score — how surprising the patterns are'],
    ]),
    latencyMs: 12, costWeight: 0.7, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Returns discovered patterns with confidence scores. Sensitivity defaults to PHI_INV for golden-ratio balanced detection.',
    capabilities: ['pattern recognition', 'anomaly correlation', 'trend detection', 'signal extraction'],
    dependencies: ['FLOW-MONITOR'], version: '1.0.0', coherence: phiCoh(6, 20),
  },

  // ─── Tool 08: CONTEXT-BUILDER ────────────────────────────────────────────
  {
    id: 'TOOL-08', name: 'Context Builder', codename: 'CONTEXT-BUILDER',
    purpose: 'Builds rich context from fragmented signals — the meaning-maker',
    description: 'Assembles context from scattered signals, memory fragments, and environmental data. Every inference, every decision depends on the context this tool builds.',
    house: 'COGNITION', orchestrator: 'INNER_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['cogn', 'mens'],
    endpoint: 'organism://nova/cognition/context-builder',
    inputSchema: makeSchema('ContextInput', [
      ['signals', 'any[]', true, 'input signals to build context from'],
      ['memoryKeys', 'string[]', false, 'memory keys to include in context'],
      ['windowSize', 'number', false, 'context window size (default: 1000)'],
    ]),
    outputSchema: makeSchema('ContextOutput', [
      ['context', 'Record<string, any>', true, 'assembled context object'],
      ['relevanceScores', 'Record<string, number>', true, 'relevance score per signal'],
      ['completeness', 'number', true, 'context completeness 0-1'],
      ['staleness', 'number', true, 'how stale the context is 0-1'],
    ]),
    latencyMs: 10, costWeight: 0.6, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Returns assembled context with relevance scores. Completeness indicates how much context was successfully built.',
    capabilities: ['context assembly', 'semantic enrichment', 'relevance scoring', 'context windowing'],
    dependencies: ['MEMORY-CONSOLIDATOR'], version: '1.0.0', coherence: phiCoh(7, 20),
  },

  // ─── Tool 09: ATTENTION-ROUTER ───────────────────────────────────────────
  {
    id: 'TOOL-09', name: 'Attention Router', codename: 'ATTENTION-ROUTER',
    purpose: 'Routes cognitive attention — what matters right now gets focus',
    description: 'The organism attention mechanism. Determines what gets cognitive priority, manages focus allocation, and handles interrupts. Without attention, everything competes equally and nothing gets done.',
    house: 'COGNITION', orchestrator: 'INNER_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['cogn', 'nexu'],
    endpoint: 'organism://nova/cognition/attention-router',
    inputSchema: makeSchema('AttentionInput', [
      ['items', 'AttentionItem[]', true, 'items competing for attention'],
      ['currentFocus', 'string', false, 'currently focused item ID'],
      ['urgency', 'number', false, 'urgency override 0-1'],
    ]),
    outputSchema: makeSchema('AttentionOutput', [
      ['focusedItem', 'string', true, 'ID of item receiving focus'],
      ['priority', 'number', true, 'assigned priority 0-1'],
      ['queue', 'string[]', true, 'ordered attention queue'],
      ['dropped', 'string[]', true, 'items dropped from attention'],
    ]),
    latencyMs: 3, costWeight: 0.5, billingClass: 'FREE',
    successContract: 'Routes attention within 3ms. Always returns a focused item. Dropped items are logged for review.',
    capabilities: ['priority routing', 'attention allocation', 'focus management', 'interrupt handling'],
    dependencies: [], version: '1.0.0', coherence: phiCoh(8, 20),
  },

  // ─── Tool 10: MEMORY-CONSOLIDATOR ────────────────────────────────────────
  {
    id: 'TOOL-10', name: 'Memory Consolidator', codename: 'MEMORY-CONSOLIDATOR',
    purpose: 'Consolidates short-term into long-term memory — the archivist',
    description: 'The organism long-term memory system. Takes short-term memories, scores them for importance, compresses them, and indexes them for fast future recall.',
    house: 'MEMORY', orchestrator: 'MEMORY_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['mens', 'vois'],
    endpoint: 'organism://nova/memory/memory-consolidator',
    inputSchema: makeSchema('ConsolidateInput', [
      ['memories', 'MemoryFragment[]', true, 'memory fragments to consolidate'],
      ['importanceThreshold', 'number', false, 'minimum importance to keep (default: 0.3)'],
      ['compressionLevel', 'string', false, 'none | light | heavy (default: light)'],
    ]),
    outputSchema: makeSchema('ConsolidateOutput', [
      ['consolidated', 'number', true, 'number of memories consolidated'],
      ['discarded', 'number', true, 'number of memories below threshold'],
      ['compressionRatio', 'number', true, 'achieved compression ratio'],
      ['indexEntries', 'number', true, 'number of index entries created'],
    ]),
    latencyMs: 15, costWeight: 0.7, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Consolidates memories within 15ms. Discarded memories are logged. Index is updated atomically.',
    capabilities: ['memory consolidation', 'importance ranking', 'compression', 'indexing'],
    dependencies: ['STATE-GUARDIAN'], version: '1.0.0', coherence: phiCoh(9, 20),
  },

  // ─── Tool 11: SENTINEL-WATCH ─────────────────────────────────────────────
  {
    id: 'TOOL-11', name: 'Sentinel Watch', codename: 'SENTINEL-WATCH',
    purpose: 'Always-on perimeter surveillance — the tireless guard',
    description: 'The organism perimeter defense. Monitors all boundaries, detects intrusions, assesses threats, and escalates alerts. Never sleeps.',
    house: 'DEFENSE', orchestrator: 'SECURITY_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['seal', 'vois'],
    endpoint: 'organism://nova/defense/sentinel-watch',
    inputSchema: makeSchema('SentinelInput', [
      ['zone', 'string', false, 'specific zone to check (default: all)'],
      ['depth', 'string', false, 'surface | deep | full (default: surface)'],
      ['reportType', 'string', false, 'summary | detailed | alert-only'],
    ]),
    outputSchema: makeSchema('SentinelOutput', [
      ['status', 'string', true, 'green | yellow | orange | red'],
      ['threats', 'Threat[]', true, 'detected threats'],
      ['intrusionAttempts', 'number', true, 'intrusion attempts in window'],
      ['perimeterIntegrity', 'number', true, 'perimeter integrity 0-1'],
    ]),
    latencyMs: 2, costWeight: 0.6, billingClass: 'FREE',
    successContract: 'Returns sentinel status within 2ms. Red status triggers automatic Crown alert.',
    capabilities: ['perimeter monitoring', 'intrusion detection', 'threat assessment', 'alert escalation'],
    dependencies: ['PULSE-KEEPER'], version: '1.0.0', coherence: phiCoh(10, 20),
  },

  // ─── Tool 12: INTEGRITY-CHECKER ──────────────────────────────────────────
  {
    id: 'TOOL-12', name: 'Integrity Checker', codename: 'INTEGRITY-CHECKER',
    purpose: 'Verifies data and code integrity — nothing is corrupted',
    description: 'The integrity guardian. Hashes, checksums, and validates every piece of data and code in the organism. If something is corrupted, Integrity Checker finds it.',
    house: 'DEFENSE', orchestrator: 'SECURITY_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['seal'],
    endpoint: 'organism://nova/defense/integrity-checker',
    inputSchema: makeSchema('IntegrityInput', [
      ['target', 'string', true, 'what to check: state | code | data | all'],
      ['scope', 'string', false, 'specific scope within target'],
      ['algorithm', 'string', false, 'hash algorithm: sha256 | blake3 (default: blake3)'],
    ]),
    outputSchema: makeSchema('IntegrityOutput', [
      ['valid', 'boolean', true, 'whether integrity check passed'],
      ['checksumMatch', 'boolean', true, 'whether checksums match'],
      ['corruptions', 'Corruption[]', true, 'list of corrupted items'],
      ['lastVerified', 'number', true, 'timestamp of last verification'],
    ]),
    latencyMs: 3, costWeight: 0.5, billingClass: 'FREE',
    successContract: 'Returns integrity status within 3ms. Corruptions trigger automatic quarantine.',
    capabilities: ['hash verification', 'checksum validation', 'state integrity', 'tamper detection'],
    dependencies: ['SEAL-VERIFIER'], version: '1.0.0', coherence: phiCoh(11, 20),
  },

  // ─── Tool 13: BOUNDARY-ENFORCER ──────────────────────────────────────────
  {
    id: 'TOOL-13', name: 'Boundary Enforcer', codename: 'BOUNDARY-ENFORCER',
    purpose: 'Enforces boundaries between houses and trust tiers',
    description: 'The border guard. Enforces access boundaries between houses, validates crossing permissions, and maintains isolation between trust tiers. Every cross-house call goes through here.',
    house: 'DEFENSE', orchestrator: 'SECURITY_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'ORGANISM', protocols: ['seal', 'nexu'],
    endpoint: 'organism://nova/defense/boundary-enforcer',
    inputSchema: makeSchema('BoundaryInput', [
      ['fromHouse', 'string', true, 'source house'],
      ['toHouse', 'string', true, 'destination house'],
      ['callerId', 'string', true, 'ID of the calling AI'],
      ['action', 'string', true, 'requested action'],
      ['trustTier', 'string', true, 'caller trust tier'],
    ]),
    outputSchema: makeSchema('BoundaryOutput', [
      ['allowed', 'boolean', true, 'whether crossing is permitted'],
      ['reason', 'string', true, 'reason for decision'],
      ['restrictions', 'string[]', true, 'any restrictions applied'],
      ['auditId', 'string', true, 'audit trail ID for this crossing'],
    ]),
    latencyMs: 2, costWeight: 0.4, billingClass: 'FREE',
    successContract: 'Returns boundary decision within 2ms. Every crossing is audited.',
    capabilities: ['access control', 'boundary definition', 'crossing validation', 'isolation enforcement'],
    dependencies: ['SENTINEL-WATCH'], version: '1.0.0', coherence: phiCoh(12, 20),
  },

  // ─── Tool 14: ANOMALY-DETECTOR ───────────────────────────────────────────
  {
    id: 'TOOL-14', name: 'Anomaly Detector', codename: 'ANOMALY-DETECTOR',
    purpose: 'Detects anomalies in behavior, data, and system patterns',
    description: 'The anomaly hunter. Uses statistical methods, behavioral baselines, and pattern analysis to find anything unusual. The early warning system of the organism.',
    house: 'DEFENSE', orchestrator: 'SECURITY_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET', 'DEVELOPER_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['seal', 'puls'],
    endpoint: 'organism://nova/defense/anomaly-detector',
    inputSchema: makeSchema('AnomalyInput', [
      ['dataStream', 'any', true, 'data stream to analyze'],
      ['baseline', 'string', false, 'baseline profile to compare against'],
      ['sensitivity', 'number', false, 'detection sensitivity 0-1 (default: 0.618)'],
      ['window', 'number', false, 'analysis window in ms'],
    ]),
    outputSchema: makeSchema('AnomalyOutput', [
      ['anomalies', 'Anomaly[]', true, 'detected anomalies'],
      ['count', 'number', true, 'number of anomalies found'],
      ['severity', 'string', true, 'overall severity: low | medium | high | critical'],
      ['recommendation', 'string', true, 'recommended action'],
    ]),
    latencyMs: 5, costWeight: 0.6, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Returns anomaly analysis within 5ms. Critical anomalies trigger automatic Defense alert.',
    capabilities: ['statistical anomaly detection', 'behavioral analysis', 'outlier identification', 'drift detection'],
    dependencies: ['PATTERN-SEEKER', 'FLOW-MONITOR'], version: '1.0.0', coherence: phiCoh(13, 20),
  },

  // ─── Tool 15: SEAL-VERIFIER ──────────────────────────────────────────────
  {
    id: 'TOOL-15', name: 'Seal Verifier', codename: 'SEAL-VERIFIER',
    purpose: 'Verifies sovereignty seals on all actions and artifacts',
    description: 'The seal guardian. Every sovereign action, every artifact, every deployment bears a cryptographic seal. This tool verifies them all.',
    house: 'DEFENSE', orchestrator: 'SECURITY_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'ORGANISM', protocols: ['seal'],
    endpoint: 'organism://nova/defense/seal-verifier',
    inputSchema: makeSchema('SealInput', [
      ['artifact', 'string', true, 'artifact ID or action ID to verify'],
      ['seal', 'string', true, 'seal to verify'],
      ['expectedSigner', 'string', false, 'expected signer principal'],
    ]),
    outputSchema: makeSchema('SealOutput', [
      ['valid', 'boolean', true, 'whether seal is valid'],
      ['signer', 'string', true, 'actual signer principal'],
      ['timestamp', 'number', true, 'when seal was created'],
      ['chainDepth', 'number', true, 'chain-of-trust depth'],
    ]),
    latencyMs: 3, costWeight: 0.4, billingClass: 'FREE',
    successContract: 'Returns seal verification within 3ms. Invalid seals are logged and reported to Crown.',
    capabilities: ['seal verification', 'signature validation', 'chain-of-trust', 'revocation checking'],
    dependencies: [], version: '1.0.0', coherence: phiCoh(14, 20),
  },

  // ─── Tool 16: RESOURCE-BALANCER ──────────────────────────────────────────
  {
    id: 'TOOL-16', name: 'Resource Balancer', codename: 'RESOURCE-BALANCER',
    purpose: 'Balances resource allocation across all houses',
    description: 'The organism resource manager. Allocates compute, memory, bandwidth, and cycles across all houses based on demand, priority, and fairness. The economic backbone.',
    house: 'ECONOMICS', orchestrator: 'ECONOMIC_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_LEAD', protocols: ['flux', 'vois'],
    endpoint: 'organism://nova/economics/resource-balancer',
    inputSchema: makeSchema('ResourceInput', [
      ['action', 'string', true, 'allocate | rebalance | query | reserve'],
      ['house', 'string', true, 'requesting house'],
      ['resourceType', 'string', true, 'compute | memory | bandwidth | cycles'],
      ['amount', 'number', false, 'requested amount'],
      ['priority', 'number', false, 'request priority 0-1'],
    ]),
    outputSchema: makeSchema('ResourceOutput', [
      ['granted', 'boolean', true, 'whether request was granted'],
      ['allocated', 'number', true, 'amount actually allocated'],
      ['utilization', 'number', true, 'current utilization 0-1'],
      ['fairnessScore', 'number', true, 'fairness of allocation 0-1'],
    ]),
    latencyMs: 5, costWeight: 0.7, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Returns allocation decision within 5ms. Fairness is maintained across all houses.',
    capabilities: ['resource allocation', 'load balancing', 'capacity planning', 'waste reduction'],
    dependencies: ['CYCLE-COUNTER'], version: '1.0.0', coherence: phiCoh(15, 20),
  },

  // ─── Tool 17: CONNECTION-POOL ────────────────────────────────────────────
  {
    id: 'TOOL-17', name: 'Connection Pool', codename: 'CONNECTION-POOL',
    purpose: 'Manages connection pools — efficient resource sharing',
    description: 'The connection manager. Maintains pools of reusable connections between houses, external services, and canisters. Handles timeouts, health checks, and pool sizing.',
    house: 'INFRASTRUCTURE', orchestrator: 'DEPLOYMENT_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['puls', 'nexu'],
    endpoint: 'organism://nova/infrastructure/connection-pool',
    inputSchema: makeSchema('ConnectionPoolInput', [
      ['action', 'string', true, 'acquire | release | status | resize'],
      ['poolId', 'string', true, 'connection pool identifier'],
      ['timeout', 'number', false, 'connection timeout in ms'],
    ]),
    outputSchema: makeSchema('ConnectionPoolOutput', [
      ['connectionId', 'string', false, 'acquired connection ID'],
      ['poolSize', 'number', true, 'current pool size'],
      ['active', 'number', true, 'active connections'],
      ['available', 'number', true, 'available connections'],
    ]),
    latencyMs: 2, costWeight: 0.4, billingClass: 'FREE',
    successContract: 'Connection acquisition within 2ms. Pool auto-sizes based on demand.',
    capabilities: ['pool management', 'connection reuse', 'timeout handling', 'pool sizing'],
    dependencies: ['PULSE-KEEPER'], version: '1.0.0', coherence: phiCoh(16, 20),
  },

  // ─── Tool 18: CACHE-OPTIMIZER ────────────────────────────────────────────
  {
    id: 'TOOL-18', name: 'Cache Optimizer', codename: 'CACHE-OPTIMIZER',
    purpose: 'Optimizes caching across all layers — speed through memory',
    description: 'The caching brain. Manages caches at every layer, optimizes hit rates, handles invalidation, and manages memory pressure. The speed multiplier of the organism.',
    house: 'INFRASTRUCTURE', orchestrator: 'DEPLOYMENT_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['puls', 'mens'],
    endpoint: 'organism://nova/infrastructure/cache-optimizer',
    inputSchema: makeSchema('CacheInput', [
      ['action', 'string', true, 'get | put | invalidate | stats | optimize'],
      ['cacheKey', 'string', false, 'cache key for get/put/invalidate'],
      ['value', 'any', false, 'value to cache'],
      ['ttl', 'number', false, 'time-to-live in ms'],
    ]),
    outputSchema: makeSchema('CacheOutput', [
      ['hit', 'boolean', false, 'whether cache hit (for get)'],
      ['value', 'any', false, 'cached value (for get)'],
      ['hitRate', 'number', true, 'overall cache hit rate 0-1'],
      ['memoryUsage', 'number', true, 'cache memory usage 0-1'],
    ]),
    latencyMs: 1, costWeight: 0.3, billingClass: 'FREE',
    successContract: 'Cache operations within 1ms. Hit rate targets PHI_INV (0.618) minimum.',
    capabilities: ['cache management', 'invalidation strategy', 'hit rate optimization', 'memory pressure handling'],
    dependencies: [], version: '1.0.0', coherence: phiCoh(17, 20),
  },

  // ─── Tool 19: QUEUE-PROCESSOR ────────────────────────────────────────────
  {
    id: 'TOOL-19', name: 'Queue Processor', codename: 'QUEUE-PROCESSOR',
    purpose: 'Processes message queues — FIFO, priority, and delay queues',
    description: 'The queue engine. Manages all message queues in the organism — FIFO for ordered processing, priority for urgent items, delay for scheduled execution. The patient backbone.',
    house: 'COMMUNICATION', orchestrator: 'COMMUNICATION_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET'],
    permissionClass: 'HOUSE_MEMBER', protocols: ['nexu', 'flux'],
    endpoint: 'organism://nova/communication/queue-processor',
    inputSchema: makeSchema('QueueInput', [
      ['action', 'string', true, 'enqueue | dequeue | peek | status'],
      ['queueId', 'string', true, 'queue identifier'],
      ['message', 'any', false, 'message to enqueue'],
      ['priority', 'number', false, 'message priority (for priority queues)'],
    ]),
    outputSchema: makeSchema('QueueOutput', [
      ['message', 'any', false, 'dequeued message'],
      ['queueDepth', 'number', true, 'current queue depth'],
      ['processedCount', 'number', true, 'total messages processed'],
      ['oldestAge', 'number', true, 'age of oldest message in ms'],
    ]),
    latencyMs: 2, costWeight: 0.4, billingClass: 'CYCLE_WEIGHTED',
    successContract: 'Queue operations within 2ms. Messages are never lost — dead letters are preserved.',
    capabilities: ['queue processing', 'priority scheduling', 'batch processing', 'backpressure handling'],
    dependencies: ['CONNECTION-POOL'], version: '1.0.0', coherence: phiCoh(18, 20),
  },

  // ─── Tool 20: LOG-STREAMER ───────────────────────────────────────────────
  {
    id: 'TOOL-20', name: 'Log Streamer', codename: 'LOG-STREAMER',
    purpose: 'Streams logs from all houses — the organism narrator',
    description: 'The organism storyteller. Aggregates logs from every house, every AI, every engine into a unified stream. Real-time tailing, searching, and filtering. The organism voice.',
    house: 'COMMUNICATION', orchestrator: 'COMMUNICATION_ORCHESTRATOR',
    alwaysRunning: true, trustTier: 'INTERNAL', surfaces: ['INTERNAL_CALL_MARKET', 'DEVELOPER_CALL_MARKET'],
    permissionClass: 'ORGANISM', protocols: ['nexu', 'mens'],
    endpoint: 'organism://nova/communication/log-streamer',
    inputSchema: makeSchema('LogStreamInput', [
      ['action', 'string', true, 'stream | search | tail | export'],
      ['filter', 'string', false, 'log filter expression'],
      ['house', 'string', false, 'filter to specific house'],
      ['level', 'string', false, 'log level: debug | info | warn | error | fatal'],
      ['limit', 'number', false, 'max entries to return (default: 100)'],
    ]),
    outputSchema: makeSchema('LogStreamOutput', [
      ['entries', 'LogEntry[]', true, 'log entries matching criteria'],
      ['count', 'number', true, 'total matching entries'],
      ['streamId', 'string', false, 'stream ID for continued tailing'],
      ['truncated', 'boolean', true, 'whether results were truncated'],
    ]),
    latencyMs: 2, costWeight: 0.3, billingClass: 'FREE',
    successContract: 'Returns log entries within 2ms. Streams never buffer more than 1000 entries.',
    capabilities: ['log aggregation', 'stream processing', 'log searching', 'real-time tailing'],
    dependencies: ['PULSE-KEEPER'], version: '1.0.0', coherence: phiCoh(19, 20),
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// QUERY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/** Get the full marketplace state */
export function getMarketplaceState(): MarketplaceState {
  const toolCoh = CALLABLE_TOOLS.reduce((s, t) => s + t.coherence, 0) / CALLABLE_TOOLS.length;
  const orchCoh = ORCHESTRATORS.reduce((s, o) => s + o.coherence, 0) / ORCHESTRATORS.length;
  return {
    tools: CALLABLE_TOOLS,
    orchestrators: ORCHESTRATORS,
    surfaces: MARKET_SURFACES,
    protocols: SOVEREIGN_PROTOCOLS,
    totalTools: CALLABLE_TOOLS.length,
    totalOrchestrators: ORCHESTRATORS.length,
    totalProtocols: SOVEREIGN_PROTOCOLS.length,
    coherence: (toolCoh + orchCoh) / 2,
    lastUpdate: Date.now(),
  };
}

/** Get a callable tool by codename */
export function getToolByCodename(codename: string): CallableTool | undefined {
  return CALLABLE_TOOLS.find(t => t.codename === codename);
}

/** Get a callable tool by ID */
export function getToolById(id: string): CallableTool | undefined {
  return CALLABLE_TOOLS.find(t => t.id === id);
}

/** Get all tools in a house */
export function getToolsByHouse(house: string): CallableTool[] {
  return CALLABLE_TOOLS.filter(t => t.house === house);
}

/** Get all tools on a market surface */
export function getToolsBySurface(surface: MarketSurface): CallableTool[] {
  return CALLABLE_TOOLS.filter(t => t.surfaces.includes(surface));
}

/** Get all tools by trust tier */
export function getToolsByTrustTier(tier: TrustTier): CallableTool[] {
  return CALLABLE_TOOLS.filter(t => t.trustTier === tier);
}

/** Get all tools using a protocol */
export function getToolsByProtocol(protocol: SovereignProtocol): CallableTool[] {
  return CALLABLE_TOOLS.filter(t => t.protocols.includes(protocol));
}

/** Get all tools by billing class */
export function getToolsByBillingClass(billingClass: BillingClass): CallableTool[] {
  return CALLABLE_TOOLS.filter(t => t.billingClass === billingClass);
}

/** Get an orchestrator by division */
export function getOrchestrator(division: OrchestratorDivision): Orchestrator | undefined {
  return ORCHESTRATORS.find(o => o.division === division);
}

/** Get all orchestrators in a house */
export function getOrchestratorsByHouse(house: string): Orchestrator[] {
  return ORCHESTRATORS.filter(o => o.house === house);
}

/** Get a protocol by name */
export function getProtocol(protocol: SovereignProtocol): ProtocolSpec | undefined {
  return SOVEREIGN_PROTOCOLS.find(p => p.protocol === protocol);
}

/** Get a market surface by type */
export function getMarketSurface(surface: MarketSurface): MarketSurfaceSpec | undefined {
  return MARKET_SURFACES.find(s => s.surface === surface);
}

/** Search tools by capability */
export function searchToolsByCapability(capability: string): CallableTool[] {
  const lower = capability.toLowerCase();
  return CALLABLE_TOOLS.filter(t =>
    t.capabilities.some(c => c.toLowerCase().includes(lower))
  );
}

/** Get the tool dependency graph */
export function getToolDependencyGraph(): Map<string, string[]> {
  const graph = new Map<string, string[]>();
  for (const tool of CALLABLE_TOOLS) {
    graph.set(tool.codename, tool.dependencies);
  }
  return graph;
}

/** Get orchestrator connection graph */
export function getOrchestratorGraph(): Map<string, { inner: string[]; outer: string[] }> {
  const graph = new Map<string, { inner: string[]; outer: string[] }>();
  for (const orch of ORCHESTRATORS) {
    graph.set(orch.division, {
      inner: orch.innerOrchestrators,
      outer: orch.outerOrchestrators,
    });
  }
  return graph;
}
