// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldEnvironmentEngine — Environmental Effects & Reactions
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD ENVIRONMENT ENGINE                                    ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  WIRED INTO EXISTING ARCHITECTURE:                                             ║
// ║    • Connects to WorldPhysicsEngine for explosion effects                      ║
// ║    • Uses WorldTerrainEngine for terrain modification                          ║
// ║    • Integrates with WorldWeatherEngine for fire spread                        ║
// ║    • Feeds into StabilityBudgetEngine for damage tracking                      ║
// ║                                                                                ║
// ║  ENVIRONMENTAL SYSTEMS:                                                        ║
// ║    • Fire simulation (spread, intensity, fuel)                                 ║
// ║    • Destruction (buildings, terrain deformation)                              ║
// ║    • Debris and particles                                                      ║
// ║    • Smoke and gas simulation                                                  ║
// ║    • Radiation and contamination                                               ║
// ║    • Environmental memory (damage persistence)                                 ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type { Vec3 } from './WorldPhysicsEngine';
import { vec3 } from './WorldPhysicsEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// ENVIRONMENTAL CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const ENVIRONMENT = {
  // Fire
  FIRE_SPREAD_RATE: 0.5,          // m/s base spread
  FIRE_TEMPERATURE: 1200,          // Kelvin (typical fire)
  FIRE_DECAY_RATE: 0.02,           // Per second
  FIRE_MIN_FUEL: 0.1,              // Minimum fuel to sustain
  
  // Smoke
  SMOKE_RISE_RATE: 3.0,            // m/s
  SMOKE_SPREAD_RATE: 1.0,          // m/s horizontal
  SMOKE_DECAY_RATE: 0.05,          // Per second
  
  // Destruction
  CRATER_DEPTH_FACTOR: 0.3,        // Depth = factor * sqrt(yield)
  CRATER_RADIUS_FACTOR: 2.0,       // Radius = factor * sqrt(yield)
  DEBRIS_VELOCITY_FACTOR: 50,      // m/s per sqrt(yield)
  
  // Radiation
  RADIATION_DECAY_HALF_LIFE: 3600, // Seconds (1 hour for gameplay)
  RADIATION_LETHAL_DOSE: 1000,     // mSv
  
  // Golden ratio for natural decay
  PHI: 1.6180339887498948482,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// FIRE SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface FireCell {
  position: Vec3;
  intensity: number;       // 0-1
  fuel: number;            // Remaining fuel (0-1)
  temperature: number;     // Kelvin
  burnTime: number;        // Seconds burning
  spreadChance: number;    // 0-1 per tick
}

export interface FireConfig {
  baseSpreadRate: number;
  windInfluence: number;
  humidityInfluence: number;
  slopeInfluence: number;
  minIntensityToSpread: number;
}

export const DEFAULT_FIRE_CONFIG: FireConfig = {
  baseSpreadRate: ENVIRONMENT.FIRE_SPREAD_RATE,
  windInfluence: 0.5,
  humidityInfluence: 0.3,
  slopeInfluence: 0.2,
  minIntensityToSpread: 0.3,
};

export function createFire(position: Vec3, initialIntensity: number = 0.5): FireCell {
  return {
    position,
    intensity: initialIntensity,
    fuel: 1.0,
    temperature: 300 + initialIntensity * (ENVIRONMENT.FIRE_TEMPERATURE - 300),
    burnTime: 0,
    spreadChance: initialIntensity * 0.3,
  };
}

export function updateFire(
  fire: FireCell,
  dt: number,
  windSpeed: number,
  windDirection: number,
  humidity: number,
  fuelAvailable: number
): FireCell {
  if (fire.intensity <= 0 || fire.fuel <= 0) {
    return { ...fire, intensity: 0, temperature: 300 };
  }
  
  // Consume fuel
  const fuelConsumption = fire.intensity * 0.1 * dt;
  const newFuel = Math.max(0, fire.fuel - fuelConsumption);
  
  // Humidity reduces intensity
  const humidityFactor = 1 - humidity * 0.5;
  
  // Wind increases intensity up to a point
  const windFactor = 1 + Math.min(windSpeed * 0.05, 0.5);
  
  // Calculate new intensity
  let newIntensity = fire.intensity;
  newIntensity *= humidityFactor * windFactor;
  
  // Decay over time
  newIntensity -= ENVIRONMENT.FIRE_DECAY_RATE * dt;
  
  // Boost from fuel
  if (fuelAvailable > 0.5 && newIntensity < 1) {
    newIntensity += 0.01 * dt * fuelAvailable;
  }
  
  newIntensity = Math.max(0, Math.min(1, newIntensity));
  
  // Temperature follows intensity
  const newTemperature = 300 + newIntensity * (ENVIRONMENT.FIRE_TEMPERATURE - 300);
  
  // Spread chance increases with intensity and wind
  const newSpreadChance = newIntensity * 0.3 * windFactor;
  
  return {
    ...fire,
    intensity: newIntensity,
    fuel: newFuel,
    temperature: newTemperature,
    burnTime: fire.burnTime + dt,
    spreadChance: newSpreadChance,
  };
}

export function computeFireSpreadDirection(
  fire: FireCell,
  windDirection: number,
  windSpeed: number,
  terrainSlope: number,
  terrainAspect: number
): Vec3 {
  // Wind pushes fire
  const windRad = windDirection * Math.PI / 180;
  const windX = Math.sin(windRad) * windSpeed * 0.1;
  const windZ = Math.cos(windRad) * windSpeed * 0.1;
  
  // Fire spreads uphill faster
  const slopeRad = terrainAspect * Math.PI / 180;
  const slopeFactor = Math.tan(terrainSlope * Math.PI / 180) * 0.5;
  const slopeX = Math.sin(slopeRad) * slopeFactor;
  const slopeZ = Math.cos(slopeRad) * slopeFactor;
  
  // Random spread
  const randomAngle = Math.random() * Math.PI * 2;
  const randomMag = Math.random() * 0.3;
  const randomX = Math.sin(randomAngle) * randomMag;
  const randomZ = Math.cos(randomAngle) * randomMag;
  
  return vec3.normalize({
    x: windX + slopeX + randomX,
    y: 0,
    z: windZ + slopeZ + randomZ,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// SMOKE & GAS SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface SmokeParticle {
  position: Vec3;
  velocity: Vec3;
  density: number;         // 0-1
  temperature: number;     // Kelvin
  age: number;             // Seconds
  size: number;            // Meters (radius)
}

export type GasType =
  | 'Smoke'
  | 'Steam'
  | 'Dust'
  | 'ChemicalAgent'
  | 'RadioactiveDust';

export interface GasCloud {
  id: string;
  type: GasType;
  position: Vec3;
  radius: number;
  concentration: number;   // 0-1
  temperature: number;
  velocity: Vec3;
  decayRate: number;
  hazardLevel: number;     // 0-1
}

export function createSmokeParticle(
  position: Vec3,
  initialVelocity: Vec3,
  temperature: number
): SmokeParticle {
  return {
    position,
    velocity: initialVelocity,
    density: 0.8,
    temperature,
    age: 0,
    size: 1 + Math.random() * 2,
  };
}

export function updateSmokeParticle(
  particle: SmokeParticle,
  dt: number,
  wind: Vec3,
  ambientTemp: number
): SmokeParticle {
  // Buoyancy: hot smoke rises
  const buoyancy = (particle.temperature - ambientTemp) / 1000 * ENVIRONMENT.SMOKE_RISE_RATE;
  
  // Wind influence
  const windInfluence = 0.3;
  
  // Update velocity
  const newVelocity: Vec3 = {
    x: particle.velocity.x * 0.98 + wind.x * windInfluence * dt,
    y: particle.velocity.y * 0.95 + buoyancy * dt,
    z: particle.velocity.z * 0.98 + wind.z * windInfluence * dt,
  };
  
  // Update position
  const newPosition = vec3.add(particle.position, vec3.scale(newVelocity, dt));
  
  // Cool down
  const cooling = (particle.temperature - ambientTemp) * 0.1 * dt;
  const newTemp = Math.max(ambientTemp, particle.temperature - cooling);
  
  // Density decreases (dispersal)
  const newDensity = particle.density * (1 - ENVIRONMENT.SMOKE_DECAY_RATE * dt);
  
  // Size increases as it disperses
  const newSize = particle.size * (1 + 0.05 * dt);
  
  return {
    position: newPosition,
    velocity: newVelocity,
    density: newDensity,
    temperature: newTemp,
    age: particle.age + dt,
    size: newSize,
  };
}

export function createGasCloud(
  id: string,
  type: GasType,
  position: Vec3,
  initialRadius: number,
  concentration: number
): GasCloud {
  const hazardLevel: Record<GasType, number> = {
    Smoke: 0.3,
    Steam: 0.1,
    Dust: 0.2,
    ChemicalAgent: 0.9,
    RadioactiveDust: 1.0,
  };
  
  const decayRate: Record<GasType, number> = {
    Smoke: 0.05,
    Steam: 0.1,
    Dust: 0.03,
    ChemicalAgent: 0.01,
    RadioactiveDust: 0.001,
  };
  
  return {
    id,
    type,
    position,
    radius: initialRadius,
    concentration,
    temperature: 300,
    velocity: vec3.zero(),
    decayRate: decayRate[type],
    hazardLevel: hazardLevel[type],
  };
}

export function updateGasCloud(
  cloud: GasCloud,
  dt: number,
  wind: Vec3
): GasCloud {
  // Move with wind
  const newPosition = vec3.add(
    cloud.position,
    vec3.scale(vec3.add(cloud.velocity, vec3.scale(wind, 0.5)), dt)
  );
  
  // Expand
  const newRadius = cloud.radius * (1 + 0.02 * dt);
  
  // Decay concentration
  const newConcentration = cloud.concentration * (1 - cloud.decayRate * dt);
  
  return {
    ...cloud,
    position: newPosition,
    radius: newRadius,
    concentration: newConcentration,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESTRUCTION SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface Crater {
  position: Vec3;
  radius: number;
  depth: number;
  age: number;
}

export interface Debris {
  id: string;
  position: Vec3;
  velocity: Vec3;
  angularVelocity: Vec3;
  mass: number;
  size: number;
  material: 'Concrete' | 'Metal' | 'Wood' | 'Glass' | 'Earth';
  damage: number;          // Damage it can cause on impact
}

export interface StructuralDamage {
  structureId: string;
  position: Vec3;
  integrity: number;       // 0-1 (0 = destroyed)
  damageType: 'Blast' | 'Fire' | 'Kinetic' | 'Collapse';
  collapsed: boolean;
}

export function createCrater(position: Vec3, yieldKgTnt: number): Crater {
  const sqrtYield = Math.sqrt(yieldKgTnt);
  return {
    position,
    radius: ENVIRONMENT.CRATER_RADIUS_FACTOR * sqrtYield,
    depth: ENVIRONMENT.CRATER_DEPTH_FACTOR * sqrtYield,
    age: 0,
  };
}

export function createDebris(
  position: Vec3,
  explosionCenter: Vec3,
  yieldKgTnt: number,
  material: Debris['material']
): Debris {
  const direction = vec3.normalize(vec3.sub(position, explosionCenter));
  const distance = vec3.distance(position, explosionCenter);
  const velocityMag = ENVIRONMENT.DEBRIS_VELOCITY_FACTOR * Math.sqrt(yieldKgTnt) / 
                      (1 + distance * 0.1);
  
  // Add upward component
  const velocity: Vec3 = {
    x: direction.x * velocityMag,
    y: Math.abs(direction.y) * velocityMag + velocityMag * 0.5,
    z: direction.z * velocityMag,
  };
  
  const massPerMaterial: Record<Debris['material'], number> = {
    Concrete: 50,
    Metal: 30,
    Wood: 10,
    Glass: 5,
    Earth: 40,
  };
  
  return {
    id: `debris_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    position,
    velocity,
    angularVelocity: {
      x: (Math.random() - 0.5) * 10,
      y: (Math.random() - 0.5) * 10,
      z: (Math.random() - 0.5) * 10,
    },
    mass: massPerMaterial[material] * (0.5 + Math.random()),
    size: 0.5 + Math.random() * 2,
    material,
    damage: velocityMag * massPerMaterial[material] * 0.1,
  };
}

export function updateDebris(
  debris: Debris,
  dt: number,
  gravity: number = 9.8
): Debris {
  // Gravity
  const newVelocity: Vec3 = {
    x: debris.velocity.x * 0.99, // Air resistance
    y: debris.velocity.y - gravity * dt,
    z: debris.velocity.z * 0.99,
  };
  
  const newPosition = vec3.add(debris.position, vec3.scale(newVelocity, dt));
  
  // Reduce damage over time (energy loss)
  const newDamage = debris.damage * 0.99;
  
  return {
    ...debris,
    position: newPosition,
    velocity: newVelocity,
    damage: newDamage,
  };
}

export function computeStructuralDamage(
  currentIntegrity: number,
  blastOverpressure: number,
  fireExposure: number,
  kineticImpact: number,
  materialStrength: number
): { newIntegrity: number; damageType: StructuralDamage['damageType']; collapsed: boolean } {
  let damage = 0;
  let primaryType: StructuralDamage['damageType'] = 'Blast';
  
  // Blast damage (overpressure)
  const blastDamage = blastOverpressure / (materialStrength * 100);
  damage += blastDamage;
  
  // Fire damage (cumulative)
  const fireDamage = fireExposure * 0.01;
  if (fireDamage > blastDamage) primaryType = 'Fire';
  damage += fireDamage;
  
  // Kinetic damage
  const kineticDamage = kineticImpact / (materialStrength * 1000);
  if (kineticDamage > blastDamage && kineticDamage > fireDamage) primaryType = 'Kinetic';
  damage += kineticDamage;
  
  const newIntegrity = Math.max(0, currentIntegrity - damage);
  
  // Collapse threshold
  const collapsed = newIntegrity < 0.2;
  if (collapsed) primaryType = 'Collapse';
  
  return { newIntegrity, damageType: primaryType, collapsed };
}

// ═══════════════════════════════════════════════════════════════════════════════
// RADIATION SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface RadiationSource {
  id: string;
  position: Vec3;
  intensity: number;       // mSv/hr at 1 meter
  halfLife: number;        // Seconds
  age: number;             // Seconds since creation
  radius: number;          // Effective radius
}

export function createRadiationSource(
  position: Vec3,
  initialIntensity: number,
  halfLife: number = ENVIRONMENT.RADIATION_DECAY_HALF_LIFE
): RadiationSource {
  return {
    id: `rad_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    position,
    intensity: initialIntensity,
    halfLife,
    age: 0,
    radius: Math.sqrt(initialIntensity) * 10,
  };
}

export function updateRadiationSource(source: RadiationSource, dt: number): RadiationSource {
  const newAge = source.age + dt;
  
  // Exponential decay
  const decayFactor = Math.pow(0.5, dt / source.halfLife);
  const newIntensity = source.intensity * decayFactor;
  
  return {
    ...source,
    age: newAge,
    intensity: newIntensity,
  };
}

export function computeRadiationDose(
  sources: RadiationSource[],
  position: Vec3,
  exposureTime: number
): number {
  let totalDoseRate = 0;
  
  for (const source of sources) {
    const distance = Math.max(1, vec3.distance(position, source.position));
    
    // Inverse square law
    const doseRate = source.intensity / (distance * distance);
    totalDoseRate += doseRate;
  }
  
  // Convert to dose (mSv)
  return totalDoseRate * (exposureTime / 3600); // hr to seconds
}

// ═══════════════════════════════════════════════════════════════════════════════
// ENVIRONMENTAL MEMORY
// ═══════════════════════════════════════════════════════════════════════════════

export interface EnvironmentalEvent {
  id: string;
  type: 'Explosion' | 'Fire' | 'Contamination' | 'Destruction';
  position: Vec3;
  timestamp: number;
  magnitude: number;
  effects: string[];
}

export interface EnvironmentalMemory {
  events: EnvironmentalEvent[];
  craters: Crater[];
  burnedAreas: { position: Vec3; radius: number; severity: number }[];
  contaminatedAreas: { position: Vec3; radius: number; type: GasType; level: number }[];
  destroyedStructures: string[];
}

export function createEnvironmentalMemory(): EnvironmentalMemory {
  return {
    events: [],
    craters: [],
    burnedAreas: [],
    contaminatedAreas: [],
    destroyedStructures: [],
  };
}

export function recordEvent(
  memory: EnvironmentalMemory,
  event: EnvironmentalEvent
): EnvironmentalMemory {
  return {
    ...memory,
    events: [...memory.events, event].slice(-1000), // Keep last 1000 events
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ENVIRONMENT ENGINE — WIRED TO ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════

export interface EnvironmentState {
  fires: Map<string, FireCell>;
  smokeParticles: SmokeParticle[];
  gasClouds: Map<string, GasCloud>;
  debris: Map<string, Debris>;
  craters: Crater[];
  radiationSources: Map<string, RadiationSource>;
  structuralDamage: Map<string, StructuralDamage>;
  memory: EnvironmentalMemory;
  tick: number;
  
  // Architecture integration
  coherence: number;
  stabilityBudget: number;
  lawCompliance: number;
  totalDamage: number;
}

export class WorldEnvironmentEngine {
  private state: EnvironmentState;
  private maxParticles: number = 5000;
  private maxFires: number = 200;
  
  constructor() {
    this.state = {
      fires: new Map(),
      smokeParticles: [],
      gasClouds: new Map(),
      debris: new Map(),
      craters: [],
      radiationSources: new Map(),
      structuralDamage: new Map(),
      memory: createEnvironmentalMemory(),
      tick: 0,
      coherence: 1.0,
      stabilityBudget: 100.0,
      lawCompliance: 1.0,
      totalDamage: 0,
    };
  }
  
  get currentState(): EnvironmentState {
    return this.state;
  }
  
  // Wire to architecture
  setOrganismState(coherence: number, stabilityBudget: number): void {
    this.state.coherence = coherence;
    this.state.stabilityBudget = stabilityBudget;
  }
  
  // Fire management
  ignite(position: Vec3, intensity: number = 0.5): string | null {
    const cost = intensity * 5;
    if (this.state.stabilityBudget < cost || this.state.fires.size >= this.maxFires) {
      return null;
    }
    
    this.state.stabilityBudget -= cost;
    
    const id = `fire_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    const fire = createFire(position, intensity);
    this.state.fires.set(id, fire);
    
    return id;
  }
  
  extinguish(fireId: string): boolean {
    return this.state.fires.delete(fireId);
  }
  
  // Explosion effects
  processExplosion(position: Vec3, yieldKgTnt: number): void {
    const cost = yieldKgTnt * 2;
    if (this.state.stabilityBudget < cost) return;
    
    this.state.stabilityBudget -= cost;
    this.state.totalDamage += yieldKgTnt;
    
    // Create crater
    const crater = createCrater(position, yieldKgTnt);
    this.state.craters.push(crater);
    
    // Create debris
    const numDebris = Math.min(50, Math.floor(yieldKgTnt));
    const materials: Debris['material'][] = ['Concrete', 'Metal', 'Wood', 'Glass', 'Earth'];
    
    for (let i = 0; i < numDebris; i++) {
      const angle = Math.random() * Math.PI * 2;
      const dist = 5 + Math.random() * crater.radius;
      const debrisPos: Vec3 = {
        x: position.x + Math.cos(angle) * dist,
        y: position.y + Math.random() * 5,
        z: position.z + Math.sin(angle) * dist,
      };
      
      const debris = createDebris(
        debrisPos,
        position,
        yieldKgTnt,
        materials[Math.floor(Math.random() * materials.length)]
      );
      
      this.state.debris.set(debris.id, debris);
    }
    
    // Create smoke
    for (let i = 0; i < 20; i++) {
      const smokePos: Vec3 = {
        x: position.x + (Math.random() - 0.5) * crater.radius,
        y: position.y + Math.random() * 10,
        z: position.z + (Math.random() - 0.5) * crater.radius,
      };
      
      const particle = createSmokeParticle(
        smokePos,
        { x: (Math.random() - 0.5) * 10, y: 5 + Math.random() * 10, z: (Math.random() - 0.5) * 10 },
        800 + Math.random() * 400
      );
      
      this.state.smokeParticles.push(particle);
    }
    
    // May start fires
    if (Math.random() < 0.5) {
      const firePos: Vec3 = {
        x: position.x + (Math.random() - 0.5) * crater.radius * 2,
        y: position.y,
        z: position.z + (Math.random() - 0.5) * crater.radius * 2,
      };
      this.ignite(firePos, 0.3 + Math.random() * 0.5);
    }
    
    // Record event
    this.state.memory = recordEvent(this.state.memory, {
      id: `exp_${Date.now()}`,
      type: 'Explosion',
      position,
      timestamp: Date.now(),
      magnitude: yieldKgTnt,
      effects: ['crater', 'debris', 'smoke', 'potential_fire'],
    });
  }
  
  // Gas cloud management
  releaseGas(type: GasType, position: Vec3, radius: number, concentration: number): string {
    const id = `gas_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    const cloud = createGasCloud(id, type, position, radius, concentration);
    this.state.gasClouds.set(id, cloud);
    return id;
  }
  
  // Radiation
  addRadiationSource(position: Vec3, intensity: number): string {
    const source = createRadiationSource(position, intensity);
    this.state.radiationSources.set(source.id, source);
    return source.id;
  }
  
  getRadiationAt(position: Vec3, exposureTime: number): number {
    return computeRadiationDose(
      Array.from(this.state.radiationSources.values()),
      position,
      exposureTime
    );
  }
  
  // Update loop
  tick(dt: number, wind: Vec3, humidity: number, ambientTemp: number): void {
    this.state.tick++;
    
    // Scale by coherence
    const effectiveDt = dt * this.state.coherence;
    
    // Update fires
    const firesToRemove: string[] = [];
    const firesToAdd: FireCell[] = [];
    
    for (const [id, fire] of this.state.fires) {
      const windSpeed = vec3.length(wind);
      const windDir = Math.atan2(wind.x, wind.z) * 180 / Math.PI;
      
      const updated = updateFire(fire, effectiveDt, windSpeed, windDir, humidity, 0.8);
      
      if (updated.intensity <= 0.05) {
        firesToRemove.push(id);
        
        // Record burned area
        this.state.memory.burnedAreas.push({
          position: fire.position,
          radius: 3,
          severity: fire.burnTime / 60,
        });
      } else {
        this.state.fires.set(id, updated);
        
        // Spread fire
        if (Math.random() < updated.spreadChance * effectiveDt && this.state.fires.size < this.maxFires) {
          const spreadDir = computeFireSpreadDirection(updated, windDir, windSpeed, 10, 0);
          const spreadDist = 2 + Math.random() * 5;
          const newPos: Vec3 = {
            x: updated.position.x + spreadDir.x * spreadDist,
            y: updated.position.y,
            z: updated.position.z + spreadDir.z * spreadDist,
          };
          
          firesToAdd.push(createFire(newPos, updated.intensity * 0.7));
        }
        
        // Generate smoke
        if (this.state.smokeParticles.length < this.maxParticles && Math.random() < 0.3) {
          const smokePos: Vec3 = {
            x: updated.position.x + (Math.random() - 0.5) * 2,
            y: updated.position.y + 1,
            z: updated.position.z + (Math.random() - 0.5) * 2,
          };
          
          this.state.smokeParticles.push(
            createSmokeParticle(smokePos, { x: 0, y: 2, z: 0 }, updated.temperature)
          );
        }
      }
    }
    
    for (const id of firesToRemove) {
      this.state.fires.delete(id);
    }
    
    for (const fire of firesToAdd) {
      const id = `fire_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
      this.state.fires.set(id, fire);
    }
    
    // Update smoke
    this.state.smokeParticles = this.state.smokeParticles
      .map(p => updateSmokeParticle(p, effectiveDt, wind, ambientTemp))
      .filter(p => p.density > 0.01 && p.age < 60);
    
    // Update gas clouds
    const cloudsToRemove: string[] = [];
    for (const [id, cloud] of this.state.gasClouds) {
      const updated = updateGasCloud(cloud, effectiveDt, wind);
      if (updated.concentration < 0.01) {
        cloudsToRemove.push(id);
      } else {
        this.state.gasClouds.set(id, updated);
      }
    }
    for (const id of cloudsToRemove) {
      this.state.gasClouds.delete(id);
    }
    
    // Update debris
    const debrisToRemove: string[] = [];
    for (const [id, debris] of this.state.debris) {
      const updated = updateDebris(debris, effectiveDt);
      if (updated.position.y < 0) {
        debrisToRemove.push(id);
      } else {
        this.state.debris.set(id, updated);
      }
    }
    for (const id of debrisToRemove) {
      this.state.debris.delete(id);
    }
    
    // Update radiation
    for (const [id, source] of this.state.radiationSources) {
      const updated = updateRadiationSource(source, effectiveDt);
      if (updated.intensity < 0.1) {
        this.state.radiationSources.delete(id);
      } else {
        this.state.radiationSources.set(id, updated);
      }
    }
    
    // Update law compliance based on damage
    const damageNormalized = Math.min(1, this.state.totalDamage / 1000);
    this.state.lawCompliance = Math.max(0.3, 1 - damageNormalized * 0.7);
  }
  
  // Query methods
  getFiresNear(position: Vec3, radius: number): FireCell[] {
    const result: FireCell[] = [];
    for (const fire of this.state.fires.values()) {
      if (vec3.distance(fire.position, position) <= radius) {
        result.push(fire);
      }
    }
    return result;
  }
  
  getHazardsAt(position: Vec3): {
    fire: boolean;
    smoke: number;
    radiation: number;
    gas: GasCloud | null;
  } {
    let inFire = false;
    let smokeDensity = 0;
    let gasCloud: GasCloud | null = null;
    
    // Check fires
    for (const fire of this.state.fires.values()) {
      if (vec3.distance(fire.position, position) < 3) {
        inFire = true;
        break;
      }
    }
    
    // Check smoke
    for (const particle of this.state.smokeParticles) {
      const dist = vec3.distance(particle.position, position);
      if (dist < particle.size) {
        smokeDensity += particle.density * (1 - dist / particle.size);
      }
    }
    
    // Check gas clouds
    for (const cloud of this.state.gasClouds.values()) {
      const dist = vec3.distance(cloud.position, position);
      if (dist < cloud.radius && (!gasCloud || cloud.hazardLevel > gasCloud.hazardLevel)) {
        gasCloud = cloud;
      }
    }
    
    return {
      fire: inFire,
      smoke: Math.min(1, smokeDensity),
      radiation: this.getRadiationAt(position, 1),
      gas: gasCloud,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SINGLETON
// ═══════════════════════════════════════════════════════════════════════════════

export const worldEnvironment = new WorldEnvironmentEngine();
