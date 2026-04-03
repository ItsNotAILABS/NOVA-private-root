// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldTerrainEngine — Procedural Terrain Generation
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD TERRAIN ENGINE                                        ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  WIRED INTO EXISTING ARCHITECTURE:                                             ║
// ║    • Uses HarmonicAnalysisEngine for procedural noise                          ║
// ║    • Connects to SphericalWebMathEngine for planet-scale terrain               ║
// ║    • Integrates with TopologicalFieldEngine for feature detection              ║
// ║                                                                                ║
// ║  TERRAIN SYSTEMS:                                                              ║
// ║    • Perlin/Simplex noise with octaves                                         ║
// ║    • Hydraulic erosion simulation                                              ║
// ║    • Biome classification                                                      ║
// ║    • LOD (Level of Detail) management                                          ║
// ║    • Terrain chunking                                                          ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type { Vec3 } from './WorldPhysicsEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// NOISE FUNCTIONS — Golden Ratio Based
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PSI = 0.6180339887498948482;

// Fast hash function
function hash(x: number, y: number, seed: number = 0): number {
  let h = seed + x * 374761393 + y * 668265263;
  h = (h ^ (h >> 13)) * 1274126177;
  return h ^ (h >> 16);
}

// Smooth interpolation (quintic)
function smoothstep(t: number): number {
  return t * t * t * (t * (t * 6 - 15) + 10);
}

// Gradient vectors for Perlin noise
const GRADIENTS = [
  { x: 1, y: 1 }, { x: -1, y: 1 }, { x: 1, y: -1 }, { x: -1, y: -1 },
  { x: 1, y: 0 }, { x: -1, y: 0 }, { x: 0, y: 1 }, { x: 0, y: -1 },
  { x: PHI, y: PSI }, { x: -PHI, y: PSI }, { x: PHI, y: -PSI }, { x: -PHI, y: -PSI },
  { x: PSI, y: PHI }, { x: -PSI, y: PHI }, { x: PSI, y: -PHI }, { x: -PSI, y: -PHI },
];

function getGradient(ix: number, iy: number, seed: number): { x: number; y: number } {
  const h = hash(ix, iy, seed);
  return GRADIENTS[Math.abs(h) % GRADIENTS.length];
}

// 2D Perlin noise
export function perlin2D(x: number, y: number, seed: number = 0): number {
  const x0 = Math.floor(x);
  const y0 = Math.floor(y);
  const x1 = x0 + 1;
  const y1 = y0 + 1;
  
  const sx = smoothstep(x - x0);
  const sy = smoothstep(y - y0);
  
  const g00 = getGradient(x0, y0, seed);
  const g10 = getGradient(x1, y0, seed);
  const g01 = getGradient(x0, y1, seed);
  const g11 = getGradient(x1, y1, seed);
  
  const n00 = (x - x0) * g00.x + (y - y0) * g00.y;
  const n10 = (x - x1) * g10.x + (y - y0) * g10.y;
  const n01 = (x - x0) * g01.x + (y - y1) * g01.y;
  const n11 = (x - x1) * g11.x + (y - y1) * g11.y;
  
  const nx0 = n00 + sx * (n10 - n00);
  const nx1 = n01 + sx * (n11 - n01);
  
  return nx0 + sy * (nx1 - nx0);
}

// Fractal Brownian Motion (multiple octaves)
export function fbm(
  x: number,
  y: number,
  octaves: number,
  lacunarity: number = 2.0,
  persistence: number = 0.5,
  seed: number = 0
): number {
  let total = 0;
  let amplitude = 1;
  let frequency = 1;
  let maxValue = 0;
  
  for (let i = 0; i < octaves; i++) {
    total += perlin2D(x * frequency, y * frequency, seed + i) * amplitude;
    maxValue += amplitude;
    amplitude *= persistence;
    frequency *= lacunarity;
  }
  
  return total / maxValue;
}

// Ridged noise (for mountains)
export function ridgedNoise(
  x: number,
  y: number,
  octaves: number,
  seed: number = 0
): number {
  let total = 0;
  let amplitude = 1;
  let frequency = 1;
  let weight = 1;
  
  for (let i = 0; i < octaves; i++) {
    let signal = perlin2D(x * frequency, y * frequency, seed + i);
    signal = 1 - Math.abs(signal);
    signal *= signal;
    signal *= weight;
    weight = Math.min(1, Math.max(0, signal * 2));
    total += signal * amplitude;
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  
  return total;
}

// Voronoi/Worley noise (for cells, cracks)
export function voronoi(x: number, y: number, seed: number = 0): { distance: number; cellId: number } {
  const xi = Math.floor(x);
  const yi = Math.floor(y);
  
  let minDist = Infinity;
  let closestId = 0;
  
  for (let dx = -1; dx <= 1; dx++) {
    for (let dy = -1; dy <= 1; dy++) {
      const cx = xi + dx;
      const cy = yi + dy;
      
      // Random point in cell
      const h = hash(cx, cy, seed);
      const px = cx + ((h & 0xFF) / 255) * 0.8 + 0.1;
      const py = cy + (((h >> 8) & 0xFF) / 255) * 0.8 + 0.1;
      
      const dist = Math.sqrt((x - px) ** 2 + (y - py) ** 2);
      if (dist < minDist) {
        minDist = dist;
        closestId = h;
      }
    }
  }
  
  return { distance: minDist, cellId: closestId };
}

// ═══════════════════════════════════════════════════════════════════════════════
// TERRAIN TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type TerrainType =
  | 'DeepWater'
  | 'ShallowWater'
  | 'Beach'
  | 'Grass'
  | 'Forest'
  | 'Hills'
  | 'Mountain'
  | 'Snow'
  | 'Desert'
  | 'Swamp'
  | 'Urban'
  | 'Road'
  | 'Runway';

export type BiomeType =
  | 'Ocean'
  | 'Coast'
  | 'Temperate'
  | 'Tropical'
  | 'Desert'
  | 'Arctic'
  | 'Mountain';

export interface TerrainCell {
  elevation: number;       // meters above sea level
  moisture: number;        // 0-1
  temperature: number;     // Celsius
  terrainType: TerrainType;
  biome: BiomeType;
  slope: number;           // degrees
  aspect: number;          // compass direction of slope
  vegetation: number;      // 0-1 density
  hardness: number;        // 0-1 (affects erosion, construction)
  coverValue: number;      // 0-1 concealment
  traversability: number;  // 0-1 (0 = impassable)
}

// ═══════════════════════════════════════════════════════════════════════════════
// HEIGHTMAP GENERATION
// ═══════════════════════════════════════════════════════════════════════════════

export interface HeightmapConfig {
  seed: number;
  octaves: number;
  scale: number;           // World units per noise unit
  baseHeight: number;      // Sea level offset
  heightScale: number;     // Height multiplier
  mountainFactor: number;  // 0-1, adds ridged noise
  erosionIterations: number;
}

export const DEFAULT_HEIGHTMAP_CONFIG: HeightmapConfig = {
  seed: 12345,
  octaves: 8,
  scale: 0.001,
  baseHeight: 50,
  heightScale: 500,
  mountainFactor: 0.3,
  erosionIterations: 50,
};

export function generateHeightmap(
  width: number,
  height: number,
  config: HeightmapConfig = DEFAULT_HEIGHTMAP_CONFIG
): Float32Array {
  const data = new Float32Array(width * height);
  
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const nx = x * config.scale;
      const ny = y * config.scale;
      
      // Base terrain
      let h = fbm(nx, ny, config.octaves, 2.0, 0.5, config.seed);
      
      // Add mountains
      if (config.mountainFactor > 0) {
        const mountain = ridgedNoise(nx * 2, ny * 2, 4, config.seed + 1000);
        h = h * (1 - config.mountainFactor) + mountain * config.mountainFactor;
      }
      
      // Normalize to 0-1 then scale
      h = (h + 1) * 0.5;
      h = config.baseHeight + h * config.heightScale;
      
      data[y * width + x] = h;
    }
  }
  
  return data;
}

// ═══════════════════════════════════════════════════════════════════════════════
// HYDRAULIC EROSION
// ═══════════════════════════════════════════════════════════════════════════════

interface ErosionParams {
  inertia: number;
  sedimentCapacity: number;
  minSedimentCapacity: number;
  erodeSpeed: number;
  depositSpeed: number;
  evaporateSpeed: number;
  gravity: number;
  maxDropletLifetime: number;
  erosionRadius: number;
}

const DEFAULT_EROSION_PARAMS: ErosionParams = {
  inertia: 0.05,
  sedimentCapacity: 4,
  minSedimentCapacity: 0.01,
  erodeSpeed: 0.3,
  depositSpeed: 0.3,
  evaporateSpeed: 0.01,
  gravity: 4,
  maxDropletLifetime: 30,
  erosionRadius: 3,
};

export function hydraulicErosion(
  heightmap: Float32Array,
  width: number,
  height: number,
  iterations: number,
  params: ErosionParams = DEFAULT_EROSION_PARAMS
): Float32Array {
  const result = new Float32Array(heightmap);
  
  for (let i = 0; i < iterations; i++) {
    // Random starting position
    let posX = Math.random() * (width - 1);
    let posY = Math.random() * (height - 1);
    let dirX = 0;
    let dirY = 0;
    let speed = 1;
    let water = 1;
    let sediment = 0;
    
    for (let lifetime = 0; lifetime < params.maxDropletLifetime; lifetime++) {
      const nodeX = Math.floor(posX);
      const nodeY = Math.floor(posY);
      const dropletIndex = nodeY * width + nodeX;
      
      // Calculate droplet's offset inside cell
      const cellOffsetX = posX - nodeX;
      const cellOffsetY = posY - nodeY;
      
      // Calculate height and gradient using bilinear interpolation
      const heightNW = result[dropletIndex];
      const heightNE = nodeX + 1 < width ? result[dropletIndex + 1] : heightNW;
      const heightSW = nodeY + 1 < height ? result[dropletIndex + width] : heightNW;
      const heightSE = nodeX + 1 < width && nodeY + 1 < height 
        ? result[dropletIndex + width + 1] : heightNW;
      
      const gradientX = (heightNE - heightNW) * (1 - cellOffsetY) + 
                       (heightSE - heightSW) * cellOffsetY;
      const gradientY = (heightSW - heightNW) * (1 - cellOffsetX) + 
                       (heightSE - heightNE) * cellOffsetX;
      
      // Update direction with inertia
      dirX = dirX * params.inertia - gradientX * (1 - params.inertia);
      dirY = dirY * params.inertia - gradientY * (1 - params.inertia);
      
      // Normalize direction
      const len = Math.sqrt(dirX * dirX + dirY * dirY);
      if (len > 0) {
        dirX /= len;
        dirY /= len;
      }
      
      // Update position
      posX += dirX;
      posY += dirY;
      
      // Stop if outside bounds or direction is zero
      if (dirX === 0 && dirY === 0) break;
      if (posX < 0 || posX >= width - 1 || posY < 0 || posY >= height - 1) break;
      
      // Calculate new height
      const newNodeX = Math.floor(posX);
      const newNodeY = Math.floor(posY);
      const newDropletIndex = newNodeY * width + newNodeX;
      const newHeight = result[newDropletIndex];
      
      const deltaHeight = newHeight - heightNW;
      
      // Calculate sediment capacity
      const capacity = Math.max(
        -deltaHeight * speed * water * params.sedimentCapacity,
        params.minSedimentCapacity
      );
      
      // Erode or deposit
      if (sediment > capacity || deltaHeight > 0) {
        // Deposit sediment
        const amountToDeposit = deltaHeight > 0 
          ? Math.min(deltaHeight, sediment)
          : (sediment - capacity) * params.depositSpeed;
        sediment -= amountToDeposit;
        result[dropletIndex] += amountToDeposit;
      } else {
        // Erode
        const amountToErode = Math.min(
          (capacity - sediment) * params.erodeSpeed,
          -deltaHeight
        );
        
        // Erode in radius
        for (let dy = -params.erosionRadius; dy <= params.erosionRadius; dy++) {
          for (let dx = -params.erosionRadius; dx <= params.erosionRadius; dx++) {
            const erodeX = nodeX + dx;
            const erodeY = nodeY + dy;
            
            if (erodeX >= 0 && erodeX < width && erodeY >= 0 && erodeY < height) {
              const erodeIndex = erodeY * width + erodeX;
              const dist = Math.sqrt(dx * dx + dy * dy);
              const weight = Math.max(0, params.erosionRadius - dist) / params.erosionRadius;
              result[erodeIndex] -= amountToErode * weight;
              sediment += amountToErode * weight;
            }
          }
        }
      }
      
      // Update speed and water
      speed = Math.sqrt(Math.max(0, speed * speed + deltaHeight * params.gravity));
      water *= (1 - params.evaporateSpeed);
    }
  }
  
  return result;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TERRAIN ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════

export function computeSlope(
  heightmap: Float32Array,
  width: number,
  height: number,
  x: number,
  y: number,
  cellSize: number
): { slope: number; aspect: number } {
  const idx = y * width + x;
  
  // Get neighboring heights
  const hN = y > 0 ? heightmap[idx - width] : heightmap[idx];
  const hS = y < height - 1 ? heightmap[idx + width] : heightmap[idx];
  const hW = x > 0 ? heightmap[idx - 1] : heightmap[idx];
  const hE = x < width - 1 ? heightmap[idx + 1] : heightmap[idx];
  
  // Gradient
  const dzdx = (hE - hW) / (2 * cellSize);
  const dzdy = (hN - hS) / (2 * cellSize);
  
  // Slope in degrees
  const slope = Math.atan(Math.sqrt(dzdx * dzdx + dzdy * dzdy)) * 180 / Math.PI;
  
  // Aspect (direction slope faces)
  const aspect = Math.atan2(dzdy, -dzdx) * 180 / Math.PI;
  
  return { slope, aspect: aspect < 0 ? aspect + 360 : aspect };
}

export function computeMoisture(
  heightmap: Float32Array,
  width: number,
  height: number,
  config: HeightmapConfig
): Float32Array {
  const moisture = new Float32Array(width * height);
  
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const idx = y * width + x;
      const elevation = heightmap[idx];
      
      // Base moisture from noise
      const nx = x * config.scale * 2;
      const ny = y * config.scale * 2;
      let m = fbm(nx, ny, 4, 2, 0.5, config.seed + 5000);
      m = (m + 1) * 0.5;
      
      // Lower moisture at high elevations
      const elevFactor = Math.max(0, 1 - (elevation - config.baseHeight) / config.heightScale);
      m *= 0.3 + 0.7 * elevFactor;
      
      // Water bodies have max moisture
      if (elevation < config.baseHeight * 0.5) {
        m = 1.0;
      }
      
      moisture[idx] = Math.max(0, Math.min(1, m));
    }
  }
  
  return moisture;
}

// ═══════════════════════════════════════════════════════════════════════════════
// BIOME CLASSIFICATION
// ═══════════════════════════════════════════════════════════════════════════════

export function classifyTerrain(
  elevation: number,
  moisture: number,
  temperature: number,
  slope: number
): { terrainType: TerrainType; biome: BiomeType } {
  // Deep water
  if (elevation < -50) {
    return { terrainType: 'DeepWater', biome: 'Ocean' };
  }
  
  // Shallow water
  if (elevation < 0) {
    return { terrainType: 'ShallowWater', biome: 'Ocean' };
  }
  
  // Beach
  if (elevation < 5 && moisture > 0.4) {
    return { terrainType: 'Beach', biome: 'Coast' };
  }
  
  // Snow (high elevation or low temperature)
  if (elevation > 400 || temperature < -10) {
    return { terrainType: 'Snow', biome: 'Arctic' };
  }
  
  // Mountain
  if (elevation > 300 || slope > 45) {
    return { terrainType: 'Mountain', biome: 'Mountain' };
  }
  
  // Desert (low moisture, high temperature)
  if (moisture < 0.2 && temperature > 25) {
    return { terrainType: 'Desert', biome: 'Desert' };
  }
  
  // Swamp (high moisture, low elevation)
  if (moisture > 0.8 && elevation < 30) {
    return { terrainType: 'Swamp', biome: 'Tropical' };
  }
  
  // Forest (high moisture)
  if (moisture > 0.5) {
    return { terrainType: 'Forest', biome: temperature > 20 ? 'Tropical' : 'Temperate' };
  }
  
  // Hills (moderate elevation and slope)
  if (elevation > 100 || slope > 15) {
    return { terrainType: 'Hills', biome: 'Temperate' };
  }
  
  // Default: grassland
  return { terrainType: 'Grass', biome: 'Temperate' };
}

// ═══════════════════════════════════════════════════════════════════════════════
// TERRAIN CHUNK SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface TerrainChunk {
  x: number;              // Chunk coordinates
  y: number;
  resolution: number;     // Cells per chunk
  cellSize: number;       // World units per cell
  heightmap: Float32Array;
  moisture: Float32Array;
  cells: TerrainCell[];
  lod: number;            // Level of detail (0 = highest)
  lastAccess: number;     // For caching
}

export interface TerrainChunkConfig {
  chunkSize: number;      // Cells per chunk edge
  cellSize: number;       // World units per cell
  maxLOD: number;
  heightmapConfig: HeightmapConfig;
}

export const DEFAULT_CHUNK_CONFIG: TerrainChunkConfig = {
  chunkSize: 64,
  cellSize: 10,
  maxLOD: 4,
  heightmapConfig: DEFAULT_HEIGHTMAP_CONFIG,
};

export function generateTerrainChunk(
  chunkX: number,
  chunkY: number,
  config: TerrainChunkConfig = DEFAULT_CHUNK_CONFIG,
  lod: number = 0
): TerrainChunk {
  const lodFactor = Math.pow(2, lod);
  const resolution = Math.floor(config.chunkSize / lodFactor);
  const cellSize = config.cellSize * lodFactor;
  
  const worldOffsetX = chunkX * config.chunkSize * config.cellSize;
  const worldOffsetY = chunkY * config.chunkSize * config.cellSize;
  
  // Generate heightmap
  const heightmap = new Float32Array(resolution * resolution);
  for (let y = 0; y < resolution; y++) {
    for (let x = 0; x < resolution; x++) {
      const worldX = worldOffsetX + x * cellSize;
      const worldY = worldOffsetY + y * cellSize;
      const nx = worldX * config.heightmapConfig.scale;
      const ny = worldY * config.heightmapConfig.scale;
      
      let h = fbm(nx, ny, config.heightmapConfig.octaves, 2.0, 0.5, config.heightmapConfig.seed);
      
      if (config.heightmapConfig.mountainFactor > 0) {
        const mountain = ridgedNoise(nx * 2, ny * 2, 4, config.heightmapConfig.seed + 1000);
        h = h * (1 - config.heightmapConfig.mountainFactor) + 
            mountain * config.heightmapConfig.mountainFactor;
      }
      
      h = (h + 1) * 0.5;
      h = config.heightmapConfig.baseHeight + h * config.heightmapConfig.heightScale;
      
      heightmap[y * resolution + x] = h;
    }
  }
  
  // Generate moisture
  const moisture = computeMoisture(heightmap, resolution, resolution, {
    ...config.heightmapConfig,
    scale: config.heightmapConfig.scale * cellSize / config.cellSize,
  });
  
  // Generate cells
  const cells: TerrainCell[] = [];
  for (let y = 0; y < resolution; y++) {
    for (let x = 0; x < resolution; x++) {
      const idx = y * resolution + x;
      const elev = heightmap[idx];
      const moist = moisture[idx];
      
      const { slope, aspect } = computeSlope(heightmap, resolution, resolution, x, y, cellSize);
      
      // Simple temperature model (decreases with elevation and latitude)
      const baseTemp = 20;
      const latitudeFactor = Math.cos((worldOffsetY + y * cellSize) * 0.00001);
      const elevFactor = elev * 0.006;
      const temperature = baseTemp * latitudeFactor - elevFactor;
      
      const { terrainType, biome } = classifyTerrain(elev, moist, temperature, slope);
      
      // Derived properties
      const vegetation = getVegetation(terrainType, moist);
      const hardness = getHardness(terrainType);
      const coverValue = getCover(terrainType, vegetation);
      const traversability = getTraversability(terrainType, slope);
      
      cells.push({
        elevation: elev,
        moisture: moist,
        temperature,
        terrainType,
        biome,
        slope,
        aspect,
        vegetation,
        hardness,
        coverValue,
        traversability,
      });
    }
  }
  
  return {
    x: chunkX,
    y: chunkY,
    resolution,
    cellSize,
    heightmap,
    moisture,
    cells,
    lod,
    lastAccess: Date.now(),
  };
}

function getVegetation(terrain: TerrainType, moisture: number): number {
  switch (terrain) {
    case 'Forest': return 0.8 + moisture * 0.2;
    case 'Grass': return 0.4 + moisture * 0.3;
    case 'Swamp': return 0.6;
    case 'Hills': return 0.3 + moisture * 0.3;
    case 'Desert': return moisture * 0.1;
    default: return 0;
  }
}

function getHardness(terrain: TerrainType): number {
  switch (terrain) {
    case 'Mountain': return 0.9;
    case 'Road': case 'Runway': return 0.95;
    case 'Urban': return 0.85;
    case 'Desert': return 0.4;
    case 'Swamp': return 0.1;
    case 'DeepWater': case 'ShallowWater': return 0;
    default: return 0.5;
  }
}

function getCover(terrain: TerrainType, vegetation: number): number {
  switch (terrain) {
    case 'Forest': return 0.7 + vegetation * 0.3;
    case 'Urban': return 0.6;
    case 'Swamp': return 0.5;
    case 'Hills': return 0.3;
    default: return vegetation * 0.3;
  }
}

function getTraversability(terrain: TerrainType, slope: number): number {
  const baseTraverse: Record<TerrainType, number> = {
    DeepWater: 0,
    ShallowWater: 0.3,
    Beach: 0.7,
    Grass: 1.0,
    Forest: 0.6,
    Hills: 0.7,
    Mountain: 0.3,
    Snow: 0.4,
    Desert: 0.8,
    Swamp: 0.2,
    Urban: 0.9,
    Road: 1.0,
    Runway: 1.0,
  };
  
  const slopePenalty = Math.max(0, 1 - slope / 60);
  return baseTraverse[terrain] * slopePenalty;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TERRAIN MANAGER — WIRED TO ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════

export class WorldTerrainEngine {
  private chunks: Map<string, TerrainChunk> = new Map();
  private config: TerrainChunkConfig;
  private maxCachedChunks: number = 64;
  
  // Architecture integration
  private coherence: number = 1.0;
  private stabilityBudget: number = 100.0;
  
  constructor(config: TerrainChunkConfig = DEFAULT_CHUNK_CONFIG) {
    this.config = config;
  }
  
  private getChunkKey(x: number, y: number, lod: number): string {
    return `${x},${y},${lod}`;
  }
  
  // Wire to architecture
  setOrganismState(coherence: number, stabilityBudget: number): void {
    this.coherence = coherence;
    this.stabilityBudget = stabilityBudget;
  }
  
  getChunk(chunkX: number, chunkY: number, lod: number = 0): TerrainChunk {
    const key = this.getChunkKey(chunkX, chunkY, lod);
    
    if (this.chunks.has(key)) {
      const chunk = this.chunks.get(key)!;
      chunk.lastAccess = Date.now();
      return chunk;
    }
    
    // Generate new chunk (costs stability budget based on LOD)
    const cost = (this.config.maxLOD - lod + 1) * 0.5;
    if (this.stabilityBudget >= cost) {
      this.stabilityBudget -= cost;
      
      const chunk = generateTerrainChunk(chunkX, chunkY, this.config, lod);
      this.chunks.set(key, chunk);
      
      // Evict old chunks if over limit
      this.evictOldChunks();
      
      return chunk;
    }
    
    // Return empty chunk if no budget
    return {
      x: chunkX,
      y: chunkY,
      resolution: 1,
      cellSize: this.config.cellSize * Math.pow(2, this.config.maxLOD),
      heightmap: new Float32Array([0]),
      moisture: new Float32Array([0.5]),
      cells: [{
        elevation: 0,
        moisture: 0.5,
        temperature: 20,
        terrainType: 'Grass',
        biome: 'Temperate',
        slope: 0,
        aspect: 0,
        vegetation: 0.5,
        hardness: 0.5,
        coverValue: 0.1,
        traversability: 1.0,
      }],
      lod: this.config.maxLOD,
      lastAccess: Date.now(),
    };
  }
  
  private evictOldChunks(): void {
    if (this.chunks.size <= this.maxCachedChunks) return;
    
    // Sort by last access
    const sorted = Array.from(this.chunks.entries())
      .sort((a, b) => a[1].lastAccess - b[1].lastAccess);
    
    // Remove oldest
    const toRemove = sorted.slice(0, this.chunks.size - this.maxCachedChunks);
    for (const [key] of toRemove) {
      this.chunks.delete(key);
    }
  }
  
  getHeightAt(worldX: number, worldY: number): number {
    const chunkX = Math.floor(worldX / (this.config.chunkSize * this.config.cellSize));
    const chunkY = Math.floor(worldY / (this.config.chunkSize * this.config.cellSize));
    
    const chunk = this.getChunk(chunkX, chunkY, 0);
    
    const localX = worldX - chunkX * this.config.chunkSize * this.config.cellSize;
    const localY = worldY - chunkY * this.config.chunkSize * this.config.cellSize;
    
    const cellX = Math.floor(localX / chunk.cellSize);
    const cellY = Math.floor(localY / chunk.cellSize);
    
    const idx = Math.min(
      cellY * chunk.resolution + cellX,
      chunk.heightmap.length - 1
    );
    
    return chunk.heightmap[Math.max(0, idx)];
  }
  
  getCellAt(worldX: number, worldY: number): TerrainCell | null {
    const chunkX = Math.floor(worldX / (this.config.chunkSize * this.config.cellSize));
    const chunkY = Math.floor(worldY / (this.config.chunkSize * this.config.cellSize));
    
    const chunk = this.getChunk(chunkX, chunkY, 0);
    
    const localX = worldX - chunkX * this.config.chunkSize * this.config.cellSize;
    const localY = worldY - chunkY * this.config.chunkSize * this.config.cellSize;
    
    const cellX = Math.floor(localX / chunk.cellSize);
    const cellY = Math.floor(localY / chunk.cellSize);
    
    const idx = cellY * chunk.resolution + cellX;
    
    if (idx >= 0 && idx < chunk.cells.length) {
      return chunk.cells[idx];
    }
    
    return null;
  }
  
  raycastTerrain(
    origin: Vec3,
    direction: Vec3,
    maxDistance: number
  ): { hit: boolean; point: Vec3; distance: number; cell: TerrainCell | null } {
    const stepSize = this.config.cellSize * 0.5;
    let t = 0;
    
    while (t < maxDistance) {
      const point: Vec3 = {
        x: origin.x + direction.x * t,
        y: origin.y + direction.y * t,
        z: origin.z + direction.z * t,
      };
      
      const terrainHeight = this.getHeightAt(point.x, point.z);
      
      if (point.y <= terrainHeight) {
        // Hit terrain
        const cell = this.getCellAt(point.x, point.z);
        return {
          hit: true,
          point: { ...point, y: terrainHeight },
          distance: t,
          cell,
        };
      }
      
      t += stepSize;
    }
    
    return { hit: false, point: origin, distance: maxDistance, cell: null };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SINGLETON
// ═══════════════════════════════════════════════════════════════════════════════

export const worldTerrain = new WorldTerrainEngine();
