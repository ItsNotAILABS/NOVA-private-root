// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — ORGANISM MODELS INDEX
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Central export point for all organism models
// Copyright © 2024-2026 Alfredo Medina Hernandez
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// Re-export everything from OrganismModels
export * from './OrganismModels';

// Re-export everything from CommunicationProtocol  
export * from './CommunicationProtocol';

// Re-export everything from ModelTransformers
export * from './ModelTransformers';

// Convenience re-exports of commonly used types
export type {
  // Identity
  OrganismId,
  OrganismType,
  LifecyclePhase,
  
  // State
  OrganismPulse,
  OrganismHealth,
  OrganismState,
  
  // Neurochemistry
  NeurochemicalState,
  NeurochemicalDelta,
  ExtendedNeurochemicalState,
  
  // Quantum
  QuantumChannels,
  QuantumState,
  QuantumOpResult,
  
  // Drives
  DriveState,
  DriveType,
  GoalState,
  GoalTarget,
  
  // Memory
  MemoryType,
  MemoryUnit,
  MemoryContent,
  MemoryState,
  
  // Perception
  SensorType,
  SensorReading,
  Perception,
  
  // Action
  ActionType,
  ActionResult,
  SideEffect,
  ModificationType,
  CreationTemplate,
  
  // Communication
  SignalType,
  SignalContent,
  Message,
  QueryPayload,
  ResponsePayload,
  AlertPayload,
  LearningPayload,
  CommandPayload,
  AlertSeverity,
  ThreatType,
  CommandType,
  
  // Spatial
  Position3D,
  Velocity3D,
  Region3D,
  SpatialState,
  
  // Swarm
  DroneClass,
  DroneState,
  SwarmState,
  SquadronState,
  MissionState,
  MissionStatus,
  
  // Economic
  EconomicState,
  TransactionType,
  TokenType,
  Transaction,
  
  // Events
  EventType,
  LifecycleEvent,
  StateEvent,
  CommunicationEvent,
  ActionEvent,
  SecurityEvent,
  EconomicEvent,
  Event,
  AuditEntry,
  
  // Config
  OrganismConfig,
  FeatureFlag,
  ModuleConfig,
  
  // Errors
  Result,
  OrganismError,
  OperationResponse,
} from './OrganismModels';

export type {
  // Protocol
  MessageEnvelope,
  MessageType,
  MessagePayload,
  PayloadValue,
  
  // Payloads
  PulseData,
  RequestData,
  RequestType,
  ResponseData,
  AlertData,
  AlertCategory,
  CommandData,
  SyncData,
  SyncType,
  LearningData,
  LearningType,
  PatternData,
  AckData,
  ErrorData,
  ErrorCode,
  
  // Channels
  Channel,
  ChannelType,
  
  // Routing
  RoutingInfo,
  RouteRequest,
  RouteConstraints,
  
  // Handlers
  HandlerResult,
} from './CommunicationProtocol';

// Re-export helper functions
export {
  // From OrganismModels
  defaultNeurochemistry,
  defaultQuantumState,
  defaultDriveState,
  defaultHealth,
  applySovereignFloor,
  clamp,
  wrapPhase,
  phaseDiff,
  computeKuramotoR,
  emptyPulse,
  emptyOrganismState,
  isOrganismType,
  isLifecyclePhase,
  isDroneClass,
  isOrganismPulse,
  serializePulse,
  deserializePulse,
  serializeNeurochemistry,
  deserializeNeurochemistry,
  serializeQuantumState,
  deserializeQuantumState,
  
  // From CommunicationProtocol
  generateMessageId,
  createEnvelope,
  createPulsePayload,
  createRequestPayload,
  createResponsePayload,
  createAlertPayload,
  createErrorPayload,
  createAckPayload,
  createSyncPayload,
  createLearningPayload,
  createCommandPayload,
  isExpired,
  isCompatible,
  getPriorityClass,
  getSeverityWeight,
  serializeEnvelope,
  deserializeEnvelope,
  createResponseEnvelope,
  validateEnvelope,
  
  // Constants
  PHI,
  PHI_INV,
  TAU,
  PI,
  SCHUMANN_HZ,
  SOVEREIGN_FLOOR,
  KURAMOTO_K,
  HEARTBEAT_MS,
  PROTOCOL_VERSION,
  PROTOCOL_MAGIC,
  MAX_MESSAGE_SIZE,
  DEFAULT_TTL,
} from './OrganismModels';
