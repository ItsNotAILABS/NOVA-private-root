// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Terminal System Index
// 40 multimodal calls · 30 AI organism packages · 15 sovereign terminals
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

// Types
export type {
  TerminalDomain,
  MultimodalCall,
  MultimodalPackage,
  TerminalMessage,
  TerminalTab,
  OrganismStatus,
} from './types';
export { TERMINAL_TABS } from './types';
