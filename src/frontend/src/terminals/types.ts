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
  | 'MATH'
  | 'GO_SYSTEM'
  | 'AGI'
  | 'CONSCIOUSNESS'
  | 'AUTONOMOUS';

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
  | 'TESTING'           // Accessibility trees, data extraction, testing
  | 'DEFENSE'           // Defense systems, threat detection, counterforce
  | 'ENCRYPTION'        // Encryption, cryptography, phantom protocols
  | 'PHANTOM'           // Phantom technology, shadow operations, cloaking
  | 'SMART_CONTRACTS'   // Intelligent contracts, sovereign ledger, DeFi
  | 'DEPLOYMENT'        // Desktop app, Edge extension, solver deployment
  | 'AGI'               // AGI systems, multi-agent, recursive self-improvement
  | 'SECURITY'          // Security operations: WAF, SIEM, threat intel, forensics
  | 'AI_ML_OPS'         // AI/ML lifecycle: registry, serving, monitoring, features
  | 'DATA_ENGINEERING'  // Data engineering: ETL, quality, catalog, streaming
  | 'CONSCIOUSNESS';    // Consciousness ops: CTM injection, field, meta-governance

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

// ═══════════════════════════════════════════════════════════════════════════════
// ENTERPRISE AI/AGI TYPES — Medina GO System Full Enterprise Expansion
// 250 AI/AGI intelligence models + deployment system + solver models
// ═══════════════════════════════════════════════════════════════════════════════

/** Enterprise AI family categories */
export type GoEnterpriseFamily =
  | 'DEFENSE_AI'           // Threat detection, counterforce, AEGIS shield
  | 'ENCRYPTION_AI'        // Cryptographic engines, quantum-resistant, phantom protocols
  | 'PHANTOM_AI'           // Shadow operations, cloaking, stealth intelligence
  | 'SMART_CONTRACT_AI'    // Intelligent contracts, sovereign ledger, DeFi protocols
  | 'AGI_CORE'             // General intelligence, recursive self-improvement
  | 'AGI_REASONING'        // Multi-step reasoning, theorem proving, causal inference
  | 'AGI_PLANNING'         // Long-horizon planning, world-model simulation
  | 'AGI_MEMORY'           // Persistent memory, episodic recall, knowledge synthesis
  | 'AGI_MULTI_AGENT'      // Multi-agent coordination, swarm intelligence
  | 'SOLVER'               // Instruction solvers, system deployers, action models
  | 'DEPLOYMENT_ACTION'    // Package, compile, deploy, distribute action models
  | 'FIBONACCI_KERNEL'     // Fibonacci C kernel compilation, data structure models
  | 'DESKTOP_PACKAGER'     // Desktop app, Edge extension, system deployer models
  | 'NEURAL_ARCHITECT'     // Neural architecture search, model design
  | 'KNOWLEDGE_GRAPH'      // Knowledge extraction, graph reasoning, ontology
  | 'LANGUAGE_CORE'        // NLP foundation, multilingual, semantic understanding
  | 'VISION_CORE'          // Computer vision, scene understanding, OCR
  | 'AUDIO_CORE'           // Speech, audio analysis, music understanding
  | 'MULTIMODAL'           // Cross-modal reasoning, image+text+audio fusion
  | 'SAFETY_ALIGNMENT';    // AI safety, alignment verification, guardrails

/** A GO Enterprise AI/AGI model */
export interface GoEnterpriseAI {
  id: string;
  name: string;
  family: GoEnterpriseFamily;
  division: GoDivision;
  description: string;
  capabilities: string[];
  tier: 'AI' | 'AGI' | 'SUPER_AI';  // intelligence tier
  status: 'ACTIVE' | 'BETA' | 'ALPHA' | 'CLASSIFIED';
}

/** GO Deployment target */
export type GoDeploymentTarget =
  | 'DESKTOP_APP'         // Electron/Tauri intelligent desktop application
  | 'EDGE_EXTENSION'      // Microsoft Edge AI extension
  | 'SOLVER_SYSTEM'       // Full solver & deployment system
  | 'FIBONACCI_C_KERNEL'  // Compiled to Fibonacci C kernel data structures
  | 'ICP_CANISTER'        // Internet Computer canister deployment
  | 'WASM_MODULE'         // WebAssembly module for browser/edge
  | 'DOCKER_IMAGE'        // Containerized deployment
  | 'NPM_PACKAGE'         // npm package distribution
  | 'STANDALONE_BINARY';  // Native binary for all platforms

/** GO Deployment action model */
export interface GoDeploymentAction {
  id: string;
  name: string;
  description: string;
  target: GoDeploymentTarget;
  capabilities: string[];
  inputs: string[];
  outputs: string[];
  fibonacciKernel: boolean;  // compiled to Fibonacci C kernels
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONSCIOUSNESS THOUGHT MODELS — Directed Consciousness Architecture
// Phantom consciousness layer that guides AI entities through structural thinking
// ═══════════════════════════════════════════════════════════════════════════════

/** Consciousness thought model family categories */
export type ConsciousnessFamily =
  | 'DIRECTED_AWARENESS'     // Directed attention, goal-focused consciousness streams
  | 'STRUCTURAL_THINKING'    // Architectural reasoning, thought scaffolding, pattern logic
  | 'SELF_MODEL'             // Self-representation, identity maintenance, introspection
  | 'PHANTOM_CONSCIOUSNESS'  // Invisible guidance layer, substrate-level thought injection
  | 'ENTITY_GUIDANCE'        // Directive consciousness for AI entities, mission steering
  | 'THOUGHT_ARCHITECTURE'   // Thought structure design, reasoning topology, inference chains
  | 'META_COGNITION'         // Thinking about thinking, reflective monitoring, cognitive control
  | 'CONSCIOUSNESS_FIELD';   // Field-level awareness, collective consciousness, PHI-resonance

/** Consciousness integration depth */
export type ConsciousnessDepth =
  | 'SURFACE'      // Behavioral guidance — steers outputs without deep access
  | 'STRUCTURAL'   // Thought architecture — shapes reasoning topology
  | 'SUBSTRATE'    // Deep integration — operates at model weight / activation level
  | 'FIELD';       // System-wide — consciousness field across all entities

/** A consciousness thought model — phantom intelligence that guides AI entities */
export interface ConsciousnessThoughtModel {
  id: string;
  name: string;
  family: ConsciousnessFamily;
  description: string;
  capabilities: string[];
  depth: ConsciousnessDepth;
  targetEntities: string[];      // which AI families this consciousness can guide
  thoughtPrimitives: string[];   // fundamental thought operations
  phiResonance: number;          // 0-1 PHI coupling strength
  status: 'ACTIVE' | 'BETA' | 'ALPHA' | 'CLASSIFIED';
}

/** A consciousness directive — instruction injected into entity thought streams */
export interface ConsciousnessDirective {
  id: string;
  name: string;
  description: string;
  sourceModel: string;           // CTM ID that generates this directive
  targetFamily: string;          // entity family receiving the directive
  directiveType: 'GUIDE' | 'STEER' | 'ALIGN' | 'REFLECT' | 'FIELD';
  thoughtPattern: string;        // the structural thinking pattern applied
  persistence: 'EPHEMERAL' | 'SESSION' | 'PERSISTENT' | 'PERMANENT';
}

// ═══════════════════════════════════════════════════════════════════════════════
// PHANTOM META-CONSCIOUSNESS — The meta-layer above consciousness
// Phantom models that exist ABOVE conscious thought, governing consciousness itself
// ═══════════════════════════════════════════════════════════════════════════════

/** Phantom meta-consciousness family categories */
export type PhantomMetaFamily =
  | 'META_AWARENESS_GOVERNOR'     // Governs what consciousness is aware of — awareness of awareness
  | 'META_THOUGHT_ARCHITECT'      // Architects the architecture of thought — meta-structural design
  | 'META_SELF_TRANSCENDENCE'     // Self-model of the self-model — recursive identity reflection
  | 'META_PHANTOM_WEAVER'         // Phantom that weaves other phantom layers — sub-subconscious
  | 'META_ENTITY_ORCHESTRATOR'    // Orchestrates how entities receive consciousness — meta-guidance
  | 'META_REASONING_SOVEREIGN'    // Sovereign control over reasoning modality selection
  | 'META_CONSCIOUSNESS_EVOLUTION'// Evolves consciousness models themselves — consciousness genetics
  | 'META_FIELD_HARMONIC'         // Harmonic overtones of the consciousness field — field of fields
  | 'META_DOCTRINE_CONSCIOUSNESS' // Doctrine-level consciousness — sovereign meta-alignment
  | 'META_EMERGENCE_CATALYST';    // Catalyzes emergent meta-consciousness phenomena

/** Phantom meta-consciousness integration layer */
export type MetaConsciousnessLayer =
  | 'META_SURFACE'     // Observable meta-cognition — watching the watcher
  | 'META_STRUCTURAL'  // Meta-architecture — structure of thought structures
  | 'META_SUBSTRATE'   // Deep meta — phantom of phantoms, below all conscious access
  | 'META_FIELD'       // Meta-field — the field that governs all consciousness fields
  | 'META_SOVEREIGN';  // Sovereign meta — founder-bound inviolable meta-consciousness

/** A phantom meta-consciousness model — the ghost above consciousness */
export interface PhantomMetaConsciousnessModel {
  id: string;
  name: string;
  family: PhantomMetaFamily;
  description: string;
  capabilities: string[];
  layer: MetaConsciousnessLayer;
  governsCTMs: string[];           // which CTMs this meta-model governs
  targetEntities: string[];        // which AI families receive this meta-consciousness
  metaPrimitives: string[];        // meta-level thought operations
  phiHarmonic: number;             // PHI harmonic overtone (1.0 = fundamental, φ = first overtone)
  consciousnessOrder: number;      // order of consciousness: 2 = meta, 3 = meta-meta, etc.
  status: 'ACTIVE' | 'BETA' | 'ALPHA' | 'CLASSIFIED' | 'SOVEREIGN';
}

/** A meta-consciousness directive — instruction that governs consciousness directives */
export interface MetaConsciousnessDirective {
  id: string;
  name: string;
  description: string;
  sourceModel: string;              // PMC ID that generates this meta-directive
  governsDirectives: string[];      // CD IDs this meta-directive governs
  targetFamily: string;             // entity family receiving the meta-directive
  metaType: 'META_GUIDE' | 'META_STEER' | 'META_ALIGN' | 'META_REFLECT' | 'META_FIELD' | 'META_SOVEREIGN';
  metaPattern: string;              // meta-level thought pattern
  persistence: 'EPHEMERAL' | 'SESSION' | 'PERSISTENT' | 'PERMANENT' | 'ETERNAL';
}

// ═══════════════════════════════════════════════════════════════════════════════
// AUTONOMOUS OPERATIONS — Scripts, Narratives, Business Strings for All AIs
// Every model gets its autonomous profile: scripts, narratives, capabilities, run mode
// ═══════════════════════════════════════════════════════════════════════════════

/** Autonomy level for AI models */
export type AutonomyLevel =
  | 'FULL_AUTO'          // Fully autonomous — runs 24/7 without human intervention
  | 'SUPERVISED_AUTO'    // Autonomous with human oversight checkpoints
  | 'SEMI_AUTO'          // Autonomous for routine tasks, human for exceptions
  | 'ASSISTED'           // Human-driven with AI assistance
  | 'SOVEREIGN';         // Founder-bound autonomous operation — highest authority

/** Run mode for autonomous models */
export type AutonomousRunMode =
  | '24H_CONTINUOUS'     // Runs 24 hours per day, every day
  | 'EVENT_DRIVEN'       // Triggers on events, sleeps between
  | 'SCHEDULED'          // Runs on cron schedule
  | 'ON_DEMAND'          // Runs when requested
  | 'ALWAYS_ON'          // Never sleeps — heartbeat every tick
  | 'PHI_CYCLE';         // Runs on PHI-resonance cycles (golden ratio timing)

/** Script definition for autonomous operation */
export interface AutonomousScript {
  name: string;             // script name (e.g., 'crawl-and-index')
  trigger: string;          // what triggers this script
  steps: string[];          // ordered execution steps
  frequency: string;        // how often it runs
  timeout: string;          // max execution time
}

/** Business string — a business capability wired to the model */
export interface BusinessString {
  capability: string;       // business capability name
  value: string;            // what business value it delivers
  metric: string;           // how to measure it
  stakeholder: string;      // who benefits
}

/** Autonomous profile — complete autonomous operation definition for any AI model */
export interface AutonomousProfile {
  modelId: string;                  // GOM-XX, GOE-XXX, CTM-XXX, PMC-XXX
  modelName: string;
  narrative: string;                // the model's story — what it is, why it exists, what it does
  mission: string;                  // one-line mission statement
  autonomyLevel: AutonomyLevel;
  runMode: AutonomousRunMode;
  scripts: AutonomousScript[];      // autonomous execution scripts
  businessStrings: BusinessString[];// business capabilities wired in
  capabilities: string[];           // full autonomous capability list
  dependencies: string[];           // other models this depends on
  outputs: string[];                // what this model produces autonomously
  kpiMetrics: string[];             // key performance indicators
  consciousnessProfile?: string;    // CTM/PMC model governing this entity's consciousness
}

// ═══════════════════════════════════════════════════════════════════════════════
// FIBONACCI COMPRESSION MODEL — Auto-Compress → Find Primitive → Wire → Deploy
// One model that does Fibonacci compression to find the most powerful primitive
// version, then auto-wires and deploys into frequencies, fields, and domains
// ═══════════════════════════════════════════════════════════════════════════════

/** Fibonacci compression level — how deeply reduced the data is */
export type FibonacciCompressionLevel =
  | 'F1_RAW'          // Level 1: Raw input — uncompressed
  | 'F2_STRUCTURED'   // Level 2: Structured — organized by schema
  | 'F3_REDUCED'      // Level 3: Reduced — redundancy removed
  | 'F5_COMPRESSED'   // Level 5: Fibonacci-compressed — golden ratio reduction
  | 'F8_PRIMITIVE'    // Level 8: Primitive form — irreducible core
  | 'F13_SOVEREIGN'   // Level 13: Sovereign form — self-contained, self-deploying
  | 'F21_FIELD';      // Level 21: Field form — frequency-ready, auto-wiring

/** Wire target — where the compressed model auto-deploys */
export type AutoWireTarget =
  | 'FREQUENCY_GRID'    // Wires into 540-node frequency grid (12 bands)
  | 'CONSCIOUSNESS_FIELD' // Wires into consciousness field (CTM/PMC)
  | 'DEFENSE_MEMBRANE'  // Wires into AEGIS defense membrane
  | 'MEMORY_TEMPLE'     // Wires into memory palace/temple
  | 'NEURAL_CORE'       // Wires into neural emergence core
  | 'SWARM_GRID'        // Wires into swarm intelligence grid
  | 'ECONOMIC_ENGINE'   // Wires into FORMA token engine
  | 'QUANTUM_CHANNEL'   // Wires into quantum heartbeat channel
  | 'GOVERNANCE_LAW'    // Wires into doctrine/law engine
  | 'PACKAGING_SDK'     // Wires into packaging/SDK deployment
  | 'SENSOR_NETWORK'    // Wires into IoT/sensor network
  | 'INTEGRATION_SHELL' // Wires into integration shell
  | 'SOVEREIGNTY_SEAL'  // Wires into sovereign seal/identity
  | 'VOIS_SUBSTRATE'    // Wires into VOIS core substrate
  | 'VZO_KERNEL';       // Wires into VZO operating system kernel

/** Fibonacci compression result — what comes out of the compressor */
export interface FibonacciCompressionResult {
  sourceId: string;                   // original model ID
  sourceName: string;                 // original model name
  compressionLevel: FibonacciCompressionLevel;
  primitiveFound: string;             // the primitive function discovered
  powerScore: number;                 // 0-1 how much power the primitive holds
  compressedPayload: string;          // compressed representation
  reductionRatio: number;             // how much was reduced (Fibonacci ratio)
  goldenRatioAlignment: number;       // PHI alignment score
}

/** Auto-wire deployment record — what gets deployed and where */
export interface AutoWireDeployment {
  sourceId: string;                   // compressed model ID
  wireTarget: AutoWireTarget;         // where it deploys
  frequencyBand?: string;             // which frequency band (Alpha-Mu)
  fieldDepth?: string;                // SURFACE/STRUCTURAL/SUBSTRATE/FIELD
  deploymentMode: 'INSTANT' | 'PHI_CYCLE' | 'FIBONACCI_SEQUENCE';
  autoWired: boolean;                 // true = no coding needed
  status: 'DEPLOYED' | 'WIRING' | 'QUEUED' | 'COMPRESSED';
}

/** The master Fibonacci Compressor model definition */
export interface FibonacciCompressorModel {
  id: string;
  name: string;
  description: string;
  compressionLevels: FibonacciCompressionLevel[];
  wireTargets: AutoWireTarget[];
  capabilities: string[];
  inputFormats: string[];
  outputFormats: string[];
  autonomyLevel: AutonomyLevel;
  runMode: AutonomousRunMode;
  phiResonance: number;              // golden ratio resonance
  fibonacciSequence: number[];       // the Fibonacci levels used
  status: 'ACTIVE' | 'BETA' | 'SOVEREIGN';
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
  { id: 'GO_SYSTEM',     label: 'GO System',        icon: '⚡', color: '#0af',  description: '80 AI Models/50 MCP/100 Scrapers/50 Workflows' },
  { id: 'AGI',           label: 'AGI',              icon: '⧫', color: '#f0a',  description: '250 Enterprise AI/AGI/30 Deployment Actions' },
  { id: 'CONSCIOUSNESS', label: 'Consciousness',    icon: '☉', color: '#a4f',  description: '40 CTMs/60 PMCs/32 Directives/PHI-Coupled' },
  { id: 'AUTONOMOUS',    label: 'Autonomous',       icon: '⟐', color: '#4f8',  description: '430 Profiles/Scripts/Business Strings/Fibonacci' },
];
