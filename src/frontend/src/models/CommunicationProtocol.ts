// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: CommunicationProtocol.ts — THE LANGUAGE BETWEEN ORGANISMS
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Defines the protocol for inter-organism communication.
// Frontend ↔ Backend, Module ↔ Module, Swarm ↔ Brain all speak this protocol.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// Import shared types from OrganismModels to avoid duplication
import type {
  AlertSeverity,
  CommandType as OrganismCommandType,
  Position3D,
} from './OrganismModels';

// Re-export imported types for convenience
export type { AlertSeverity, Position3D };

// ═══════════════════════════════════════════════════════════════════════════
// PROTOCOL VERSION & MAGIC NUMBERS
// ═══════════════════════════════════════════════════════════════════════════

/** Protocol version - increment on breaking changes */
export const PROTOCOL_VERSION = 1;

/** Magic number for protocol identification */
export const PROTOCOL_MAGIC = 0x4E4F5641; // "NOVA" in hex

/** Maximum message size in bytes */
export const MAX_MESSAGE_SIZE = 65536;

/** Default TTL for messages (in beats) */
export const DEFAULT_TTL = 100;

// ═══════════════════════════════════════════════════════════════════════════
// MESSAGE ENVELOPE — The outer wrapper for all communication
// ═══════════════════════════════════════════════════════════════════════════

/** The standard envelope that wraps all inter-organism messages */
export interface MessageEnvelope {
  /** Protocol version for compatibility checking */
  version: number;
  
  /** Unique message identifier */
  messageId: number;
  
  /** Correlation ID for request-response matching */
  correlationId?: number;
  
  /** Sender's principal */
  sender: string;
  
  /** Recipient principal(s) */
  recipients: string[];
  
  /** Message type classification */
  messageType: MessageType;
  
  /** The actual payload */
  payload: MessagePayload;
  
  /** Timestamp of creation */
  timestamp: number;
  
  /** Beat when created */
  beat: number;
  
  /** Priority (0.0 - 1.0, higher = more urgent) */
  priority: number;
  
  /** Time to live in beats */
  ttl: number;
  
  /** Does this require acknowledgment? */
  requiresAck: boolean;
  
  /** Is this encrypted? */
  encrypted: boolean;
  
  /** Signature for verification (optional) */
  signature?: Uint8Array;
}

// ═══════════════════════════════════════════════════════════════════════════
// MESSAGE TYPES — Classification of messages
// ═══════════════════════════════════════════════════════════════════════════

/** Primary message type classification */
export type MessageType =
  | 'Pulse'       // Heartbeat/pulse broadcast
  | 'Request'     // Request for information
  | 'Response'    // Response to a request
  | 'Alert'       // Alert/warning notification
  | 'Command'     // Command from higher authority
  | 'Sync'        // State synchronization
  | 'Learning'    // Learning/knowledge transfer
  | 'Ack'         // Acknowledgment
  | 'Nack'        // Negative acknowledgment
  | 'Broadcast'   // Broadcast to all (gossip)
  | 'Direct'      // Direct peer-to-peer
  | 'Error';      // Error notification

// ═══════════════════════════════════════════════════════════════════════════
// MESSAGE PAYLOADS — The content inside messages
// ═══════════════════════════════════════════════════════════════════════════

/** Payload variants - the actual data being transmitted */
export type MessagePayload =
  | { type: 'Pulse'; data: PulseData }
  | { type: 'Request'; data: RequestData }
  | { type: 'Response'; data: ResponseData }
  | { type: 'Alert'; data: AlertData }
  | { type: 'Command'; data: CommandData }
  | { type: 'Sync'; data: SyncData }
  | { type: 'Learning'; data: LearningData }
  | { type: 'Ack'; data: AckData }
  | { type: 'Error'; data: ErrorData }
  | { type: 'Raw'; data: Uint8Array }
  | { type: 'Structured'; data: Record<string, PayloadValue> };

/** Value types for structured payloads - using interface for recursive support */
export interface PayloadValueObject {
  [key: string]: PayloadValue;
}

export interface PayloadValueArray extends Array<PayloadValue> {}

/** Base payload value (non-recursive) */
export type PayloadValuePrimitive = null | boolean | number | string | Uint8Array;

/** Full payload value including recursive types */
export type PayloadValue = PayloadValuePrimitive | PayloadValueArray | PayloadValueObject;

// ═══════════════════════════════════════════════════════════════════════════
// SPECIFIC PAYLOAD TYPES
// ═══════════════════════════════════════════════════════════════════════════

/** Pulse (heartbeat) data */
export interface PulseData {
  beat: number;
  coherence: number;
  arousal: number;
  drift: number;
  emergence: number;
  energy: number;
  phase: number;
  kuramotoR: number;
  trustScore: number;
  anomalyScore: number;
}

/** Request data */
export interface RequestData {
  requestType: RequestType;
  params: Record<string, PayloadValue>;
  maxWait: number;           // Max beats to wait for response
  maxResults?: number;       // Max results to return
}

/** Request type enumeration */
export type RequestType =
  | 'GetState'               // Get current state
  | 'GetPulse'               // Get pulse only
  | 'GetNeurochemistry'      // Get neurochemical state
  | 'GetQuantum'             // Get quantum state
  | 'GetDrives'              // Get drive state
  | 'GetMemory'              // Get memory state
  | 'GetSwarm'               // Get swarm state
  | 'GetConfig'              // Get configuration
  | { type: 'Query'; name: string };  // Custom query by name

/** Response data */
export interface ResponseData {
  requestId: number;
  success: boolean;
  data: PayloadValue;
  executionTime: number;
}

/** Alert data */
export interface AlertData {
  severity: AlertSeverity;
  category: AlertCategory;
  title: string;
  description: string;
  source: string;
  location?: Position3D;
  timestamp: number;
  metadata: Record<string, PayloadValue>;
}

/** Alert category */
export type AlertCategory =
  | 'Health'
  | 'Security'
  | 'Performance'
  | 'Synchronization'
  | 'Energy'
  | 'Communication'
  | 'External'
  | 'Internal';

/** Command data */
export interface CommandData {
  commandType: ProtocolCommandType;
  authority: string;         // Who issued the command
  authorityLevel: number;    // Permission level required
  target?: string;           // Specific target (null = self)
  params: Record<string, PayloadValue>;
  deadline?: number;         // Must complete by
  mandatory: boolean;        // Can't be declined
}

/** Protocol command types (different from OrganismModels.CommandType) */
export type ProtocolCommandType =
  | 'Start'                  // Start processing
  | 'Stop'                   // Stop processing
  | 'Pause'                  // Pause processing
  | 'Resume'                 // Resume processing
  | 'Reset'                  // Reset to initial state
  | 'Sync'                   // Synchronize with target
  | 'Migrate'                // Move to different location
  | 'Configure'              // Change configuration
  | 'Report'                 // Generate status report
  | 'Emergency'              // Emergency action
  | { type: 'Execute'; action: string };  // Execute named action

/** State synchronization data */
export interface SyncData {
  syncType: SyncType;
  sourceVersion: number;     // Version number of source
  targetVersion?: number;    // Expected target version
  delta: boolean;            // Is this a delta sync?
  stateData: PayloadValue;   // The state to sync
  signature?: Uint8Array;    // For verification
}

/** Sync type */
export type SyncType =
  | 'Full'                   // Full state replacement
  | 'Delta'                  // Only changes
  | 'Checkpoint'             // Checkpoint marker
  | 'Request'                // Request for sync
  | 'Acknowledge';           // Sync acknowledged

/** Learning transfer data */
export interface LearningData {
  sessionId: number;
  learningType: LearningType;
  hebbianDeltas: number[];   // Weight changes
  patterns: PatternData[];   // Learned patterns
  predictionErrors: number;
  totalUpdates: number;
  confidence: number;
  sessionDuration: number;
}

/** Learning type */
export type LearningType =
  | 'Hebbian'                // Hebbian weight updates
  | 'Pattern'                // Pattern recognition
  | 'Prediction'             // Predictive model
  | 'Reward'                 // Reward-based
  | 'Imitation';             // Learned from observation

/** Pattern data */
export interface PatternData {
  signature: number;
  weights: number[];
  confidence: number;
  timestamp: number;
}

/** Acknowledgment data */
export interface AckData {
  messageId: number;         // ID of message being acknowledged
  received: boolean;         // Was it received?
  processed: boolean;        // Was it processed?
  status: string;            // Status message
}

/** Error data */
export interface ErrorData {
  code: ErrorCode;
  message: string;
  source: string;
  timestamp: number;
  retryable: boolean;
  details?: Record<string, PayloadValue>;
}

/** Error codes */
export type ErrorCode =
  | 'Unknown'
  | 'NotAuthorized'
  | 'NotFound'
  | 'InvalidState'
  | 'InvalidInput'
  | 'Timeout'
  | 'ResourceExhausted'
  | 'NetworkError'
  | 'InternalError'
  | 'ProtocolError'
  | 'VersionMismatch';

// ═══════════════════════════════════════════════════════════════════════════
// CHANNEL DEFINITIONS — Communication pathways
// ═══════════════════════════════════════════════════════════════════════════

/** Communication channel definition */
export interface Channel {
  id: number;
  name: string;
  channelType: ChannelType;
  participants: string[];
  bandwidth: number;         // Messages per beat
  latency: number;           // Beats of delay
  encrypted: boolean;
  quality: number;           // 0.0 - 1.0
}

/** Channel types */
export type ChannelType =
  | 'Broadcast'              // One-to-many
  | 'Direct'                 // One-to-one
  | 'Multicast'              // Many-to-many
  | 'Priority'               // High priority
  | 'Background';            // Low priority

// ═══════════════════════════════════════════════════════════════════════════
// ROUTING — How messages find their way
// ═══════════════════════════════════════════════════════════════════════════

/** Routing information */
export interface RoutingInfo {
  source: string;
  destination: string;
  hops: string[];            // Intermediate nodes
  maxHops: number;
  currentHop: number;
  routeQuality: number;
}

/** Route request */
export interface RouteRequest {
  destination: string;
  constraints: RouteConstraints;
}

/** Routing constraints */
export interface RouteConstraints {
  maxLatency: number;
  minQuality: number;
  encrypted: boolean;
  preferDirect: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTOCOL HANDLERS — Processing incoming messages
// ═══════════════════════════════════════════════════════════════════════════

/** Handler result type */
export type HandlerResult =
  | { type: 'Handled'; response?: MessageEnvelope }   // Successfully handled
  | { type: 'Forward'; targets: string[] }             // Forward to these principals
  | { type: 'Reject'; error: ErrorData }               // Rejected with error
  | { type: 'Defer'; beats: number };                  // Defer for N beats

// ═══════════════════════════════════════════════════════════════════════════
// HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════

let messageIdCounter = 0;

/** Generate a unique message ID */
export function generateMessageId(): number {
  return ++messageIdCounter;
}

/** Create a new message envelope */
export function createEnvelope(
  sender: string,
  recipients: string[],
  messageType: MessageType,
  payload: MessagePayload,
  beat: number
): MessageEnvelope {
  return {
    version: PROTOCOL_VERSION,
    messageId: generateMessageId(),
    sender,
    recipients,
    messageType,
    payload,
    timestamp: Date.now(),
    beat,
    priority: 0.5,
    ttl: DEFAULT_TTL,
    requiresAck: false,
    encrypted: false,
  };
}

/** Create a pulse payload */
export function createPulsePayload(
  beat: number,
  coherence: number,
  arousal: number,
  drift: number,
  emergence: number,
  energy: number,
  phase: number,
  kuramotoR: number
): MessagePayload {
  return {
    type: 'Pulse',
    data: {
      beat,
      coherence,
      arousal,
      drift,
      emergence,
      energy,
      phase,
      kuramotoR,
      trustScore: 1.0,
      anomalyScore: 0.0,
    },
  };
}

/** Create a request payload */
export function createRequestPayload(
  requestType: RequestType,
  maxWait: number,
  params: Record<string, PayloadValue> = {}
): MessagePayload {
  return {
    type: 'Request',
    data: {
      requestType,
      params,
      maxWait,
    },
  };
}

/** Create a response payload */
export function createResponsePayload(
  requestId: number,
  success: boolean,
  data: PayloadValue,
  executionTime: number
): MessagePayload {
  return {
    type: 'Response',
    data: {
      requestId,
      success,
      data,
      executionTime,
    },
  };
}

/** Create an alert payload */
export function createAlertPayload(
  severity: AlertSeverity,
  category: AlertCategory,
  title: string,
  description: string,
  source: string
): MessagePayload {
  return {
    type: 'Alert',
    data: {
      severity,
      category,
      title,
      description,
      source,
      timestamp: Date.now(),
      metadata: {},
    },
  };
}

/** Create an error payload */
export function createErrorPayload(
  code: ErrorCode,
  message: string,
  source: string,
  retryable: boolean
): MessagePayload {
  return {
    type: 'Error',
    data: {
      code,
      message,
      source,
      timestamp: Date.now(),
      retryable,
    },
  };
}

/** Create an acknowledgment payload */
export function createAckPayload(
  messageId: number,
  received: boolean,
  processed: boolean,
  status: string
): MessagePayload {
  return {
    type: 'Ack',
    data: {
      messageId,
      received,
      processed,
      status,
    },
  };
}

/** Create a sync payload */
export function createSyncPayload(
  syncType: SyncType,
  sourceVersion: number,
  stateData: PayloadValue,
  delta: boolean = false
): MessagePayload {
  return {
    type: 'Sync',
    data: {
      syncType,
      sourceVersion,
      delta,
      stateData,
    },
  };
}

/** Create a learning payload */
export function createLearningPayload(
  sessionId: number,
  learningType: LearningType,
  hebbianDeltas: number[],
  patterns: PatternData[],
  predictionErrors: number,
  confidence: number,
  sessionDuration: number
): MessagePayload {
  return {
    type: 'Learning',
    data: {
      sessionId,
      learningType,
      hebbianDeltas,
      patterns,
      predictionErrors,
      totalUpdates: hebbianDeltas.length,
      confidence,
      sessionDuration,
    },
  };
}

/** Create a command payload */
export function createCommandPayload(
  commandType: ProtocolCommandType,
  authority: string,
  authorityLevel: number,
  mandatory: boolean = false,
  params: Record<string, PayloadValue> = {}
): MessagePayload {
  return {
    type: 'Command',
    data: {
      commandType,
      authority,
      authorityLevel,
      mandatory,
      params,
    },
  };
}

/** Check if message has expired */
export function isExpired(envelope: MessageEnvelope, currentBeat: number): boolean {
  return currentBeat > envelope.beat + envelope.ttl;
}

/** Check protocol version compatibility */
export function isCompatible(version: number): boolean {
  return version === PROTOCOL_VERSION;
}

/** Get priority class from priority value */
export function getPriorityClass(priority: number): string {
  if (priority >= 0.9) return 'CRITICAL';
  if (priority >= 0.7) return 'HIGH';
  if (priority >= 0.4) return 'NORMAL';
  return 'LOW';
}

/** Get severity weight for sorting */
export function getSeverityWeight(severity: AlertSeverity): number {
  const weights: Record<AlertSeverity, number> = {
    Info: 0,
    Warning: 1,
    Critical: 2,
    Emergency: 3,
  };
  return weights[severity] ?? 0;
}

/** Serialize envelope for transmission */
export function serializeEnvelope(envelope: MessageEnvelope): string {
  return JSON.stringify(envelope);
}

/** Deserialize envelope from transmission */
export function deserializeEnvelope(data: string): MessageEnvelope | null {
  try {
    return JSON.parse(data) as MessageEnvelope;
  } catch {
    return null;
  }
}

/** Create a response envelope from a request */
export function createResponseEnvelope(
  request: MessageEnvelope,
  responsePayload: MessagePayload,
  beat: number
): MessageEnvelope {
  return {
    ...createEnvelope(
      request.recipients[0] ?? '',
      [request.sender],
      'Response',
      responsePayload,
      beat
    ),
    correlationId: request.messageId,
  };
}

/** Validate message envelope structure */
export function validateEnvelope(envelope: unknown): envelope is MessageEnvelope {
  if (typeof envelope !== 'object' || envelope === null) return false;
  const e = envelope as Partial<MessageEnvelope>;
  return (
    typeof e.version === 'number' &&
    typeof e.messageId === 'number' &&
    typeof e.sender === 'string' &&
    Array.isArray(e.recipients) &&
    typeof e.messageType === 'string' &&
    typeof e.payload === 'object' &&
    typeof e.timestamp === 'number' &&
    typeof e.beat === 'number' &&
    typeof e.priority === 'number' &&
    typeof e.ttl === 'number' &&
    typeof e.requiresAck === 'boolean' &&
    typeof e.encrypted === 'boolean'
  );
}
