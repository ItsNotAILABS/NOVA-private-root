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

// The Actual Experiment
export { DroneSimulationWorld } from './DroneSimulationWorld';

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
