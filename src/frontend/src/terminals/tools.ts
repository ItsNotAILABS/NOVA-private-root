// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Developer Tools Registry
// 50 external developer tools for the NOVA ecosystem workplace
// Each tool is a self-contained utility that external developers can use
// ═══════════════════════════════════════════════════════════════════════════════

import type { DeveloperTool } from './types';

export const DEVELOPER_TOOLS: DeveloperTool[] = [

  // ═══════════════════════════════════════════════════════════════════════════
  // DEVELOPMENT TOOLS (1-10)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'TOOL-01', name: 'nova-cli',
    description: 'NOVA sovereign build CLI: type-check, compile, and deploy Motoko canisters without DFX',
    category: 'DEVELOPMENT',
    capabilities: ['type-checking', 'wasm-compilation', 'canister-deployment', 'dependency-resolution'],
    inputFormat: 'nova.json manifest', outputFormat: '.wasm binary',
    integration: 'Direct build system — replaces dfx for NOVA projects',
  },
  {
    id: 'TOOL-02', name: 'nova-inspector',
    description: 'Canister state inspector: query any organism endpoint and visualize response structure',
    category: 'DEVELOPMENT',
    capabilities: ['endpoint-discovery', 'state-inspection', 'response-visualization', 'type-inference'],
    inputFormat: 'canister ID + endpoint', outputFormat: 'structured state JSON',
    integration: 'Connects to any NOVA canister via Candid IDL',
  },
  {
    id: 'TOOL-03', name: 'nova-scaffold',
    description: 'Project scaffolding: generate new NOVA organism projects with all boilerplate',
    category: 'DEVELOPMENT',
    capabilities: ['project-generation', 'template-selection', 'dependency-setup', 'config-generation'],
    inputFormat: 'project config', outputFormat: 'complete project directory',
    integration: 'Generates nova.json, Motoko modules, and frontend skeleton',
  },
  {
    id: 'TOOL-04', name: 'nova-migrate',
    description: 'Migration tool: upgrade organism state across canister versions without data loss',
    category: 'DEVELOPMENT',
    capabilities: ['state-migration', 'schema-evolution', 'backward-compatibility', 'rollback-support'],
    inputFormat: 'migration script', outputFormat: 'migrated canister state',
    integration: 'Stable memory migration engine compatible with NO-DROP law',
  },
  {
    id: 'TOOL-05', name: 'nova-test',
    description: 'Testing framework: unit, integration, and property tests for Motoko organism modules',
    category: 'DEVELOPMENT',
    capabilities: ['unit-testing', 'integration-testing', 'property-testing', 'coverage-reporting'],
    inputFormat: 'test files (.test.mo)', outputFormat: 'test report',
    integration: 'Runs against moc compiler with assertion library',
  },
  {
    id: 'TOOL-06', name: 'nova-debug',
    description: 'Interactive debugger: step through Motoko code with state inspection and breakpoints',
    category: 'DEVELOPMENT',
    capabilities: ['breakpoint-debugging', 'state-inspection', 'step-execution', 'variable-watch'],
    inputFormat: 'Motoko source', outputFormat: 'debug session',
    integration: 'Connects to local replica for live debugging',
  },
  {
    id: 'TOOL-07', name: 'nova-lint',
    description: 'Motoko linter: enforce code style, detect anti-patterns, and suggest improvements',
    category: 'DEVELOPMENT',
    capabilities: ['style-enforcement', 'anti-pattern-detection', 'code-suggestions', 'auto-fix'],
    inputFormat: 'Motoko source files', outputFormat: 'lint report',
    integration: 'Configurable rules matching NOVA coding conventions',
  },
  {
    id: 'TOOL-08', name: 'nova-doc',
    description: 'Documentation generator: auto-generate API docs from Motoko source with diagrams',
    category: 'DEVELOPMENT',
    capabilities: ['api-documentation', 'type-extraction', 'diagram-generation', 'markdown-output'],
    inputFormat: 'Motoko modules', outputFormat: 'markdown documentation',
    integration: 'Extracts public query func signatures and generates SDK docs',
  },
  {
    id: 'TOOL-09', name: 'nova-bench',
    description: 'Performance benchmarking: measure cycles, memory, and instruction counts per function',
    category: 'DEVELOPMENT',
    capabilities: ['cycle-counting', 'memory-profiling', 'instruction-counting', 'regression-detection'],
    inputFormat: 'benchmark scripts', outputFormat: 'performance report',
    integration: 'Runs on local replica with cycle measurement',
  },
  {
    id: 'TOOL-10', name: 'nova-deps',
    description: 'Dependency analyzer: visualize module dependency graph and detect circular imports',
    category: 'DEVELOPMENT',
    capabilities: ['dependency-graphing', 'circular-detection', 'impact-analysis', 'module-sizing'],
    inputFormat: 'project root', outputFormat: 'dependency graph (SVG/JSON)',
    integration: 'Parses import statements across all .mo files',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MONITORING TOOLS (11-18)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'TOOL-11', name: 'nova-pulse',
    description: 'Real-time organism pulse monitor: heartbeat, coherence, and vital signs dashboard',
    category: 'MONITORING',
    capabilities: ['heartbeat-monitoring', 'coherence-tracking', 'vital-signs', 'alert-generation'],
    inputFormat: 'canister ID', outputFormat: 'live dashboard',
    integration: 'Polls getQuantumHeartbeatState and getOrganismHealthReport',
  },
  {
    id: 'TOOL-12', name: 'nova-spectrum',
    description: 'Frequency spectrum analyzer: visualize PHI nodes, Kuramoto coupling, and Hz distribution',
    category: 'MONITORING',
    capabilities: ['spectrum-visualization', 'phi-node-display', 'coupling-analysis', 'band-monitoring'],
    inputFormat: 'canister ID', outputFormat: 'frequency spectrum chart',
    integration: 'Polls getHzSpectrumState and getKuramotoState',
  },
  {
    id: 'TOOL-13', name: 'nova-swarm-viz',
    description: 'Swarm visualization: 3D drone fleet display with positions, phases, and neurochemistry',
    category: 'MONITORING',
    capabilities: ['3d-visualization', 'fleet-display', 'phase-coloring', 'neurochemical-overlay'],
    inputFormat: 'canister ID', outputFormat: '3D interactive scene',
    integration: 'Polls getSwarmSnapshot with WebGL rendering',
  },
  {
    id: 'TOOL-14', name: 'nova-neural-map',
    description: 'Neural region mapper: visualize 96 brain regions with connectivity and phase sync',
    category: 'MONITORING',
    capabilities: ['brain-mapping', 'connectivity-display', 'phase-visualization', 'region-health'],
    inputFormat: 'canister ID', outputFormat: 'neural map visualization',
    integration: 'Polls getBrainRegionStates and getNeuralCoreState',
  },
  {
    id: 'TOOL-15', name: 'nova-token-field',
    description: 'Token dimensional field visualizer: 21 scale dimensions × 36 use dimensions',
    category: 'MONITORING',
    capabilities: ['dimensional-visualization', 'scale-display', 'use-heatmap', 'phi-resonance-overlay'],
    inputFormat: 'canister ID', outputFormat: 'token field heatmap',
    integration: 'Polls getTokenOrganismStats and dimensional endpoints',
  },
  {
    id: 'TOOL-16', name: 'nova-defense-hud',
    description: 'Defense HUD: threat display, AEGIS status, counterforce operations, and war posture',
    category: 'MONITORING',
    capabilities: ['threat-display', 'aegis-status', 'counterforce-map', 'war-posture'],
    inputFormat: 'canister ID', outputFormat: 'defense heads-up-display',
    integration: 'Polls all defense endpoints for real-time tactical display',
  },
  {
    id: 'TOOL-17', name: 'nova-memory-palace',
    description: 'Memory palace 3D explorer: navigate spatial memory with salience overlay and lineage paths',
    category: 'MONITORING',
    capabilities: ['3d-palace-navigation', 'salience-overlay', 'lineage-visualization', 'memory-search'],
    inputFormat: 'canister ID', outputFormat: '3D memory palace scene',
    integration: 'Polls getMemoryTempleState with Three.js rendering',
  },
  {
    id: 'TOOL-18', name: 'nova-law-dashboard',
    description: 'Law compliance dashboard: all 60+ sovereignty laws with drift, violations, and trends',
    category: 'MONITORING',
    capabilities: ['law-display', 'drift-tracking', 'violation-alerts', 'trend-analysis'],
    inputFormat: 'canister ID', outputFormat: 'compliance dashboard',
    integration: 'Polls getLawComplianceState and getLawsSnapshot',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ANALYTICS TOOLS (19-26)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'TOOL-19', name: 'nova-coherence-tracker',
    description: 'Coherence tracking: organism-wide coherence history, trends, and anomaly detection',
    category: 'ANALYTICS',
    capabilities: ['coherence-history', 'trend-analysis', 'anomaly-detection', 'correlation-mapping'],
    inputFormat: 'canister ID + time range', outputFormat: 'coherence time series',
    integration: 'Aggregates coherence from all subsystems over time',
  },
  {
    id: 'TOOL-20', name: 'nova-entropy-analyzer',
    description: 'Entropy analysis: informational entropy, Lyapunov stability, and order parameter tracking',
    category: 'ANALYTICS',
    capabilities: ['entropy-analysis', 'stability-measurement', 'order-tracking', 'chaos-detection'],
    inputFormat: 'canister ID', outputFormat: 'entropy analysis report',
    integration: 'Polls getEntropyState and getLyapunovState for stability analysis',
  },
  {
    id: 'TOOL-21', name: 'nova-attractor-explorer',
    description: 'Attractor landscape explorer: visualize basins, fixed points, and strange attractors',
    category: 'ANALYTICS',
    capabilities: ['attractor-visualization', 'basin-mapping', 'trajectory-tracing', 'bifurcation-detection'],
    inputFormat: 'canister ID', outputFormat: 'attractor landscape map',
    integration: 'Polls getAttractorState for dynamical systems visualization',
  },
  {
    id: 'TOOL-22', name: 'nova-emergence-detector',
    description: 'Emergence detection: real-time monitoring for novel patterns, phase transitions, and symmetry breaking',
    category: 'ANALYTICS',
    capabilities: ['pattern-detection', 'phase-monitoring', 'symmetry-analysis', 'novelty-scoring'],
    inputFormat: 'canister ID', outputFormat: 'emergence event log',
    integration: 'Polls getEmergenceState and getEmergenceCognitiveOutputs',
  },
  {
    id: 'TOOL-23', name: 'nova-economic-modeler',
    description: 'Economic modeling: simulate token flows, yield curves, and compound growth scenarios',
    category: 'ANALYTICS',
    capabilities: ['flow-simulation', 'yield-modeling', 'compound-projection', 'scenario-analysis'],
    inputFormat: 'economic parameters', outputFormat: 'economic model projections',
    integration: 'Uses getEconomicState as baseline for simulation',
  },
  {
    id: 'TOOL-24', name: 'nova-neurochem-analyzer',
    description: 'Neurochemistry analyzer: 21 transmitter levels, receptor binding, and crosstalk visualization',
    category: 'ANALYTICS',
    capabilities: ['transmitter-analysis', 'binding-visualization', 'crosstalk-mapping', 'imbalance-detection'],
    inputFormat: 'canister ID', outputFormat: 'neurochemistry analysis',
    integration: 'Polls getNeurochemicalDiagnostics for deep chemical analysis',
  },
  {
    id: 'TOOL-25', name: 'nova-learning-tracker',
    description: 'Learning progress tracker: knowledge graphs, skill trees, and competency assessment',
    category: 'ANALYTICS',
    capabilities: ['knowledge-graphing', 'skill-tracking', 'competency-scoring', 'learning-curve-analysis'],
    inputFormat: 'canister ID', outputFormat: 'learning progress report',
    integration: 'Polls getLearningSystemState and getLearningFoundationState',
  },
  {
    id: 'TOOL-26', name: 'nova-compliance-reporter',
    description: 'Compliance report generator: SOC2, FedRAMP, HIPAA, ITAR automated compliance reports',
    category: 'ANALYTICS',
    capabilities: ['report-generation', 'control-mapping', 'evidence-collection', 'gap-analysis'],
    inputFormat: 'framework selection', outputFormat: 'compliance report (PDF/JSON)',
    integration: 'Uses getChimeraState compliance verification data',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATION TOOLS (27-34)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'TOOL-27', name: 'nova-bridge',
    description: 'Cross-canister bridge: connect NOVA organisms to other ICP canisters with typed interfaces',
    category: 'INTEGRATION',
    capabilities: ['cross-canister-calls', 'type-bridging', 'state-synchronization', 'error-handling'],
    inputFormat: 'canister IDs + interface', outputFormat: 'bridge connection',
    integration: 'Creates typed Motoko inter-canister call bridges',
  },
  {
    id: 'TOOL-28', name: 'nova-webhook',
    description: 'Webhook relay: forward organism events to external HTTP endpoints with filtering',
    category: 'INTEGRATION',
    capabilities: ['event-forwarding', 'filtering', 'retry-logic', 'authentication'],
    inputFormat: 'webhook config', outputFormat: 'HTTP POST events',
    integration: 'Monitors organism state changes and forwards filtered events',
  },
  {
    id: 'TOOL-29', name: 'nova-graphql',
    description: 'GraphQL gateway: expose organism state as GraphQL schema with subscriptions',
    category: 'INTEGRATION',
    capabilities: ['graphql-schema', 'query-resolution', 'subscriptions', 'caching'],
    inputFormat: 'canister ID', outputFormat: 'GraphQL endpoint',
    integration: 'Auto-generates GraphQL schema from Candid IDL',
  },
  {
    id: 'TOOL-30', name: 'nova-rest',
    description: 'REST API wrapper: expose organism endpoints as REST API with OpenAPI specification',
    category: 'INTEGRATION',
    capabilities: ['rest-wrapping', 'openapi-generation', 'authentication', 'rate-limiting'],
    inputFormat: 'canister ID', outputFormat: 'REST API + OpenAPI spec',
    integration: 'Wraps Candid query functions as REST endpoints',
  },
  {
    id: 'TOOL-31', name: 'nova-stream',
    description: 'Event streaming: Server-Sent Events stream of organism state changes',
    category: 'INTEGRATION',
    capabilities: ['sse-streaming', 'state-diff', 'event-filtering', 'reconnection'],
    inputFormat: 'canister ID + subscriptions', outputFormat: 'SSE event stream',
    integration: 'Polls organism endpoints and streams diffs as SSE events',
  },
  {
    id: 'TOOL-32', name: 'nova-sdk-gen',
    description: 'SDK generator: auto-generate TypeScript/Python/Rust client SDKs from Candid IDL',
    category: 'INTEGRATION',
    capabilities: ['typescript-generation', 'python-generation', 'rust-generation', 'type-mapping'],
    inputFormat: 'Candid IDL file', outputFormat: 'client SDK package',
    integration: 'Parses Candid and generates typed client libraries',
  },
  {
    id: 'TOOL-33', name: 'nova-embed',
    description: 'Embeddable widgets: drop-in organism status widgets for any web application',
    category: 'INTEGRATION',
    capabilities: ['widget-rendering', 'style-customization', 'real-time-updates', 'responsive-design'],
    inputFormat: 'widget config', outputFormat: 'embeddable HTML/JS',
    integration: 'Web components that poll organism state for display',
  },
  {
    id: 'TOOL-34', name: 'nova-mobile',
    description: 'Mobile bridge: React Native components for organism state display on iOS/Android',
    category: 'INTEGRATION',
    capabilities: ['react-native-components', 'ios-support', 'android-support', 'offline-cache'],
    inputFormat: 'component selection', outputFormat: 'React Native package',
    integration: 'React Native wrapper around organism query endpoints',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SECURITY TOOLS (35-40)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'TOOL-35', name: 'nova-audit',
    description: 'Security auditor: automated canister security audit with vulnerability detection',
    category: 'SECURITY',
    capabilities: ['vulnerability-scanning', 'access-control-audit', 'state-integrity', 'upgrade-safety'],
    inputFormat: 'canister source', outputFormat: 'security audit report',
    integration: 'Analyzes Motoko source for security anti-patterns',
  },
  {
    id: 'TOOL-36', name: 'nova-vault',
    description: 'Secret management: secure storage and rotation of canister keys and credentials',
    category: 'SECURITY',
    capabilities: ['key-storage', 'credential-rotation', 'access-logging', 'multi-sig-support'],
    inputFormat: 'credentials', outputFormat: 'encrypted vault',
    integration: 'Manages principal keys and controller access',
  },
  {
    id: 'TOOL-37', name: 'nova-firewall',
    description: 'Canister firewall: configure call filtering, rate limiting, and access policies',
    category: 'SECURITY',
    capabilities: ['call-filtering', 'rate-limiting', 'ip-blocking', 'policy-enforcement'],
    inputFormat: 'firewall rules', outputFormat: 'active firewall config',
    integration: 'Inter-canister proxy with policy enforcement',
  },
  {
    id: 'TOOL-38', name: 'nova-encrypt',
    description: 'Field-level encryption: encrypt specific state fields with sovereign key management',
    category: 'SECURITY',
    capabilities: ['field-encryption', 'key-management', 'access-control', 'audit-trail'],
    inputFormat: 'field selection + keys', outputFormat: 'encrypted state',
    integration: 'Wraps organism state fields with encryption layer',
  },
  {
    id: 'TOOL-39', name: 'nova-sentinel',
    description: 'Threat sentinel: real-time threat monitoring with alerting and incident response',
    category: 'SECURITY',
    capabilities: ['threat-monitoring', 'alert-routing', 'incident-response', 'forensic-logging'],
    inputFormat: 'sentinel config', outputFormat: 'threat alerts',
    integration: 'Monitors getAEGISState and getVETUSThreatState for threats',
  },
  {
    id: 'TOOL-40', name: 'nova-identity',
    description: 'Identity management: Internet Identity integration with NOVA sovereign identity',
    category: 'SECURITY',
    capabilities: ['ii-integration', 'principal-management', 'role-assignment', 'session-management'],
    inputFormat: 'identity config', outputFormat: 'identity session',
    integration: 'Bridges Internet Identity with organism sovereignty layer',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // DATA TOOLS (41-46)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'TOOL-41', name: 'nova-export',
    description: 'Data exporter: export organism state snapshots in JSON, CSV, Parquet, or Arrow format',
    category: 'DATA',
    capabilities: ['json-export', 'csv-export', 'parquet-export', 'arrow-export'],
    inputFormat: 'export config', outputFormat: 'data file (JSON/CSV/Parquet)',
    integration: 'Queries all endpoints and serializes to chosen format',
  },
  {
    id: 'TOOL-42', name: 'nova-import',
    description: 'Data importer: bulk load external data into organism memory temple with classification',
    category: 'DATA',
    capabilities: ['bulk-import', 'auto-classification', 'doctrine-filtering', 'validation'],
    inputFormat: 'data file + import config', outputFormat: 'imported memory records',
    integration: 'Feeds data through information feeding pipeline',
  },
  {
    id: 'TOOL-43', name: 'nova-sync',
    description: 'State synchronization: keep local replicas in sync with canister state',
    category: 'DATA',
    capabilities: ['state-sync', 'diff-detection', 'conflict-resolution', 'offline-support'],
    inputFormat: 'sync config', outputFormat: 'synchronized local state',
    integration: 'Periodic polling with incremental state updates',
  },
  {
    id: 'TOOL-44', name: 'nova-snapshot',
    description: 'State snapshot tool: capture complete organism state at a point in time',
    category: 'DATA',
    capabilities: ['full-snapshot', 'incremental-snapshot', 'compression', 'verification'],
    inputFormat: 'canister ID', outputFormat: 'state snapshot file',
    integration: 'Queries all 100 endpoints and packages into snapshot',
  },
  {
    id: 'TOOL-45', name: 'nova-replay',
    description: 'State replay: replay organism state history for debugging and analysis',
    category: 'DATA',
    capabilities: ['state-replay', 'time-travel', 'diff-visualization', 'event-replay'],
    inputFormat: 'snapshot files', outputFormat: 'replay visualization',
    integration: 'Replays sequence of snapshots in terminal or web UI',
  },
  {
    id: 'TOOL-46', name: 'nova-compare',
    description: 'State comparator: compare two organism snapshots and visualize differences',
    category: 'DATA',
    capabilities: ['state-diff', 'visual-comparison', 'regression-detection', 'change-report'],
    inputFormat: 'two snapshot files', outputFormat: 'comparison report',
    integration: 'Diffs all subsystem states between two snapshots',
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ECOSYSTEM TOOLS (47-50)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'TOOL-47', name: 'nova-marketplace',
    description: 'SDK marketplace client: browse, install, and manage NOVA SDKs and packages',
    category: 'ECOSYSTEM',
    capabilities: ['sdk-browsing', 'package-install', 'version-management', 'dependency-resolution'],
    inputFormat: 'marketplace commands', outputFormat: 'installed packages',
    integration: 'Connects to NOVA package registry for SDK distribution',
  },
  {
    id: 'TOOL-48', name: 'nova-playground',
    description: 'Interactive playground: experiment with organism APIs in a sandboxed environment',
    category: 'ECOSYSTEM',
    capabilities: ['sandbox-environment', 'interactive-queries', 'code-execution', 'result-visualization'],
    inputFormat: 'code snippets', outputFormat: 'execution results',
    integration: 'Runs against local replica with pre-loaded organism state',
  },
  {
    id: 'TOOL-49', name: 'nova-template-gallery',
    description: 'Template gallery: curated collection of organism templates for common use cases',
    category: 'ECOSYSTEM',
    capabilities: ['template-browsing', 'use-case-matching', 'one-click-deploy', 'customization'],
    inputFormat: 'template selection', outputFormat: 'deployed organism project',
    integration: 'Templates pre-configured with relevant SDKs and packages',
  },
  {
    id: 'TOOL-50', name: 'nova-community',
    description: 'Community hub: developer forums, documentation, tutorials, and organism showcase',
    category: 'ECOSYSTEM',
    capabilities: ['forum-access', 'tutorial-library', 'showcase-display', 'developer-profiles'],
    inputFormat: 'community commands', outputFormat: 'community content',
    integration: 'Connected to NOVA developer community and knowledge base',
  },
];

/** Get tool by ID */
export function getToolById(id: string): DeveloperTool | undefined {
  return DEVELOPER_TOOLS.find(t => t.id === id);
}

/** Get tools by category */
export function getToolsByCategory(category: string): DeveloperTool[] {
  return DEVELOPER_TOOLS.filter(t => t.category === category);
}

/** Tool categories */
export const TOOL_CATEGORIES = [
  'DEVELOPMENT', 'MONITORING', 'ANALYTICS', 'INTEGRATION', 'SECURITY', 'DATA', 'ECOSYSTEM',
];
