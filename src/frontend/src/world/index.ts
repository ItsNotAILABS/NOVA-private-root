// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: World Module Index — Unified World System Export
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD SYSTEM — UNIFIED EXPORTS                              ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  This module exports all world simulation systems for use in the frontend:     ║
// ║                                                                                ║
// ║  ENGINES:                                                                      ║
// ║    • WorldPhysicsEngine — Rigid body dynamics, collisions, aerodynamics        ║
// ║    • WorldTerrainEngine — Procedural terrain, biomes, heightmaps               ║
// ║    • WorldWeatherEngine — Wind, precipitation, day/night cycle                 ║
// ║    • WorldEnvironmentEngine — Fire, destruction, hazards, radiation            ║
// ║    • WorldOrchestrator — Master integration, event dispatch                    ║
// ║                                                                                ║
// ║  WIRED TO ARCHITECTURE:                                                        ║
// ║    All engines connect to the backend Motoko organism through:                 ║
// ║    • Coherence (Kuramoto order parameter)                                      ║
// ║    • Stability budget                                                          ║
// ║    • Law compliance verification                                               ║
// ║    • Beat synchronization                                                      ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// PHYSICS ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Engine class and singleton
  WorldPhysicsEngine,
  worldPhysics,
  
  // Constants
  PHYSICS_CONSTANTS,
  
  // Vector math
  vec3,
  type Vec3,
  
  // Quaternion math
  quat,
  type Quaternion,
  
  // Rigid body
  type RigidBodyState,
  createRigidBody,
  integrateRigidBody,
  
  // Collision
  type CollisionInfo,
  detectSphereSphereCollision,
  resolveCollision,
  
  // Aerodynamics
  type AeroState,
  computeAerodynamicForces,
  computeGroundEffect,
  
  // Ballistics
  type ProjectileState,
  simulateProjectile,
  
  // Explosions
  type ExplosionParams,
  type BlastEffect,
  computeBlastEffect,
  applyBlastForce,
  
  // Fluid dynamics
  type FluidCell,
  type FluidGrid,
  createFluidGrid,
  advectFluid,
  
  // State
  type PhysicsWorldState,
} from './WorldPhysicsEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// TERRAIN ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Engine class and singleton
  WorldTerrainEngine,
  worldTerrain,
  
  // Noise functions
  perlin2D,
  fbm,
  ridgedNoise,
  voronoi,
  
  // Types
  type TerrainType,
  type BiomeType,
  type TerrainCell,
  
  // Heightmap
  type HeightmapConfig,
  DEFAULT_HEIGHTMAP_CONFIG,
  generateHeightmap,
  hydraulicErosion,
  
  // Analysis
  computeSlope,
  computeMoisture,
  classifyTerrain,
  
  // Chunks
  type TerrainChunk,
  type TerrainChunkConfig,
  DEFAULT_CHUNK_CONFIG,
  generateTerrainChunk,
} from './WorldTerrainEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// WEATHER ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Engine class and singleton
  WorldWeatherEngine,
  worldWeather,
  
  // Constants
  ATMOSPHERE,
  
  // Types
  type WeatherCondition,
  type CloudType,
  type WindCategory,
  type AtmosphericState,
  type WeatherCell,
  type CloudLayer,
  type TimeState,
  
  // Atmospheric calculations
  standardAtmosphere,
  saturationVaporPressure,
  dewPointTemperature,
  cloudBaseAltitude,
  
  // Wind
  type WindField,
  createWindField,
  generatePressureField,
  computeGeostrophicWind,
  addTurbulence,
  
  // Clouds
  classifyCloudType,
  generateCloudField,
  
  // Precipitation
  computePrecipitation,
  computeVisibility,
  
  // Classification
  classifyWeather,
  classifyWind,
  
  // Time
  computeSunPosition,
  computeLightLevel,
  getSeason,
} from './WorldWeatherEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// ENVIRONMENT ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Engine class and singleton
  WorldEnvironmentEngine,
  worldEnvironment,
  
  // Constants
  ENVIRONMENT,
  
  // Fire
  type FireCell,
  type FireConfig,
  DEFAULT_FIRE_CONFIG,
  createFire,
  updateFire,
  computeFireSpreadDirection,
  
  // Smoke and gas
  type SmokeParticle,
  type GasType,
  type GasCloud,
  createSmokeParticle,
  updateSmokeParticle,
  createGasCloud,
  updateGasCloud,
  
  // Destruction
  type Crater,
  type Debris,
  type StructuralDamage,
  createCrater,
  createDebris,
  updateDebris,
  computeStructuralDamage,
  
  // Radiation
  type RadiationSource,
  createRadiationSource,
  updateRadiationSource,
  computeRadiationDose,
  
  // Memory
  type EnvironmentalEvent,
  type EnvironmentalMemory,
  createEnvironmentalMemory,
  recordEvent,
  
  // State
  type EnvironmentState,
} from './WorldEnvironmentEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// ORCHESTRATOR
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Engine class and singleton
  WorldOrchestrator,
  worldOrchestrator,
  
  // Types
  type OrganismState,
  type DroneWorldState,
  type WorldEventType,
  type WorldEvent,
  type WorldEventHandler,
  type BeatContext,
  type WorldSummary,
  type Law,
  
  // Hook
  useWorldState,
} from './WorldOrchestrator';

// ═══════════════════════════════════════════════════════════════════════════════
// CONVENIENCE: FULL WORLD SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

import { worldOrchestrator } from './WorldOrchestrator';
import { worldPhysics } from './WorldPhysicsEngine';
import { worldTerrain } from './WorldTerrainEngine';
import { worldWeather } from './WorldWeatherEngine';
import { worldEnvironment } from './WorldEnvironmentEngine';

/**
 * Complete world system with all engines
 * Use this for convenience or access individual engines for specific features
 */
export const WorldSystem = {
  orchestrator: worldOrchestrator,
  physics: worldPhysics,
  terrain: worldTerrain,
  weather: worldWeather,
  environment: worldEnvironment,
  
  /**
   * Initialize world with organism state
   */
  init(organismState: {
    coherence: number;
    stabilityBudget: number;
  }): void {
    worldOrchestrator.updateOrganismState(organismState);
  },
  
  /**
   * Run one tick (call from animation loop or backend beat)
   */
  tick(dt: number) {
    return worldOrchestrator.tick(dt);
  },
  
  /**
   * Get complete world summary
   */
  getSummary() {
    return worldOrchestrator.getWorldSummary();
  },
  
  /**
   * Get current time state (day/night, season, etc.)
   */
  getTime() {
    return worldOrchestrator.getTimeState();
  },
};

export default WorldSystem;
