// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldEntitySystem — Complete Entity Component System for Living World
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    ENTITY COMPONENT SYSTEM — THE LIVING WORLD                  ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  Every object in the world is an ENTITY with COMPONENTS:                       ║
// ║    • Transform — Position, rotation, scale                                     ║
// ║    • Physics — Rigid body, velocity, forces                                    ║
// ║    • Render — Visual representation                                            ║
// ║    • AI — Behavior, decision making                                            ║
// ║    • Health — Damage, destruction                                              ║
// ║    • Sensor — Detection, awareness                                             ║
// ║    • Communication — Signals, messages                                         ║
// ║    • Resource — Energy, fuel, ammunition                                       ║
// ║                                                                                ║
// ║  SYSTEMS process entities with matching components each tick.                  ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type { Vec3, Quaternion } from './WorldPhysicsEngine';
import { vec3, quat } from './WorldPhysicsEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY CORE
// ═══════════════════════════════════════════════════════════════════════════════

export type EntityId = string;

export interface Entity {
  id: EntityId;
  name: string;
  tags: Set<string>;
  active: boolean;
  parent: EntityId | null;
  children: EntityId[];
  createdAt: number;
  updatedAt: number;
}

let entityCounter = 0;

export function createEntity(name: string, tags: string[] = []): Entity {
  return {
    id: `entity_${++entityCounter}_${Date.now().toString(36)}`,
    name,
    tags: new Set(tags),
    active: true,
    parent: null,
    children: [],
    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type ComponentType =
  | 'Transform'
  | 'Physics'
  | 'Render'
  | 'AI'
  | 'Health'
  | 'Sensor'
  | 'Communication'
  | 'Resource'
  | 'Weapon'
  | 'Navigation'
  | 'Inventory'
  | 'Script'
  | 'Audio'
  | 'Particle'
  | 'Light'
  | 'Camera'
  | 'Trigger'
  | 'Spawner'
  | 'Destructible'
  | 'Vehicle';

export interface Component {
  type: ComponentType;
  entityId: EntityId;
  enabled: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRANSFORM COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export interface TransformComponent extends Component {
  type: 'Transform';
  position: Vec3;
  rotation: Quaternion;
  scale: Vec3;
  
  // Computed world transform (when parented)
  worldPosition: Vec3;
  worldRotation: Quaternion;
  worldScale: Vec3;
  
  // Velocity for interpolation
  previousPosition: Vec3;
  previousRotation: Quaternion;
}

export function createTransformComponent(entityId: EntityId): TransformComponent {
  const pos = vec3.zero();
  const rot = quat.identity();
  return {
    type: 'Transform',
    entityId,
    enabled: true,
    position: pos,
    rotation: rot,
    scale: vec3.one(),
    worldPosition: { ...pos },
    worldRotation: { ...rot },
    worldScale: vec3.one(),
    previousPosition: { ...pos },
    previousRotation: { ...rot },
  };
}

export function setPosition(transform: TransformComponent, position: Vec3): void {
  transform.previousPosition = { ...transform.position };
  transform.position = position;
}

export function setRotation(transform: TransformComponent, rotation: Quaternion): void {
  transform.previousRotation = { ...transform.rotation };
  transform.rotation = rotation;
}

export function translate(transform: TransformComponent, delta: Vec3): void {
  transform.previousPosition = { ...transform.position };
  transform.position = vec3.add(transform.position, delta);
}

export function rotate(transform: TransformComponent, axis: Vec3, angle: number): void {
  transform.previousRotation = { ...transform.rotation };
  const deltaRot = quat.fromAxisAngle(axis, angle);
  transform.rotation = quat.multiply(deltaRot, transform.rotation);
}

export function lookAt(transform: TransformComponent, target: Vec3, up: Vec3 = { x: 0, y: 1, z: 0 }): void {
  const forward = vec3.normalize(vec3.sub(target, transform.position));
  const right = vec3.normalize(vec3.cross(up, forward));
  const newUp = vec3.cross(forward, right);
  
  // Convert to quaternion (simplified)
  const trace = right.x + newUp.y + forward.z;
  
  if (trace > 0) {
    const s = 0.5 / Math.sqrt(trace + 1);
    transform.rotation = {
      w: 0.25 / s,
      x: (newUp.z - forward.y) * s,
      y: (forward.x - right.z) * s,
      z: (right.y - newUp.x) * s,
    };
  } else {
    // Handle edge cases
    transform.rotation = quat.identity();
  }
}

export function getForward(transform: TransformComponent): Vec3 {
  return quat.rotateVector(transform.rotation, { x: 0, y: 0, z: 1 });
}

export function getRight(transform: TransformComponent): Vec3 {
  return quat.rotateVector(transform.rotation, { x: 1, y: 0, z: 0 });
}

export function getUp(transform: TransformComponent): Vec3 {
  return quat.rotateVector(transform.rotation, { x: 0, y: 1, z: 0 });
}

// ═══════════════════════════════════════════════════════════════════════════════
// PHYSICS COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type ColliderType = 'Sphere' | 'Box' | 'Capsule' | 'Mesh' | 'None';

export interface PhysicsComponent extends Component {
  type: 'Physics';
  
  // Dynamics
  velocity: Vec3;
  angularVelocity: Vec3;
  acceleration: Vec3;
  
  // Properties
  mass: number;
  drag: number;
  angularDrag: number;
  useGravity: boolean;
  isKinematic: boolean;
  isTrigger: boolean;
  
  // Collider
  colliderType: ColliderType;
  colliderSize: Vec3;
  colliderOffset: Vec3;
  
  // Layers
  layer: number;
  collisionMask: number;
  
  // Constraints
  freezePosition: { x: boolean; y: boolean; z: boolean };
  freezeRotation: { x: boolean; y: boolean; z: boolean };
  
  // State
  isGrounded: boolean;
  groundNormal: Vec3;
  lastCollision: { entityId: EntityId; point: Vec3; normal: Vec3 } | null;
}

export function createPhysicsComponent(entityId: EntityId, mass: number = 1): PhysicsComponent {
  return {
    type: 'Physics',
    entityId,
    enabled: true,
    velocity: vec3.zero(),
    angularVelocity: vec3.zero(),
    acceleration: vec3.zero(),
    mass,
    drag: 0.01,
    angularDrag: 0.05,
    useGravity: true,
    isKinematic: false,
    isTrigger: false,
    colliderType: 'Sphere',
    colliderSize: { x: 1, y: 1, z: 1 },
    colliderOffset: vec3.zero(),
    layer: 1,
    collisionMask: 0xFFFFFFFF,
    freezePosition: { x: false, y: false, z: false },
    freezeRotation: { x: false, y: false, z: false },
    isGrounded: false,
    groundNormal: { x: 0, y: 1, z: 0 },
    lastCollision: null,
  };
}

export function addForce(physics: PhysicsComponent, force: Vec3, mode: 'Force' | 'Impulse' | 'Acceleration' = 'Force'): void {
  if (physics.isKinematic) return;
  
  switch (mode) {
    case 'Force':
      // F = ma, so a = F/m
      physics.acceleration = vec3.add(physics.acceleration, vec3.scale(force, 1 / physics.mass));
      break;
    case 'Impulse':
      // Instant velocity change
      physics.velocity = vec3.add(physics.velocity, vec3.scale(force, 1 / physics.mass));
      break;
    case 'Acceleration':
      physics.acceleration = vec3.add(physics.acceleration, force);
      break;
  }
}

export function addTorque(physics: PhysicsComponent, torque: Vec3): void {
  if (physics.isKinematic) return;
  // Simplified: assume uniform inertia
  const angularAccel = vec3.scale(torque, 1 / physics.mass);
  physics.angularVelocity = vec3.add(physics.angularVelocity, angularAccel);
}

// ═══════════════════════════════════════════════════════════════════════════════
// RENDER COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type RenderType = 'Mesh' | 'Sprite' | 'Particle' | 'Line' | 'Text' | 'Billboard';
export type BlendMode = 'Opaque' | 'Transparent' | 'Additive' | 'Multiply';

export interface Material {
  id: string;
  color: { r: number; g: number; b: number; a: number };
  emissive: { r: number; g: number; b: number };
  metallic: number;
  roughness: number;
  texture: string | null;
  normalMap: string | null;
  blendMode: BlendMode;
}

export interface RenderComponent extends Component {
  type: 'Render';
  renderType: RenderType;
  meshId: string | null;
  material: Material;
  visible: boolean;
  castShadow: boolean;
  receiveShadow: boolean;
  renderOrder: number;
  layer: number;
  
  // LOD
  lodLevels: { distance: number; meshId: string }[];
  currentLod: number;
  
  // Animation
  animationId: string | null;
  animationTime: number;
  animationSpeed: number;
  
  // Bounds
  boundingBox: { min: Vec3; max: Vec3 };
  boundingSphere: { center: Vec3; radius: number };
}

export function createRenderComponent(entityId: EntityId, meshId: string | null = null): RenderComponent {
  return {
    type: 'Render',
    entityId,
    enabled: true,
    renderType: 'Mesh',
    meshId,
    material: {
      id: 'default',
      color: { r: 1, g: 1, b: 1, a: 1 },
      emissive: { r: 0, g: 0, b: 0 },
      metallic: 0,
      roughness: 0.5,
      texture: null,
      normalMap: null,
      blendMode: 'Opaque',
    },
    visible: true,
    castShadow: true,
    receiveShadow: true,
    renderOrder: 0,
    layer: 1,
    lodLevels: [],
    currentLod: 0,
    animationId: null,
    animationTime: 0,
    animationSpeed: 1,
    boundingBox: { min: vec3.scale(vec3.one(), -0.5), max: vec3.scale(vec3.one(), 0.5) },
    boundingSphere: { center: vec3.zero(), radius: 0.5 },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// AI COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type AIState = 
  | 'Idle'
  | 'Patrol'
  | 'Search'
  | 'Chase'
  | 'Attack'
  | 'Flee'
  | 'Cover'
  | 'Support'
  | 'Dead'
  | 'Custom';

export type AIBehavior =
  | 'Aggressive'
  | 'Defensive'
  | 'Passive'
  | 'Cowardly'
  | 'Supportive'
  | 'Erratic';

export interface AIComponent extends Component {
  type: 'AI';
  
  // State machine
  currentState: AIState;
  previousState: AIState;
  stateTime: number;
  
  // Behavior
  behavior: AIBehavior;
  aggressiveness: number;  // 0-1
  courage: number;         // 0-1
  intelligence: number;    // 0-1
  
  // Awareness
  detectionRange: number;
  fieldOfView: number;     // degrees
  hearingRange: number;
  memoryDuration: number;  // seconds
  
  // Targets
  currentTarget: EntityId | null;
  targetPosition: Vec3 | null;
  knownEnemies: { entityId: EntityId; lastSeen: Vec3; timestamp: number }[];
  knownAllies: EntityId[];
  
  // Patrol
  patrolPoints: Vec3[];
  currentPatrolIndex: number;
  patrolWaitTime: number;
  
  // Combat
  attackRange: number;
  attackCooldown: number;
  lastAttackTime: number;
  accuracy: number;        // 0-1
  
  // Movement
  moveSpeed: number;
  runSpeed: number;
  turnSpeed: number;
  
  // Decision making
  threatLevel: number;
  confidence: number;
  lastDecisionTime: number;
  decisionCooldown: number;
}

export function createAIComponent(entityId: EntityId): AIComponent {
  return {
    type: 'AI',
    entityId,
    enabled: true,
    currentState: 'Idle',
    previousState: 'Idle',
    stateTime: 0,
    behavior: 'Defensive',
    aggressiveness: 0.5,
    courage: 0.5,
    intelligence: 0.5,
    detectionRange: 100,
    fieldOfView: 120,
    hearingRange: 50,
    memoryDuration: 30,
    currentTarget: null,
    targetPosition: null,
    knownEnemies: [],
    knownAllies: [],
    patrolPoints: [],
    currentPatrolIndex: 0,
    patrolWaitTime: 3,
    attackRange: 50,
    attackCooldown: 1,
    lastAttackTime: 0,
    accuracy: 0.7,
    moveSpeed: 5,
    runSpeed: 10,
    turnSpeed: 180,
    threatLevel: 0,
    confidence: 1,
    lastDecisionTime: 0,
    decisionCooldown: 0.5,
  };
}

export function setAIState(ai: AIComponent, newState: AIState): void {
  if (ai.currentState !== newState) {
    ai.previousState = ai.currentState;
    ai.currentState = newState;
    ai.stateTime = 0;
  }
}

export function addEnemy(ai: AIComponent, enemyId: EntityId, position: Vec3): void {
  const existing = ai.knownEnemies.find(e => e.entityId === enemyId);
  if (existing) {
    existing.lastSeen = position;
    existing.timestamp = Date.now();
  } else {
    ai.knownEnemies.push({
      entityId: enemyId,
      lastSeen: position,
      timestamp: Date.now(),
    });
  }
}

export function forgetOldEnemies(ai: AIComponent): void {
  const now = Date.now();
  const memoryMs = ai.memoryDuration * 1000;
  ai.knownEnemies = ai.knownEnemies.filter(e => now - e.timestamp < memoryMs);
}

// ═══════════════════════════════════════════════════════════════════════════════
// HEALTH COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type DamageType = 
  | 'Physical'
  | 'Fire'
  | 'Electric'
  | 'Chemical'
  | 'Radiation'
  | 'Explosive'
  | 'EMP';

export interface DamageEvent {
  amount: number;
  type: DamageType;
  sourceId: EntityId | null;
  position: Vec3;
  direction: Vec3;
  timestamp: number;
}

export interface HealthComponent extends Component {
  type: 'Health';
  
  // Health
  currentHealth: number;
  maxHealth: number;
  regeneration: number;    // per second
  
  // Armor/resistance
  armor: number;
  resistances: Partial<Record<DamageType, number>>;
  
  // State
  isAlive: boolean;
  isInvulnerable: boolean;
  lastDamageTime: number;
  invulnerabilityTime: number;  // after damage
  
  // Damage tracking
  damageHistory: DamageEvent[];
  totalDamageTaken: number;
  lastDamageSource: EntityId | null;
  
  // Death
  deathTime: number | null;
  destroyOnDeath: boolean;
  deathDelay: number;
}

export function createHealthComponent(entityId: EntityId, maxHealth: number = 100): HealthComponent {
  return {
    type: 'Health',
    entityId,
    enabled: true,
    currentHealth: maxHealth,
    maxHealth,
    regeneration: 0,
    armor: 0,
    resistances: {},
    isAlive: true,
    isInvulnerable: false,
    lastDamageTime: 0,
    invulnerabilityTime: 0,
    damageHistory: [],
    totalDamageTaken: 0,
    lastDamageSource: null,
    deathTime: null,
    destroyOnDeath: true,
    deathDelay: 0,
  };
}

export function applyDamage(health: HealthComponent, damage: DamageEvent): number {
  if (!health.isAlive || health.isInvulnerable) return 0;
  
  const now = Date.now();
  if (now - health.lastDamageTime < health.invulnerabilityTime * 1000) return 0;
  
  // Apply armor and resistances
  let finalDamage = damage.amount;
  finalDamage -= health.armor;
  
  const resistance = health.resistances[damage.type] || 0;
  finalDamage *= (1 - resistance);
  
  finalDamage = Math.max(0, finalDamage);
  
  // Apply damage
  health.currentHealth -= finalDamage;
  health.lastDamageTime = now;
  health.lastDamageSource = damage.sourceId;
  health.totalDamageTaken += finalDamage;
  
  health.damageHistory.push({ ...damage, amount: finalDamage });
  if (health.damageHistory.length > 100) {
    health.damageHistory.shift();
  }
  
  // Check death
  if (health.currentHealth <= 0) {
    health.currentHealth = 0;
    health.isAlive = false;
    health.deathTime = now;
  }
  
  return finalDamage;
}

export function heal(health: HealthComponent, amount: number): number {
  if (!health.isAlive) return 0;
  
  const oldHealth = health.currentHealth;
  health.currentHealth = Math.min(health.maxHealth, health.currentHealth + amount);
  return health.currentHealth - oldHealth;
}

export function revive(health: HealthComponent, healthPercent: number = 1): void {
  health.isAlive = true;
  health.currentHealth = health.maxHealth * healthPercent;
  health.deathTime = null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SENSOR COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type SensorType =
  | 'Visual'
  | 'Radar'
  | 'Infrared'
  | 'Acoustic'
  | 'Chemical'
  | 'Radiation'
  | 'EW';  // Electronic warfare

export interface Detection {
  entityId: EntityId;
  sensorType: SensorType;
  position: Vec3;
  velocity: Vec3;
  confidence: number;      // 0-1
  timestamp: number;
  signature: number;       // strength of detection
}

export interface SensorComponent extends Component {
  type: 'Sensor';
  
  // Sensors
  sensors: {
    type: SensorType;
    range: number;
    fov: number;           // degrees (360 for omnidirectional)
    resolution: number;    // 0-1
    refreshRate: number;   // Hz
    lastScan: number;
    enabled: boolean;
  }[];
  
  // Detections
  detections: Detection[];
  maxDetections: number;
  
  // Tracking
  trackedTargets: EntityId[];
  maxTrackedTargets: number;
  
  // Stealth
  visualSignature: number;
  radarSignature: number;
  thermalSignature: number;
  acousticSignature: number;
  
  // Jamming
  isJammed: boolean;
  jamStrength: number;
}

export function createSensorComponent(entityId: EntityId): SensorComponent {
  return {
    type: 'Sensor',
    entityId,
    enabled: true,
    sensors: [
      {
        type: 'Visual',
        range: 1000,
        fov: 120,
        resolution: 0.8,
        refreshRate: 30,
        lastScan: 0,
        enabled: true,
      },
      {
        type: 'Radar',
        range: 5000,
        fov: 360,
        resolution: 0.6,
        refreshRate: 1,
        lastScan: 0,
        enabled: true,
      },
    ],
    detections: [],
    maxDetections: 100,
    trackedTargets: [],
    maxTrackedTargets: 10,
    visualSignature: 1,
    radarSignature: 1,
    thermalSignature: 1,
    acousticSignature: 1,
    isJammed: false,
    jamStrength: 0,
  };
}

export function addDetection(sensor: SensorComponent, detection: Detection): void {
  // Update existing or add new
  const existing = sensor.detections.find(d => d.entityId === detection.entityId);
  if (existing) {
    Object.assign(existing, detection);
  } else {
    sensor.detections.push(detection);
    if (sensor.detections.length > sensor.maxDetections) {
      // Remove oldest low-confidence detection
      sensor.detections.sort((a, b) => b.confidence - a.confidence);
      sensor.detections.pop();
    }
  }
}

export function clearOldDetections(sensor: SensorComponent, maxAge: number): void {
  const now = Date.now();
  sensor.detections = sensor.detections.filter(d => now - d.timestamp < maxAge * 1000);
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMMUNICATION COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type MessageType =
  | 'Alert'
  | 'Command'
  | 'Report'
  | 'Request'
  | 'Acknowledge'
  | 'Broadcast'
  | 'Encrypted';

export interface Message {
  id: string;
  type: MessageType;
  senderId: EntityId;
  receiverId: EntityId | null;  // null = broadcast
  content: unknown;
  timestamp: number;
  priority: number;
  encrypted: boolean;
  ttl: number;  // time to live in seconds
}

export interface CommunicationComponent extends Component {
  type: 'Communication';
  
  // Radio
  frequency: number;
  transmitPower: number;
  receiveRange: number;
  
  // Messages
  inbox: Message[];
  outbox: Message[];
  maxMessages: number;
  
  // Channels
  channels: number[];
  currentChannel: number;
  
  // State
  isTransmitting: boolean;
  isReceiving: boolean;
  isJammed: boolean;
  
  // Encryption
  encryptionKey: string | null;
  canDecrypt: Set<string>;
  
  // Network
  networkId: string | null;
  connectedPeers: EntityId[];
}

export function createCommunicationComponent(entityId: EntityId): CommunicationComponent {
  return {
    type: 'Communication',
    entityId,
    enabled: true,
    frequency: 100,
    transmitPower: 100,
    receiveRange: 10000,
    inbox: [],
    outbox: [],
    maxMessages: 50,
    channels: [1],
    currentChannel: 1,
    isTransmitting: false,
    isReceiving: true,
    isJammed: false,
    encryptionKey: null,
    canDecrypt: new Set(),
    networkId: null,
    connectedPeers: [],
  };
}

let messageCounter = 0;

export function sendMessage(
  comm: CommunicationComponent,
  type: MessageType,
  content: unknown,
  receiverId: EntityId | null = null,
  priority: number = 1
): Message {
  const message: Message = {
    id: `msg_${++messageCounter}_${Date.now().toString(36)}`,
    type,
    senderId: comm.entityId,
    receiverId,
    content,
    timestamp: Date.now(),
    priority,
    encrypted: comm.encryptionKey !== null,
    ttl: 60,
  };
  
  comm.outbox.push(message);
  if (comm.outbox.length > comm.maxMessages) {
    comm.outbox.shift();
  }
  
  return message;
}

export function receiveMessage(comm: CommunicationComponent, message: Message): boolean {
  // Check if we can receive
  if (!comm.isReceiving || comm.isJammed) return false;
  
  // Check encryption
  if (message.encrypted && !comm.canDecrypt.has(message.senderId)) {
    return false;
  }
  
  comm.inbox.push(message);
  if (comm.inbox.length > comm.maxMessages) {
    comm.inbox.shift();
  }
  
  return true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESOURCE COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type ResourceType =
  | 'Energy'
  | 'Fuel'
  | 'Ammunition'
  | 'Coolant'
  | 'Payload'
  | 'Data';

export interface ResourcePool {
  type: ResourceType;
  current: number;
  max: number;
  regeneration: number;    // per second
  consumption: number;     // per second (base)
}

export interface ResourceComponent extends Component {
  type: 'Resource';
  
  pools: ResourcePool[];
  
  // Transfer
  canTransfer: boolean;
  transferRate: number;
  
  // State
  isLow: boolean;
  isCritical: boolean;
  lowThreshold: number;    // 0-1
  criticalThreshold: number;
}

export function createResourceComponent(entityId: EntityId): ResourceComponent {
  return {
    type: 'Resource',
    entityId,
    enabled: true,
    pools: [
      { type: 'Energy', current: 100, max: 100, regeneration: 5, consumption: 1 },
      { type: 'Fuel', current: 100, max: 100, regeneration: 0, consumption: 0.5 },
    ],
    canTransfer: false,
    transferRate: 10,
    isLow: false,
    isCritical: false,
    lowThreshold: 0.3,
    criticalThreshold: 0.1,
  };
}

export function consumeResource(resource: ResourceComponent, type: ResourceType, amount: number): boolean {
  const pool = resource.pools.find(p => p.type === type);
  if (!pool || pool.current < amount) return false;
  
  pool.current -= amount;
  updateResourceState(resource);
  return true;
}

export function addResource(resource: ResourceComponent, type: ResourceType, amount: number): number {
  const pool = resource.pools.find(p => p.type === type);
  if (!pool) return 0;
  
  const oldAmount = pool.current;
  pool.current = Math.min(pool.max, pool.current + amount);
  updateResourceState(resource);
  return pool.current - oldAmount;
}

function updateResourceState(resource: ResourceComponent): void {
  resource.isLow = false;
  resource.isCritical = false;
  
  for (const pool of resource.pools) {
    const ratio = pool.current / pool.max;
    if (ratio < resource.criticalThreshold) {
      resource.isCritical = true;
      resource.isLow = true;
    } else if (ratio < resource.lowThreshold) {
      resource.isLow = true;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WEAPON COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export type WeaponType =
  | 'Projectile'
  | 'Laser'
  | 'Missile'
  | 'Bomb'
  | 'EMP'
  | 'Melee';

export interface Weapon {
  id: string;
  name: string;
  type: WeaponType;
  damage: number;
  damageType: DamageType;
  range: number;
  accuracy: number;
  fireRate: number;        // rounds per second
  magazineSize: number;
  currentAmmo: number;
  reloadTime: number;
  isReloading: boolean;
  reloadProgress: number;
  lastFireTime: number;
  
  // Projectile specific
  projectileSpeed: number;
  projectileGravity: boolean;
  
  // Splash
  splashRadius: number;
  splashDamageFalloff: number;
}

export interface WeaponComponent extends Component {
  type: 'Weapon';
  
  weapons: Weapon[];
  currentWeaponIndex: number;
  
  // Aiming
  aimTarget: Vec3 | null;
  aimEntityId: EntityId | null;
  aimAssist: number;       // 0-1
  
  // State
  isFiring: boolean;
  isAiming: boolean;
  
  // Cooldown
  globalCooldown: number;
  lastActionTime: number;
}

export function createWeaponComponent(entityId: EntityId): WeaponComponent {
  return {
    type: 'Weapon',
    entityId,
    enabled: true,
    weapons: [],
    currentWeaponIndex: 0,
    aimTarget: null,
    aimEntityId: null,
    aimAssist: 0,
    isFiring: false,
    isAiming: false,
    globalCooldown: 0.1,
    lastActionTime: 0,
  };
}

export function addWeapon(weapon: WeaponComponent, newWeapon: Omit<Weapon, 'id'>): Weapon {
  const w: Weapon = {
    id: `weapon_${Date.now().toString(36)}_${Math.random().toString(36).substr(2, 5)}`,
    ...newWeapon,
  };
  weapon.weapons.push(w);
  return w;
}

export function canFire(weapon: WeaponComponent): boolean {
  if (weapon.weapons.length === 0) return false;
  
  const current = weapon.weapons[weapon.currentWeaponIndex];
  if (!current) return false;
  
  const now = Date.now();
  const timeSinceLastFire = (now - current.lastFireTime) / 1000;
  const fireInterval = 1 / current.fireRate;
  
  return !current.isReloading && 
         current.currentAmmo > 0 && 
         timeSinceLastFire >= fireInterval;
}

export function fire(weapon: WeaponComponent): boolean {
  if (!canFire(weapon)) return false;
  
  const current = weapon.weapons[weapon.currentWeaponIndex];
  current.currentAmmo--;
  current.lastFireTime = Date.now();
  weapon.lastActionTime = Date.now();
  
  return true;
}

export function reload(weapon: WeaponComponent): boolean {
  const current = weapon.weapons[weapon.currentWeaponIndex];
  if (!current || current.isReloading || current.currentAmmo === current.magazineSize) {
    return false;
  }
  
  current.isReloading = true;
  current.reloadProgress = 0;
  return true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// NAVIGATION COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export interface Waypoint {
  position: Vec3;
  radius: number;          // How close to consider "reached"
  waitTime: number;        // Time to wait at waypoint
  action: string | null;   // Action to perform at waypoint
}

export interface NavigationComponent extends Component {
  type: 'Navigation';
  
  // Path
  waypoints: Waypoint[];
  currentWaypointIndex: number;
  
  // Target
  destination: Vec3 | null;
  destinationEntity: EntityId | null;
  
  // Movement
  speed: number;
  maxSpeed: number;
  acceleration: number;
  turnRate: number;
  
  // Pathfinding
  path: Vec3[];
  pathIndex: number;
  isPathfinding: boolean;
  lastPathfindTime: number;
  pathfindCooldown: number;
  
  // Avoidance
  avoidanceRadius: number;
  avoidanceForce: number;
  nearbyObstacles: Vec3[];
  
  // State
  isMoving: boolean;
  isArrived: boolean;
  stuckTime: number;
  stuckThreshold: number;
}

export function createNavigationComponent(entityId: EntityId): NavigationComponent {
  return {
    type: 'Navigation',
    entityId,
    enabled: true,
    waypoints: [],
    currentWaypointIndex: 0,
    destination: null,
    destinationEntity: null,
    speed: 0,
    maxSpeed: 10,
    acceleration: 5,
    turnRate: 180,
    path: [],
    pathIndex: 0,
    isPathfinding: false,
    lastPathfindTime: 0,
    pathfindCooldown: 1,
    avoidanceRadius: 5,
    avoidanceForce: 10,
    nearbyObstacles: [],
    isMoving: false,
    isArrived: false,
    stuckTime: 0,
    stuckThreshold: 3,
  };
}

export function setDestination(nav: NavigationComponent, destination: Vec3): void {
  nav.destination = destination;
  nav.destinationEntity = null;
  nav.isArrived = false;
  nav.path = [];
  nav.pathIndex = 0;
}

export function followEntity(nav: NavigationComponent, entityId: EntityId): void {
  nav.destinationEntity = entityId;
  nav.isArrived = false;
}

export function addWaypoint(nav: NavigationComponent, waypoint: Waypoint): void {
  nav.waypoints.push(waypoint);
}

export function clearWaypoints(nav: NavigationComponent): void {
  nav.waypoints = [];
  nav.currentWaypointIndex = 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY WORLD — MANAGES ALL ENTITIES AND COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════

export class EntityWorld {
  private entities: Map<EntityId, Entity> = new Map();
  private components: Map<ComponentType, Map<EntityId, Component>> = new Map();
  private tagIndex: Map<string, Set<EntityId>> = new Map();
  
  // Systems
  private systems: ((world: EntityWorld, dt: number) => void)[] = [];
  
  constructor() {
    // Initialize component storage for all types
    const types: ComponentType[] = [
      'Transform', 'Physics', 'Render', 'AI', 'Health', 'Sensor',
      'Communication', 'Resource', 'Weapon', 'Navigation', 'Inventory',
      'Script', 'Audio', 'Particle', 'Light', 'Camera', 'Trigger',
      'Spawner', 'Destructible', 'Vehicle'
    ];
    
    for (const type of types) {
      this.components.set(type, new Map());
    }
  }
  
  // Entity management
  createEntity(name: string, tags: string[] = []): Entity {
    const entity = createEntity(name, tags);
    this.entities.set(entity.id, entity);
    
    // Update tag index
    for (const tag of tags) {
      if (!this.tagIndex.has(tag)) {
        this.tagIndex.set(tag, new Set());
      }
      this.tagIndex.get(tag)!.add(entity.id);
    }
    
    return entity;
  }
  
  destroyEntity(entityId: EntityId): void {
    const entity = this.entities.get(entityId);
    if (!entity) return;
    
    // Remove from tag index
    for (const tag of entity.tags) {
      this.tagIndex.get(tag)?.delete(entityId);
    }
    
    // Remove all components
    for (const componentMap of this.components.values()) {
      componentMap.delete(entityId);
    }
    
    // Remove children
    for (const childId of entity.children) {
      this.destroyEntity(childId);
    }
    
    // Remove from parent
    if (entity.parent) {
      const parent = this.entities.get(entity.parent);
      if (parent) {
        parent.children = parent.children.filter(id => id !== entityId);
      }
    }
    
    this.entities.delete(entityId);
  }
  
  getEntity(entityId: EntityId): Entity | undefined {
    return this.entities.get(entityId);
  }
  
  getAllEntities(): Entity[] {
    return Array.from(this.entities.values());
  }
  
  getEntitiesByTag(tag: string): Entity[] {
    const ids = this.tagIndex.get(tag);
    if (!ids) return [];
    return Array.from(ids).map(id => this.entities.get(id)!).filter(Boolean);
  }
  
  // Component management
  addComponent<T extends Component>(entityId: EntityId, component: T): void {
    const componentMap = this.components.get(component.type);
    if (componentMap) {
      componentMap.set(entityId, component);
    }
  }
  
  removeComponent(entityId: EntityId, type: ComponentType): void {
    const componentMap = this.components.get(type);
    if (componentMap) {
      componentMap.delete(entityId);
    }
  }
  
  getComponent<T extends Component>(entityId: EntityId, type: ComponentType): T | undefined {
    const componentMap = this.components.get(type);
    return componentMap?.get(entityId) as T | undefined;
  }
  
  hasComponent(entityId: EntityId, type: ComponentType): boolean {
    const componentMap = this.components.get(type);
    return componentMap?.has(entityId) ?? false;
  }
  
  getEntitiesWithComponents(...types: ComponentType[]): Entity[] {
    return this.getAllEntities().filter(entity => 
      types.every(type => this.hasComponent(entity.id, type))
    );
  }
  
  // System management
  addSystem(system: (world: EntityWorld, dt: number) => void): void {
    this.systems.push(system);
  }
  
  tick(dt: number): void {
    for (const system of this.systems) {
      system(this, dt);
    }
  }
  
  // Queries
  query(predicate: (entity: Entity, world: EntityWorld) => boolean): Entity[] {
    return this.getAllEntities().filter(e => predicate(e, this));
  }
  
  // Spatial queries
  findNearby(position: Vec3, radius: number): Entity[] {
    return this.getAllEntities().filter(entity => {
      const transform = this.getComponent<TransformComponent>(entity.id, 'Transform');
      if (!transform) return false;
      return vec3.distance(transform.position, position) <= radius;
    });
  }
  
  // Parent-child
  setParent(childId: EntityId, parentId: EntityId | null): void {
    const child = this.entities.get(childId);
    if (!child) return;
    
    // Remove from old parent
    if (child.parent) {
      const oldParent = this.entities.get(child.parent);
      if (oldParent) {
        oldParent.children = oldParent.children.filter(id => id !== childId);
      }
    }
    
    child.parent = parentId;
    
    // Add to new parent
    if (parentId) {
      const newParent = this.entities.get(parentId);
      if (newParent) {
        newParent.children.push(childId);
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DEFAULT SYSTEMS
// ═══════════════════════════════════════════════════════════════════════════════

export function physicsSystem(world: EntityWorld, dt: number): void {
  const entities = world.getEntitiesWithComponents('Transform', 'Physics');
  const GRAVITY = 9.8;
  
  for (const entity of entities) {
    const transform = world.getComponent<TransformComponent>(entity.id, 'Transform')!;
    const physics = world.getComponent<PhysicsComponent>(entity.id, 'Physics')!;
    
    if (!physics.enabled || physics.isKinematic) continue;
    
    // Apply gravity
    if (physics.useGravity) {
      physics.velocity.y -= GRAVITY * dt;
    }
    
    // Apply acceleration
    physics.velocity = vec3.add(physics.velocity, vec3.scale(physics.acceleration, dt));
    physics.acceleration = vec3.zero();
    
    // Apply drag
    physics.velocity = vec3.scale(physics.velocity, 1 - physics.drag * dt);
    physics.angularVelocity = vec3.scale(physics.angularVelocity, 1 - physics.angularDrag * dt);
    
    // Apply constraints
    if (physics.freezePosition.x) physics.velocity.x = 0;
    if (physics.freezePosition.y) physics.velocity.y = 0;
    if (physics.freezePosition.z) physics.velocity.z = 0;
    
    // Update transform
    translate(transform, vec3.scale(physics.velocity, dt));
    
    // Update rotation
    const angularMag = vec3.length(physics.angularVelocity);
    if (angularMag > 0.001) {
      const axis = vec3.scale(physics.angularVelocity, 1 / angularMag);
      rotate(transform, axis, angularMag * dt);
    }
    
    // Ground check (simplified)
    if (transform.position.y < 0) {
      transform.position.y = 0;
      physics.velocity.y = 0;
      physics.isGrounded = true;
    } else {
      physics.isGrounded = false;
    }
  }
}

export function healthRegenerationSystem(world: EntityWorld, dt: number): void {
  const entities = world.getEntitiesWithComponents('Health');
  
  for (const entity of entities) {
    const health = world.getComponent<HealthComponent>(entity.id, 'Health')!;
    
    if (!health.enabled || !health.isAlive) continue;
    
    if (health.regeneration > 0 && health.currentHealth < health.maxHealth) {
      heal(health, health.regeneration * dt);
    }
  }
}

export function resourceSystem(world: EntityWorld, dt: number): void {
  const entities = world.getEntitiesWithComponents('Resource');
  
  for (const entity of entities) {
    const resource = world.getComponent<ResourceComponent>(entity.id, 'Resource')!;
    
    if (!resource.enabled) continue;
    
    for (const pool of resource.pools) {
      // Regeneration
      if (pool.regeneration > 0) {
        pool.current = Math.min(pool.max, pool.current + pool.regeneration * dt);
      }
      
      // Base consumption
      if (pool.consumption > 0) {
        pool.current = Math.max(0, pool.current - pool.consumption * dt);
      }
    }
    
    updateResourceState(resource);
  }
}

export function sensorCleanupSystem(world: EntityWorld, dt: number): void {
  const entities = world.getEntitiesWithComponents('Sensor');
  
  for (const entity of entities) {
    const sensor = world.getComponent<SensorComponent>(entity.id, 'Sensor')!;
    clearOldDetections(sensor, 10); // 10 second memory
  }
}

export function aiStateSystem(world: EntityWorld, dt: number): void {
  const entities = world.getEntitiesWithComponents('AI');
  
  for (const entity of entities) {
    const ai = world.getComponent<AIComponent>(entity.id, 'AI')!;
    
    if (!ai.enabled) continue;
    
    ai.stateTime += dt;
    forgetOldEnemies(ai);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT
// ═══════════════════════════════════════════════════════════════════════════════

export const worldEntities = new EntityWorld();

// Add default systems
worldEntities.addSystem(physicsSystem);
worldEntities.addSystem(healthRegenerationSystem);
worldEntities.addSystem(resourceSystem);
worldEntities.addSystem(sensorCleanupSystem);
worldEntities.addSystem(aiStateSystem);
