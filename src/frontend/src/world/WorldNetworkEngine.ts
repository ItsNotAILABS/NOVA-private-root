// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldNetworkEngine — Multiplayer & Distributed Simulation
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD NETWORK ENGINE — CONNECTED REALITY                    ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  Complete networking layer for multiplayer world simulation:                   ║
// ║    • State synchronization                                                     ║
// ║    • Authority and ownership                                                   ║
// ║    • Lag compensation                                                          ║
// ║    • Interest management                                                       ║
// ║    • Message serialization                                                     ║
// ║    • Connection management                                                     ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type { Vec3, Quaternion } from './WorldPhysicsEngine';
import { vec3 } from './WorldPhysicsEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// NETWORK TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type ConnectionState =
  | 'Disconnected'
  | 'Connecting'
  | 'Connected'
  | 'Reconnecting'
  | 'Failed';

export type AuthorityMode =
  | 'Server'        // Server has full authority
  | 'Client'        // Client has authority (owner)
  | 'Distributed'   // Authority shared based on proximity
  | 'Predicted';    // Client-side prediction with server reconciliation

export type ReliabilityMode =
  | 'Unreliable'    // Fire and forget (UDP-like)
  | 'Reliable'      // Guaranteed delivery
  | 'ReliableOrdered'; // Guaranteed delivery in order

export interface NetworkIdentity {
  networkId: number;
  ownerId: string;
  authorityMode: AuthorityMode;
  isLocalPlayer: boolean;
  spawnTime: number;
}

export interface NetworkPeer {
  id: string;
  displayName: string;
  state: ConnectionState;
  latency: number;           // ms
  jitter: number;            // ms
  packetLoss: number;        // 0-1
  lastHeartbeat: number;
  isHost: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// MESSAGES
// ═══════════════════════════════════════════════════════════════════════════════

export type MessageType =
  | 'Handshake'
  | 'Heartbeat'
  | 'StateSync'
  | 'StateDelta'
  | 'RPC'
  | 'Spawn'
  | 'Despawn'
  | 'OwnershipChange'
  | 'Event'
  | 'Chat'
  | 'Voice';

export interface NetworkMessage {
  type: MessageType;
  senderId: string;
  timestamp: number;
  sequence: number;
  reliability: ReliabilityMode;
  channelId: number;
  payload: unknown;
}

export interface HandshakePayload {
  version: string;
  playerName: string;
  authToken: string | null;
}

export interface StateSyncPayload {
  networkId: number;
  position: Vec3;
  rotation: Quaternion;
  velocity: Vec3;
  angularVelocity: Vec3;
  customState: Record<string, unknown>;
  timestamp: number;
}

export interface StateDeltaPayload {
  networkId: number;
  deltaFields: string[];
  deltaValues: unknown[];
  baseSequence: number;
  timestamp: number;
}

export interface RPCPayload {
  targetNetworkId: number | null;  // null = global
  methodName: string;
  arguments: unknown[];
  mode: 'ServerOnly' | 'ClientOnly' | 'All';
}

export interface SpawnPayload {
  networkId: number;
  prefabId: string;
  position: Vec3;
  rotation: Quaternion;
  ownerId: string;
  initialState: Record<string, unknown>;
}

export interface DespawnPayload {
  networkId: number;
  reason: 'Destroyed' | 'OutOfScope' | 'Disconnected';
}

export interface EventPayload {
  eventType: string;
  eventData: unknown;
  scope: 'Global' | 'Room' | 'Area';
  position?: Vec3;
  radius?: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATE SYNCHRONIZATION
// ═══════════════════════════════════════════════════════════════════════════════

export interface SyncedEntity {
  networkId: number;
  identity: NetworkIdentity;
  
  // Transform
  position: Vec3;
  rotation: Quaternion;
  velocity: Vec3;
  angularVelocity: Vec3;
  
  // Interpolation
  lastUpdateTime: number;
  previousPosition: Vec3;
  previousRotation: Quaternion;
  targetPosition: Vec3;
  targetRotation: Quaternion;
  
  // Custom state
  syncedState: Map<string, unknown>;
  dirtyFields: Set<string>;
  
  // Prediction
  inputBuffer: NetworkInput[];
  stateHistory: StateSnapshot[];
}

export interface NetworkInput {
  sequence: number;
  timestamp: number;
  movement: Vec3;
  rotation: Quaternion;
  actions: string[];
  acknowledged: boolean;
}

export interface StateSnapshot {
  sequence: number;
  timestamp: number;
  position: Vec3;
  rotation: Quaternion;
  velocity: Vec3;
  state: Record<string, unknown>;
}

export interface InterpolationSettings {
  enabled: boolean;
  delay: number;          // ms
  maxExtrapolation: number; // ms
  positionThreshold: number; // snap if larger
  rotationThreshold: number; // snap if larger (radians)
}

export const DEFAULT_INTERPOLATION: InterpolationSettings = {
  enabled: true,
  delay: 100,
  maxExtrapolation: 200,
  positionThreshold: 5,
  rotationThreshold: Math.PI / 4,
};

// ═══════════════════════════════════════════════════════════════════════════════
// INTEREST MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════

export interface InterestArea {
  id: string;
  center: Vec3;
  radius: number;
  priority: number;
}

export interface RelevanceSettings {
  maxEntitiesPerUpdate: number;
  updateInterval: number;   // ms
  baseRelevanceRadius: number;
  priorityMultipliers: Record<string, number>;
}

export const DEFAULT_RELEVANCE: RelevanceSettings = {
  maxEntitiesPerUpdate: 50,
  updateInterval: 50,
  baseRelevanceRadius: 500,
  priorityMultipliers: {
    player: 2.0,
    hostile: 1.5,
    vehicle: 1.2,
    item: 0.8,
    effect: 0.5,
  },
};

export function calculateRelevance(
  observer: Vec3,
  entity: SyncedEntity,
  settings: RelevanceSettings
): number {
  const distance = vec3.distance(observer, entity.position);
  
  if (distance > settings.baseRelevanceRadius * 2) {
    return 0;
  }
  
  let relevance = 1 - (distance / settings.baseRelevanceRadius);
  relevance = Math.max(0, relevance);
  
  // Apply priority multipliers (would need entity type info)
  // relevance *= settings.priorityMultipliers[entityType] || 1;
  
  return relevance;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAG COMPENSATION
// ═══════════════════════════════════════════════════════════════════════════════

export interface LagCompensationSettings {
  enabled: boolean;
  maxRewindTime: number;   // ms
  historyLength: number;   // snapshots
  hitboxExpansion: number; // multiplier
}

export const DEFAULT_LAG_COMPENSATION: LagCompensationSettings = {
  enabled: true,
  maxRewindTime: 200,
  historyLength: 20,
  hitboxExpansion: 1.1,
};

export function rewindToTime(
  entity: SyncedEntity,
  targetTime: number
): StateSnapshot | null {
  // Find closest snapshots
  let before: StateSnapshot | null = null;
  let after: StateSnapshot | null = null;
  
  for (const snapshot of entity.stateHistory) {
    if (snapshot.timestamp <= targetTime) {
      if (!before || snapshot.timestamp > before.timestamp) {
        before = snapshot;
      }
    }
    if (snapshot.timestamp >= targetTime) {
      if (!after || snapshot.timestamp < after.timestamp) {
        after = snapshot;
      }
    }
  }
  
  if (!before) return after;
  if (!after) return before;
  
  // Interpolate between snapshots
  const t = (targetTime - before.timestamp) / (after.timestamp - before.timestamp);
  
  return {
    sequence: before.sequence,
    timestamp: targetTime,
    position: vec3.lerp(before.position, after.position, t),
    rotation: before.rotation, // Simplified, should slerp
    velocity: vec3.lerp(before.velocity, after.velocity, t),
    state: { ...before.state },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// CLIENT-SIDE PREDICTION
// ═══════════════════════════════════════════════════════════════════════════════

export interface PredictionSettings {
  enabled: boolean;
  maxPredictedFrames: number;
  reconciliationThreshold: number; // position diff for correction
  smoothCorrection: boolean;
  correctionSpeed: number;
}

export const DEFAULT_PREDICTION: PredictionSettings = {
  enabled: true,
  maxPredictedFrames: 10,
  reconciliationThreshold: 0.1,
  smoothCorrection: true,
  correctionSpeed: 10,
};

export function applyPrediction(
  entity: SyncedEntity,
  input: NetworkInput,
  dt: number
): void {
  // Simplified movement prediction
  const moveSpeed = 10;
  const movement = vec3.scale(input.movement, moveSpeed * dt);
  entity.position = vec3.add(entity.position, movement);
  
  // Store in buffer
  entity.inputBuffer.push(input);
  if (entity.inputBuffer.length > 60) {
    entity.inputBuffer.shift();
  }
}

export function reconcileState(
  entity: SyncedEntity,
  serverState: StateSyncPayload,
  settings: PredictionSettings
): void {
  const posDiff = vec3.distance(entity.position, serverState.position);
  
  if (posDiff > settings.reconciliationThreshold) {
    if (settings.smoothCorrection) {
      // Smooth correction over time
      entity.targetPosition = serverState.position;
    } else {
      // Snap to server position
      entity.position = serverState.position;
    }
    
    // Re-apply unacknowledged inputs
    for (const input of entity.inputBuffer) {
      if (!input.acknowledged) {
        // Re-simulate input
        const dt = 1 / 60; // Assuming 60fps
        applyPrediction(entity, input, dt);
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SERIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

export interface SerializationBuffer {
  data: Uint8Array;
  position: number;
}

export function createBuffer(size: number = 1024): SerializationBuffer {
  return {
    data: new Uint8Array(size),
    position: 0,
  };
}

export function writeUint8(buffer: SerializationBuffer, value: number): void {
  buffer.data[buffer.position++] = value & 0xFF;
}

export function writeUint16(buffer: SerializationBuffer, value: number): void {
  buffer.data[buffer.position++] = value & 0xFF;
  buffer.data[buffer.position++] = (value >> 8) & 0xFF;
}

export function writeUint32(buffer: SerializationBuffer, value: number): void {
  buffer.data[buffer.position++] = value & 0xFF;
  buffer.data[buffer.position++] = (value >> 8) & 0xFF;
  buffer.data[buffer.position++] = (value >> 16) & 0xFF;
  buffer.data[buffer.position++] = (value >> 24) & 0xFF;
}

export function writeFloat32(buffer: SerializationBuffer, value: number): void {
  const view = new DataView(buffer.data.buffer);
  view.setFloat32(buffer.position, value, true);
  buffer.position += 4;
}

export function writeVec3(buffer: SerializationBuffer, v: Vec3): void {
  writeFloat32(buffer, v.x);
  writeFloat32(buffer, v.y);
  writeFloat32(buffer, v.z);
}

export function writeString(buffer: SerializationBuffer, str: string): void {
  const encoded = new TextEncoder().encode(str);
  writeUint16(buffer, encoded.length);
  buffer.data.set(encoded, buffer.position);
  buffer.position += encoded.length;
}

export function readUint8(buffer: SerializationBuffer): number {
  return buffer.data[buffer.position++];
}

export function readUint16(buffer: SerializationBuffer): number {
  const value = buffer.data[buffer.position] | (buffer.data[buffer.position + 1] << 8);
  buffer.position += 2;
  return value;
}

export function readUint32(buffer: SerializationBuffer): number {
  const value = buffer.data[buffer.position] |
                (buffer.data[buffer.position + 1] << 8) |
                (buffer.data[buffer.position + 2] << 16) |
                (buffer.data[buffer.position + 3] << 24);
  buffer.position += 4;
  return value >>> 0; // Convert to unsigned
}

export function readFloat32(buffer: SerializationBuffer): number {
  const view = new DataView(buffer.data.buffer);
  const value = view.getFloat32(buffer.position, true);
  buffer.position += 4;
  return value;
}

export function readVec3(buffer: SerializationBuffer): Vec3 {
  return {
    x: readFloat32(buffer),
    y: readFloat32(buffer),
    z: readFloat32(buffer),
  };
}

export function readString(buffer: SerializationBuffer): string {
  const length = readUint16(buffer);
  const encoded = buffer.data.slice(buffer.position, buffer.position + length);
  buffer.position += length;
  return new TextDecoder().decode(encoded);
}

// ═══════════════════════════════════════════════════════════════════════════════
// DELTA COMPRESSION
// ═══════════════════════════════════════════════════════════════════════════════

export function createDelta(
  previous: Record<string, unknown>,
  current: Record<string, unknown>
): { fields: string[]; values: unknown[] } {
  const fields: string[] = [];
  const values: unknown[] = [];
  
  for (const [key, value] of Object.entries(current)) {
    if (JSON.stringify(previous[key]) !== JSON.stringify(value)) {
      fields.push(key);
      values.push(value);
    }
  }
  
  return { fields, values };
}

export function applyDelta(
  state: Record<string, unknown>,
  fields: string[],
  values: unknown[]
): Record<string, unknown> {
  const newState = { ...state };
  
  for (let i = 0; i < fields.length; i++) {
    newState[fields[i]] = values[i];
  }
  
  return newState;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ROOM / LOBBY
// ═══════════════════════════════════════════════════════════════════════════════

export interface Room {
  id: string;
  name: string;
  hostId: string;
  maxPlayers: number;
  players: string[];
  state: 'Lobby' | 'Starting' | 'InGame' | 'Ended';
  settings: Record<string, unknown>;
  createdAt: number;
  isPrivate: boolean;
  password: string | null;
}

export interface RoomListEntry {
  id: string;
  name: string;
  hostName: string;
  playerCount: number;
  maxPlayers: number;
  state: Room['state'];
  ping: number;
  isPrivate: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// NETWORK ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export class WorldNetworkEngine {
  // Connection
  private localPeerId: string;
  private connectionState: ConnectionState = 'Disconnected';
  private peers: Map<string, NetworkPeer> = new Map();
  private isHost: boolean = false;
  
  // Entities
  private syncedEntities: Map<number, SyncedEntity> = new Map();
  private nextNetworkId: number = 1;
  private localEntityIds: Set<number> = new Set();
  
  // Message handling
  private messageSequence: number = 0;
  private receivedSequences: Map<string, number> = new Map();
  private pendingReliable: Map<number, NetworkMessage> = new Map();
  private messageHandlers: Map<MessageType, ((msg: NetworkMessage) => void)[]> = new Map();
  
  // Interest management
  private interestAreas: Map<string, InterestArea> = new Map();
  private relevanceSettings: RelevanceSettings = DEFAULT_RELEVANCE;
  
  // Lag compensation
  private lagCompSettings: LagCompensationSettings = DEFAULT_LAG_COMPENSATION;
  
  // Prediction
  private predictionSettings: PredictionSettings = DEFAULT_PREDICTION;
  private interpolationSettings: InterpolationSettings = DEFAULT_INTERPOLATION;
  
  // Room
  private currentRoom: Room | null = null;
  
  // Stats
  private stats = {
    bytesSent: 0,
    bytesReceived: 0,
    messagesSent: 0,
    messagesReceived: 0,
    packetsLost: 0,
  };
  
  // Time
  private serverTime: number = 0;
  private localTime: number = 0;
  private timeOffset: number = 0;
  private lastUpdateTime: number = 0;
  
  constructor() {
    this.localPeerId = `peer_${Date.now().toString(36)}_${Math.random().toString(36).substr(2, 9)}`;
    
    // Register default handlers
    this.registerHandler('StateSync', this.handleStateSync.bind(this));
    this.registerHandler('StateDelta', this.handleStateDelta.bind(this));
    this.registerHandler('Spawn', this.handleSpawn.bind(this));
    this.registerHandler('Despawn', this.handleDespawn.bind(this));
    this.registerHandler('RPC', this.handleRPC.bind(this));
  }
  
  // Connection
  getLocalPeerId(): string {
    return this.localPeerId;
  }
  
  getConnectionState(): ConnectionState {
    return this.connectionState;
  }
  
  isConnected(): boolean {
    return this.connectionState === 'Connected';
  }
  
  isHosting(): boolean {
    return this.isHost;
  }
  
  connect(serverUrl: string, authToken?: string): void {
    this.connectionState = 'Connecting';
    
    // Simulate connection (would use WebSocket/WebRTC)
    setTimeout(() => {
      this.connectionState = 'Connected';
      this.sendHandshake(authToken);
    }, 100);
  }
  
  disconnect(): void {
    this.connectionState = 'Disconnected';
    this.peers.clear();
    this.currentRoom = null;
  }
  
  private sendHandshake(authToken?: string): void {
    const payload: HandshakePayload = {
      version: '1.0.0',
      playerName: 'Player',
      authToken: authToken || null,
    };
    
    this.sendMessage('Handshake', payload, 'Reliable');
  }
  
  // Peers
  getPeer(id: string): NetworkPeer | undefined {
    return this.peers.get(id);
  }
  
  getAllPeers(): NetworkPeer[] {
    return Array.from(this.peers.values());
  }
  
  getLocalPeerLatency(): number {
    return 0; // Local player has no latency to self
  }
  
  // Entities
  spawnNetworkedEntity(
    prefabId: string,
    position: Vec3,
    rotation: Quaternion,
    initialState?: Record<string, unknown>
  ): number {
    const networkId = this.nextNetworkId++;
    
    const entity: SyncedEntity = {
      networkId,
      identity: {
        networkId,
        ownerId: this.localPeerId,
        authorityMode: 'Client',
        isLocalPlayer: true,
        spawnTime: this.localTime,
      },
      position,
      rotation,
      velocity: vec3.zero(),
      angularVelocity: vec3.zero(),
      lastUpdateTime: this.localTime,
      previousPosition: position,
      previousRotation: rotation,
      targetPosition: position,
      targetRotation: rotation,
      syncedState: new Map(Object.entries(initialState || {})),
      dirtyFields: new Set(),
      inputBuffer: [],
      stateHistory: [],
    };
    
    this.syncedEntities.set(networkId, entity);
    this.localEntityIds.add(networkId);
    
    // Broadcast spawn
    const payload: SpawnPayload = {
      networkId,
      prefabId,
      position,
      rotation,
      ownerId: this.localPeerId,
      initialState: initialState || {},
    };
    
    this.sendMessage('Spawn', payload, 'Reliable');
    
    return networkId;
  }
  
  despawnNetworkedEntity(networkId: number): void {
    const entity = this.syncedEntities.get(networkId);
    if (!entity || entity.identity.ownerId !== this.localPeerId) return;
    
    this.syncedEntities.delete(networkId);
    this.localEntityIds.delete(networkId);
    
    const payload: DespawnPayload = {
      networkId,
      reason: 'Destroyed',
    };
    
    this.sendMessage('Despawn', payload, 'Reliable');
  }
  
  getNetworkedEntity(networkId: number): SyncedEntity | undefined {
    return this.syncedEntities.get(networkId);
  }
  
  getAllNetworkedEntities(): SyncedEntity[] {
    return Array.from(this.syncedEntities.values());
  }
  
  // State sync
  updateEntityState(
    networkId: number,
    position: Vec3,
    rotation: Quaternion,
    velocity: Vec3,
    customState?: Record<string, unknown>
  ): void {
    const entity = this.syncedEntities.get(networkId);
    if (!entity || !this.localEntityIds.has(networkId)) return;
    
    entity.previousPosition = entity.position;
    entity.previousRotation = entity.rotation;
    entity.position = position;
    entity.rotation = rotation;
    entity.velocity = velocity;
    entity.lastUpdateTime = this.localTime;
    
    if (customState) {
      for (const [key, value] of Object.entries(customState)) {
        entity.syncedState.set(key, value);
        entity.dirtyFields.add(key);
      }
    }
    
    // Store snapshot for lag compensation
    entity.stateHistory.push({
      sequence: this.messageSequence,
      timestamp: this.localTime,
      position,
      rotation,
      velocity,
      state: Object.fromEntries(entity.syncedState),
    });
    
    if (entity.stateHistory.length > this.lagCompSettings.historyLength) {
      entity.stateHistory.shift();
    }
  }
  
  // Messaging
  sendMessage(
    type: MessageType,
    payload: unknown,
    reliability: ReliabilityMode = 'Unreliable',
    channelId: number = 0
  ): void {
    const message: NetworkMessage = {
      type,
      senderId: this.localPeerId,
      timestamp: this.localTime,
      sequence: ++this.messageSequence,
      reliability,
      channelId,
      payload,
    };
    
    if (reliability !== 'Unreliable') {
      this.pendingReliable.set(message.sequence, message);
    }
    
    this.stats.messagesSent++;
    // Would actually send over network here
  }
  
  private receiveMessage(message: NetworkMessage): void {
    this.stats.messagesReceived++;
    
    // Check for duplicate
    const lastSeq = this.receivedSequences.get(message.senderId) || 0;
    if (message.reliability === 'ReliableOrdered' && message.sequence <= lastSeq) {
      return; // Already processed
    }
    this.receivedSequences.set(message.senderId, message.sequence);
    
    // Dispatch to handlers
    const handlers = this.messageHandlers.get(message.type);
    if (handlers) {
      for (const handler of handlers) {
        handler(message);
      }
    }
  }
  
  registerHandler(type: MessageType, handler: (msg: NetworkMessage) => void): void {
    if (!this.messageHandlers.has(type)) {
      this.messageHandlers.set(type, []);
    }
    this.messageHandlers.get(type)!.push(handler);
  }
  
  // RPC
  callRPC(
    methodName: string,
    args: unknown[],
    mode: 'ServerOnly' | 'ClientOnly' | 'All' = 'All',
    targetNetworkId?: number
  ): void {
    const payload: RPCPayload = {
      targetNetworkId: targetNetworkId ?? null,
      methodName,
      arguments: args,
      mode,
    };
    
    this.sendMessage('RPC', payload, 'Reliable');
  }
  
  // Event broadcast
  broadcastEvent(
    eventType: string,
    eventData: unknown,
    scope: 'Global' | 'Room' | 'Area' = 'Room',
    position?: Vec3,
    radius?: number
  ): void {
    const payload: EventPayload = {
      eventType,
      eventData,
      scope,
      position,
      radius,
    };
    
    this.sendMessage('Event', payload, 'Reliable');
  }
  
  // Message handlers
  private handleStateSync(msg: NetworkMessage): void {
    const payload = msg.payload as StateSyncPayload;
    const entity = this.syncedEntities.get(payload.networkId);
    
    if (!entity) return;
    if (entity.identity.ownerId === this.localPeerId) {
      // This is our entity, reconcile
      reconcileState(entity, payload, this.predictionSettings);
    } else {
      // Remote entity, set target for interpolation
      entity.targetPosition = payload.position;
      entity.targetRotation = payload.rotation;
      entity.velocity = payload.velocity;
      entity.lastUpdateTime = payload.timestamp;
    }
  }
  
  private handleStateDelta(msg: NetworkMessage): void {
    const payload = msg.payload as StateDeltaPayload;
    const entity = this.syncedEntities.get(payload.networkId);
    
    if (!entity) return;
    
    for (let i = 0; i < payload.deltaFields.length; i++) {
      entity.syncedState.set(payload.deltaFields[i], payload.deltaValues[i]);
    }
  }
  
  private handleSpawn(msg: NetworkMessage): void {
    const payload = msg.payload as SpawnPayload;
    
    // Don't spawn our own entities again
    if (this.syncedEntities.has(payload.networkId)) return;
    
    const entity: SyncedEntity = {
      networkId: payload.networkId,
      identity: {
        networkId: payload.networkId,
        ownerId: payload.ownerId,
        authorityMode: payload.ownerId === this.localPeerId ? 'Client' : 'Server',
        isLocalPlayer: payload.ownerId === this.localPeerId,
        spawnTime: this.localTime,
      },
      position: payload.position,
      rotation: payload.rotation,
      velocity: vec3.zero(),
      angularVelocity: vec3.zero(),
      lastUpdateTime: this.localTime,
      previousPosition: payload.position,
      previousRotation: payload.rotation,
      targetPosition: payload.position,
      targetRotation: payload.rotation,
      syncedState: new Map(Object.entries(payload.initialState)),
      dirtyFields: new Set(),
      inputBuffer: [],
      stateHistory: [],
    };
    
    this.syncedEntities.set(payload.networkId, entity);
  }
  
  private handleDespawn(msg: NetworkMessage): void {
    const payload = msg.payload as DespawnPayload;
    this.syncedEntities.delete(payload.networkId);
    this.localEntityIds.delete(payload.networkId);
  }
  
  private handleRPC(msg: NetworkMessage): void {
    const payload = msg.payload as RPCPayload;
    // Would dispatch to registered RPC handlers
    console.log(`RPC: ${payload.methodName}`, payload.arguments);
  }
  
  // Room management
  createRoom(name: string, maxPlayers: number, settings?: Record<string, unknown>): Room {
    const room: Room = {
      id: `room_${Date.now().toString(36)}`,
      name,
      hostId: this.localPeerId,
      maxPlayers,
      players: [this.localPeerId],
      state: 'Lobby',
      settings: settings || {},
      createdAt: Date.now(),
      isPrivate: false,
      password: null,
    };
    
    this.currentRoom = room;
    this.isHost = true;
    
    return room;
  }
  
  joinRoom(roomId: string, password?: string): boolean {
    // Would send join request to server
    return true;
  }
  
  leaveRoom(): void {
    this.currentRoom = null;
    this.isHost = false;
  }
  
  getCurrentRoom(): Room | null {
    return this.currentRoom;
  }
  
  // Interpolation
  interpolateEntities(renderTime: number): void {
    if (!this.interpolationSettings.enabled) return;
    
    const interpolationTime = renderTime - this.interpolationSettings.delay;
    
    for (const entity of this.syncedEntities.values()) {
      if (this.localEntityIds.has(entity.networkId)) continue;
      
      const timeDelta = interpolationTime - entity.lastUpdateTime;
      
      if (timeDelta < 0) {
        // Haven't reached target yet, interpolate
        const t = 1 + timeDelta / this.interpolationSettings.delay;
        entity.position = vec3.lerp(entity.previousPosition, entity.targetPosition, t);
        // Would slerp rotation
      } else if (timeDelta < this.interpolationSettings.maxExtrapolation) {
        // Extrapolate
        entity.position = vec3.add(
          entity.targetPosition,
          vec3.scale(entity.velocity, timeDelta / 1000)
        );
      }
    }
  }
  
  // Update
  tick(dt: number): void {
    this.localTime += dt * 1000;
    
    // Send state updates for local entities
    for (const networkId of this.localEntityIds) {
      const entity = this.syncedEntities.get(networkId);
      if (!entity) continue;
      
      // Full state sync periodically
      const payload: StateSyncPayload = {
        networkId,
        position: entity.position,
        rotation: entity.rotation,
        velocity: entity.velocity,
        angularVelocity: entity.angularVelocity,
        customState: Object.fromEntries(entity.syncedState),
        timestamp: this.localTime,
      };
      
      this.sendMessage('StateSync', payload, 'Unreliable');
      
      // Delta sync for dirty fields
      if (entity.dirtyFields.size > 0) {
        const deltaPayload: StateDeltaPayload = {
          networkId,
          deltaFields: Array.from(entity.dirtyFields),
          deltaValues: Array.from(entity.dirtyFields).map(f => entity.syncedState.get(f)),
          baseSequence: this.messageSequence,
          timestamp: this.localTime,
        };
        
        this.sendMessage('StateDelta', deltaPayload, 'Reliable');
        entity.dirtyFields.clear();
      }
    }
    
    // Interpolate remote entities
    this.interpolateEntities(this.localTime);
    
    // Check heartbeats
    const now = Date.now();
    for (const peer of this.peers.values()) {
      if (now - peer.lastHeartbeat > 10000) {
        peer.state = 'Disconnected';
      }
    }
    
    this.lastUpdateTime = this.localTime;
  }
  
  // Stats
  getStats() {
    return { ...this.stats };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SINGLETON
// ═══════════════════════════════════════════════════════════════════════════════

export const worldNetwork = new WorldNetworkEngine();
