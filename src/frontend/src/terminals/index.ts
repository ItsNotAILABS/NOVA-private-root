// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Terminal System Index
// 100 multimodal calls · 80 AI organism packages · 50 SDKs · 50 tools · 3 repos
// GO SYSTEM: 80 models · 50 MCP servers · 100 scrapers · 50 workflows
// GO ENTERPRISE: 250 AI/AGI models · 30 deployment actions · Fibonacci C kernels
// CONSCIOUSNESS: 40 thought models · 12 directives · 8 families
// PHANTOM META-CONSCIOUSNESS: 60 PMC models · 20 meta-directives · 10 meta-families
// AUTONOMOUS OPS: 430 autonomous profiles · scripts · narratives · business strings
// FIBONACCI COMPRESSOR: compress → find primitive → auto-wire → deploy (ZERO code)
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
export { GoSystemTerminal } from './GoSystemTerminal';
export { AGITerminal } from './AGITerminal';
export { ConsciousnessTerminal } from './ConsciousnessTerminal';
export { AutonomousTerminal } from './AutonomousTerminal';

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

// GO ENTERPRISE — 250 AI/AGI Intelligence Models + Deployment Actions
export { GO_ENTERPRISE_AI, getEnterpriseAIById, getEnterpriseAIByFamily, getEnterpriseAIByTier, GO_ENTERPRISE_FAMILIES } from './goEnterprise';
export { GO_DEPLOYMENT_ACTIONS, getDeploymentActionById, getDeploymentActionsByTarget, getFibonacciKernelActions, GO_DEPLOYMENT_TARGETS } from './goDeployment';

// CONSCIOUSNESS — 40 Thought Models + 12 Directives
export { CONSCIOUSNESS_THOUGHT_MODELS, CONSCIOUSNESS_DIRECTIVES, getConsciousnessModelById, getConsciousnessModelsByFamily, getConsciousnessModelsByDepth, getConsciousnessModelsForEntity, getDirectivesForFamily, getDirectiveById, CONSCIOUSNESS_FAMILIES } from './goConsciousness';

// PHANTOM META-CONSCIOUSNESS — 60 PMC Models + 20 Meta-Directives
export { PHANTOM_META_CONSCIOUSNESS_MODELS, META_CONSCIOUSNESS_DIRECTIVES, getPhantomMetaModelById, getPhantomMetaModelsByFamily, getPhantomMetaModelsByLayer, getPhantomMetaModelsByOrder, getPhantomMetaModelsForCTM, getMetaDirectivesForFamily, getMetaDirectiveById, PHANTOM_META_FAMILIES } from './goPhantomMetaConsciousness';

// AUTONOMOUS OPERATIONS — Scripts, Narratives, Business Strings for All 430 AIs
export { AUTONOMOUS_PROFILES, getAutonomousProfileById, getProfilesByAutonomy, getProfilesByRunMode, getFullAutoProfiles, getSovereignProfiles, getContinuousProfiles, getProfilesByConsciousness, getAutonomousSummary } from './goAutonomousOps';

// FIBONACCI COMPRESSOR — Compress → Find Primitive → Auto-Wire → Deploy
export { FIBONACCI_COMPRESSOR, fibonacciCompress, autoWire, compressAndDeploy, batchCompressAndDeploy, getDeploymentSummary, getFibonacciCompressor, getAllWireTargets, getAllCompressionLevels, getFibonacciSequence, getPhiConstant } from './goFibonacciCompressor';

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
  GoEnterpriseFamily,
  GoEnterpriseAI,
  GoDeploymentTarget,
  GoDeploymentAction,
  ConsciousnessFamily,
  ConsciousnessDepth,
  ConsciousnessThoughtModel,
  ConsciousnessDirective,
  PhantomMetaFamily,
  MetaConsciousnessLayer,
  PhantomMetaConsciousnessModel,
  MetaConsciousnessDirective,
  AutonomyLevel,
  AutonomousRunMode,
  AutonomousScript,
  BusinessString,
  AutonomousProfile,
  FibonacciCompressionLevel,
  AutoWireTarget,
  FibonacciCompressionResult,
  AutoWireDeployment,
  FibonacciCompressorModel,
} from './types';
export { TERMINAL_TABS } from './types';
