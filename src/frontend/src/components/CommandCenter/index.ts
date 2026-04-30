// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Command Center Module Index
// ═══════════════════════════════════════════════════════════════════════════════

// Main Command Center
export { OroCommandCenter, default as CommandCenter } from './OroCommandCenter';

// Sub-components
export { AgentRoster } from './AgentRoster';
export { AgentWorkspace } from './AgentWorkspace';
export { TaskManager } from './TaskManager';
export { ComputeTerminal } from './ComputeTerminal';
export { MissionBriefing } from './MissionBriefing';

// Labs — Internal AIs that help the organism function
export { EmergenceLab } from './EmergenceLab';
export { MathPhysicsLab } from './MathPhysicsLab';
export { NeuroCogLab } from './NeuroCogLab';
export { GRPELab } from './GRPELab';
export { InternalAnalysisLab } from './InternalAnalysisLab';
export { MemoryTempleLab } from './MemoryTempleLab';
export { ConstantFeedbackLab } from './ConstantFeedbackLab';

// The Actual Experiment — REAL PHYSICS, NOT SIMULATION
export { DroneRealWorld } from './DroneRealWorld';
// Legacy alias for backward compatibility
export { DroneRealWorld as DroneSimulationWorld } from './DroneRealWorld';

// Terminals — 2,000-Node Grid + Defense Command
export { PackagingLabTerminal } from './PackagingLabTerminal';
export { DefenseTerminal } from './DefenseTerminal';

// Types
export type {
  Agent,
  AgentRole,
  AgentStatus,
  Task,
  TaskStatus,
  TaskPriority,
  SubTask,
  TaskOutput,
  Artifact,
  Message,
  ComputeNode,
} from './OroCommandCenter';
