// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Terminal System Index
// 100 multimodal calls · 80 AI organism packages · 50 SDKs · 50 tools · 3 repos
// GO SYSTEM: 50 models · 30 MCP servers · 100 scrapers · 20 workflows
// ═══════════════════════════════════════════════════════════════════════════════

// Master hub
export { TerminalHub } from './TerminalHub';

// Individual terminals
export { DefenseTerminal } from './DefenseTerminal';
export { MemoryTerminal } from './MemoryTerminal';
export { GovernanceTerminal } from './GovernanceTerminal';
export { NeuralTerminal } from './NeuralTerminal';
export { QuantumTerminal } from './QuantumTerminal';
export { EconomicTerminal } from './EconomicTerminal';
export { SwarmTerminal } from './SwarmTerminal';
export { CognitiveTerminal } from './CognitiveTerminal';
export { SensorTerminal } from './SensorTerminal';
export { FrequencyTerminal } from './FrequencyTerminal';
export { SovereigntyTerminal } from './SovereigntyTerminal';
export { IntegrationTerminal } from './IntegrationTerminal';
export { PackagingTerminal } from './PackagingTerminal';
export { IntelligenceTerminal } from './IntelligenceTerminal';
export { MathTerminal } from './MathTerminal';

// Registries
export { MULTIMODAL_CALLS, getCallsByDomain, getCallById } from './calls';
export { MULTIMODAL_PACKAGES, getPackagesByDomain, getPackageById } from './packages';
export { SOVEREIGN_SDKS, getSDKById, getSDKsByDomain } from './sdks';
export { DEVELOPER_TOOLS, getToolById, getToolsByCategory, TOOL_CATEGORIES } from './tools';
export { PUBLIC_REPOS, getRepoByName } from './repos';

// GO SYSTEM — Enterprise AI Infrastructure Platform
export { GO_SYSTEM, getGoSystem } from './goSystem';
export { GO_MODELS, getGoModelById, getGoModelsByFamily, getGoModelsByDivision, GO_MODEL_FAMILIES } from './goModels';
export { GO_MCP_SERVERS, getMcpServerById, getMcpServersByDivision } from './goMcpServers';
export { GO_SCRAPERS, GO_WORKFLOWS, SCRAPER_CATEGORIES, getScraperById, getScrapersByCategory, getWorkflowById, getWorkflowsByType } from './goMarketplace';

// Types
export type {
  TerminalDomain,
  MultimodalCall,
  MultimodalPackage,
  TerminalMessage,
  TerminalTab,
  OrganismStatus,
  SovereignSDK,
  DeveloperTool,
  PublicRepo,
  GoDivision,
  GoSystemCompany,
  GoModel,
  GoMcpServer,
  GoMarketplaceItem,
  GoWorkflow,
} from './types';
export { TERMINAL_TABS } from './types';
