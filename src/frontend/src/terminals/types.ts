// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Terminal System Types
// Sovereign terminal architecture: calls, packages, organisms, AI models
// ═══════════════════════════════════════════════════════════════════════════════

/** Domain families that organize all terminal surfaces */
export type TerminalDomain =
  | 'DEFENSE'
  | 'MEMORY'
  | 'GOVERNANCE'
  | 'NEURAL'
  | 'QUANTUM'
  | 'ECONOMIC'
  | 'SWARM'
  | 'COGNITIVE'
  | 'SENSOR'
  | 'FREQUENCY'
  | 'SOVEREIGNTY'
  | 'INTEGRATION'
  | 'PACKAGING'
  | 'INTELLIGENCE'
  | 'MATH';

/** A multimodal call — one API surface that retrieves organism state */
export interface MultimodalCall {
  id: string;
  name: string;
  domain: TerminalDomain;
  endpoint: string;           // backend function name
  description: string;
  modalities: string[];       // data modalities returned
  refreshHz: number;          // recommended poll frequency
  ring: string;               // N1-N12 ring affinity
}

/** A multimodal package — grouped calls forming one AI organism model */
export interface MultimodalPackage {
  id: string;
  name: string;
  domain: TerminalDomain;
  description: string;
  calls: string[];            // call IDs composing this package
  aiModel: string;            // R-MODEL / U-MODEL name
  capabilities: string[];     // what this organism can do
  outputFormat: string;       // primary output format
}

/** Terminal message for the output stream */
export interface TerminalMessage {
  id: string;
  timestamp: number;
  source: string;
  type: 'INFO' | 'DATA' | 'ALERT' | 'COMMAND' | 'RESPONSE' | 'SYSTEM';
  content: string;
  domain: TerminalDomain;
}

/** Terminal tab for the hub */
export interface TerminalTab {
  id: TerminalDomain;
  label: string;
  icon: string;
  color: string;
  description: string;
}

/** Common status returned from organism subsystems */
export interface OrganismStatus {
  coherence: number;
  activity: number;
  health: number;
  lastBeat: number;
  alerts: string[];
}

/** A sovereign SDK — deployable intelligence package for external developers */
export interface SovereignSDK {
  id: string;
  name: string;
  description: string;
  domain: TerminalDomain;
  packages: string[];          // package IDs composing this SDK
  targetAudience: string;
  capabilities: string[];
  apiSurface: string[];        // exposed API endpoints
  deploymentTarget: string;    // ICP canister / npm / standalone
  license: string;
}

/** A developer tool — self-contained utility for the NOVA ecosystem */
export interface DeveloperTool {
  id: string;
  name: string;
  description: string;
  category: string;
  capabilities: string[];
  inputFormat: string;
  outputFormat: string;
  integration: string;         // how it connects to the organism
}

/** A public GitHub repository definition */
export interface PublicRepo {
  name: string;
  description: string;
  sdks: string[];              // SDK IDs included
  tools: string[];             // Tool IDs included
  packages: string[];          // Package IDs included
  language: string;
  license: string;
  topics: string[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// GO SYSTEM — Enterprise Platform Types
// Company: Medina GO Systems · Real-time infrastructure monitoring & AI tools
// ═══════════════════════════════════════════════════════════════════════════════

/** GO System division categories */
export type GoDivision =
  | 'INFRASTRUCTURE'    // Real-time monitoring, metrics, logs, alerts
  | 'CODING_AGENTS'     // Semantic code retrieval & editing tools marketplace
  | 'CRAWLING'          // Crawling model families, web data extraction
  | 'MCP_SERVERS'       // MCP servers: terminal, file, process, transport
  | 'ERROR_MONITORING'  // Sentry model, error tracking, debugging
  | 'DESKTOP_COMMAND'   // Desktop commander models, terminal, file ops
  | 'CONTEXT_DOCS'      // Playwright context model, up-to-date docs
  | 'WORKFLOWS'         // Terraform, automated 24h workflows
  | 'SCRAPING'          // Scrapers, crawlers, automations marketplace
  | 'TESTING';          // Accessibility trees, data extraction, testing

/** The GO System enterprise company definition */
export interface GoSystemCompany {
  name: string;
  fullName: string;
  description: string;
  divisions: GoDivision[];
  tier: string;                 // ENTERPRISE
  capabilities: string[];
  infrastructure: string[];
  targetMarket: string[];
}

/** A GO System model — intelligence engine within the GO platform */
export interface GoModel {
  id: string;
  name: string;
  family: string;              // model family (crawling, context, commander, etc.)
  division: GoDivision;
  description: string;
  capabilities: string[];
  inputFormats: string[];
  outputFormats: string[];
  integrations: string[];
  status: 'ACTIVE' | 'BETA' | 'ALPHA' | 'PLANNED';
}

/** A GO MCP Server — Model Context Protocol server for AI assistants */
export interface GoMcpServer {
  id: string;
  name: string;
  division: GoDivision;
  description: string;
  transport: string;           // stdio / sse / websocket / http
  capabilities: string[];
  commands: string[];
  integrations: string[];
}

/** A GO Marketplace item — scraper, crawler, or automation */
export interface GoMarketplaceItem {
  id: string;
  name: string;
  category: string;
  division: GoDivision;
  description: string;
  capabilities: string[];
  targetSources: string[];
  outputFormats: string[];
  automation: boolean;
}

/** GO Workflow — automated 24h business/work workflow */
export interface GoWorkflow {
  id: string;
  name: string;
  description: string;
  division: GoDivision;
  type: 'TERRAFORM' | 'CI_CD' | 'DATA_PIPELINE' | 'MONITORING' | 'DEPLOYMENT' | 'BUSINESS';
  schedule: string;            // cron or 24h-continuous
  steps: string[];
  integrations: string[];
}

export const TERMINAL_TABS: TerminalTab[] = [
  { id: 'DEFENSE',       label: 'Defense',        icon: '⛊', color: '#f44',  description: 'War/Defense/AEGIS/Counterforce' },
  { id: 'MEMORY',        label: 'Memory',         icon: '◈', color: '#a4f',  description: 'Memory Temple/Palace/Consolidation' },
  { id: 'GOVERNANCE',    label: 'Governance',      icon: '⚖', color: '#fa4',  description: 'Laws/Doctrine/Sovereignty/Compliance' },
  { id: 'NEURAL',        label: 'Neural',          icon: '⊛', color: '#4fa',  description: 'Neural Core/Brain Regions/Neurochem' },
  { id: 'QUANTUM',       label: 'Quantum',         icon: '⟁', color: '#4af',  description: 'Quantum Heartbeat/Operators/Channels' },
  { id: 'ECONOMIC',      label: 'Economic',        icon: '◆', color: '#4f8',  description: 'Token/FORMA/Trading/Economic' },
  { id: 'SWARM',         label: 'Swarm',           icon: '⬡', color: '#6af',  description: 'Swarm/Drone/Fleet/Kuramoto' },
  { id: 'COGNITIVE',     label: 'Cognitive',        icon: '∿', color: '#f4a',  description: 'Feedback/Emergence/Prediction/Learning' },
  { id: 'SENSOR',        label: 'Sensor',           icon: '◎', color: '#af4',  description: 'IoT/Field Scanner/Hybrid Hub/World' },
  { id: 'FREQUENCY',     label: 'Frequency',        icon: '∼', color: '#fa8',  description: 'Frequency Grid/Hz Spectrum/Circadian' },
  { id: 'SOVEREIGNTY',   label: 'Sovereignty',      icon: '♛', color: '#ff4',  description: 'Genesis/Seal/Architect/Identity' },
  { id: 'INTEGRATION',   label: 'Integration',      icon: '⊕', color: '#8af',  description: 'Shell/Animal Intelligence/Spherical' },
  { id: 'PACKAGING',     label: 'Packaging',        icon: '▣', color: '#a8f',  description: 'Packaging Lab/SDK/VZO/VOIS' },
  { id: 'INTELLIGENCE',  label: 'Intelligence',     icon: '◉', color: '#4ff',  description: 'Analyst Team/Internal Labs/Organism' },
  { id: 'MATH',          label: 'Mathematics',      icon: '∂', color: '#f8a',  description: 'Sacred Math/Physics/Unified Field' },
];
