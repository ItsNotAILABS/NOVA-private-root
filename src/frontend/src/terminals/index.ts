// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Terminal System Index
// 100 multimodal calls · 80 AI organism packages · 50 SDKs · 50 tools · 3 repos
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
} from './types';
export { TERMINAL_TABS } from './types';
