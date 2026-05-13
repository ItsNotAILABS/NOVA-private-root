// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: LivingWorldComputation — The World is ALIVE (REAL PHYSICS ENGINE)
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// EVERYTHING IS INTELLIGENCE — neural, cognitive, emergence, adaptation, scalability, computing, ML
// PHYSICS = REAL MATH AND GEOMETRY — NOT simulation. Simulations are fake. This is REAL.
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    LIVING WORLD COMPUTATION — REAL PHYSICS ENGINE (THE WORLD IS ALIVE)                   ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  The world is not a static backdrop. The world is ALIVE.                                                 ║
// ║                                                                                                          ║
// ║  PHYSICS:                                                                                                ║
// ║    • Gravity, wind, air density                                                                          ║
// ║    • Collisions (drone-drone, drone-terrain, drone-object)                                               ║
// ║    • Aerodynamics (lift, drag, ground effect)                                                            ║
// ║                                                                                                          ║
// ║  TERRAIN:                                                                                                ║
// ║    • Elevation map (hills, valleys, mountains)                                                           ║
// ║    • Surface types (water, forest, urban, desert)                                                        ║
// ║    • Cover and concealment                                                                               ║
// ║    • Line of sight blocking                                                                              ║
// ║                                                                                                          ║
// ║  WEATHER:                                                                                                ║
// ║    • Wind (speed, direction, gusts)                                                                      ║
// ║    • Precipitation (rain, snow — affects sensors)                                                        ║
// ║    • Visibility (fog, clouds)                                                                            ║
// ║    • Temperature (affects battery, lift)                                                                 ║
// ║                                                                                                          ║
// ║  TIME:                                                                                                   ║
// ║    • Day/night cycle (affects visibility, thermal)                                                       ║
// ║    • Seasons                                                                                             ║
// ║                                                                                                          ║
// ║  REACTIONS:                                                                                              ║
// ║    • Explosions create craters                                                                           ║
// ║    • Fire spreads                                                                                        ║
// ║    • Buildings can be destroyed                                                                          ║
// ║    • Environment remembers damage                                                                        ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// PHYSICAL CONSTANTS — Real world values
// ═══════════════════════════════════════════════════════════════════════════════

export const PHYSICS = {
  GRAVITY: 9.80665,                    // m/s² — Earth gravity
  AIR_DENSITY_SEA_LEVEL: 1.225,        // kg/m³ at 15°C sea level
  AIR_DENSITY_LAPSE_RATE: 0.0001,      // kg/m³ per meter altitude
  SPEED_OF_SOUND: 343,                 // m/s at 20°C
  
  // Drone physics
  DRAG_COEFFICIENT_QUAD: 1.0,          // Typical quadrotor
  DRAG_COEFFICIENT_FIXED: 0.02,        // Fixed wing
  LIFT_COEFFICIENT: 0.5,               // Typical airfoil
  GROUND_EFFECT_HEIGHT: 2.0,           // Rotor diameters
  GROUND_EFFECT_BOOST: 1.3,            // 30% thrust increase
  
  // Collision
  COLLISION_RESTITUTION: 0.3,          // Bounce factor
  COLLISION_DAMAGE_THRESHOLD: 5.0,     // m/s impact for damage
  
  // Thermal
  TEMP_LAPSE_RATE: 0.0065,             // °C per meter altitude
  BATTERY_COLD_PENALTY: 0.7,           // Battery capacity at -20°C
  BATTERY_HOT_PENALTY: 0.9,            // Battery capacity at +40°C
};

// ═══════════════════════════════════════════════════════════════════════════════
// WORLD TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type TerrainType = 
  | 'Water'
  | 'Sand'
  | 'Grass'
  | 'Forest'
  | 'Urban'
  | 'Mountain'
  | 'Snow'
  | 'Swamp'
  | 'Road'
  | 'Runway';

export type WeatherCondition =
  | 'Clear'
  | 'Cloudy'
  | 'Overcast'
  | 'Rain'
  | 'HeavyRain'
  | 'Storm'
  | 'Snow'
  | 'Fog'
  | 'Dust';

export type TimeOfDay =
  | 'Dawn'
  | 'Morning'
  | 'Noon'
  | 'Afternoon'
  | 'Dusk'
  | 'Night'
  | 'Midnight';

export interface Vector3 {
  x: number;
  y: number;
  z: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TERRAIN SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface TerrainCell {
  // Position
  gridX: number;
  gridZ: number;
  
  // Elevation
  elevation: number;              // meters above sea level
  slope: number;                  // degrees
  slopeDirection: number;         // degrees (direction of steepest descent)
  
  // Type and properties
  type: TerrainType;
  traversable: boolean;           // Can ground units cross?
  coverValue: number;             // 0-1 how much cover this provides
  concealmentValue: number;       // 0-1 how hard to see things here
  
  // Line of sight
  blocksLOS: boolean;             // Does this block line of sight?
  losHeight: number;              // How high does the blocking go?
  
  // Thermal properties
  thermalSignature: number;       // Background IR (affects thermal cameras)
  
  // State
  damaged: boolean;
  damageLevel: number;            // 0-1
  onFire: boolean;
  fireIntensity: number;
  smokeLevel: number;
  
  // Resources
  hasObjective: boolean;
  objectiveId?: string;
}

export interface TerrainMap {
  width: number;                  // Grid cells
  height: number;
  cellSize: number;               // Meters per cell
  cells: TerrainCell[][];
  
  // Heightmap for fast lookup
  heightmap: Float32Array;
  
  // Pre-computed normals for lighting/physics
  normals: Vector3[][];
}

// ═══════════════════════════════════════════════════════════════════════════════
// WEATHER SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface WeatherState {
  // Current conditions
  condition: WeatherCondition;
  
  // Wind
  windSpeed: number;              // m/s
  windDirection: number;          // degrees (from)
  windGustiness: number;          // 0-1 variability
  windGustSpeed: number;          // m/s max gusts
  windVertical: number;           // m/s (thermals, downdrafts)
  
  // Visibility
  visibility: number;             // meters
  cloudBase: number;              // meters AGL
  cloudTop: number;
  cloudCover: number;             // 0-1
  fogDensity: number;             // 0-1
  
  // Precipitation
  precipitationType: 'None' | 'Rain' | 'Snow' | 'Hail';
  precipitationIntensity: number; // mm/hour
  
  // Temperature
  temperature: number;            // °C at ground level
  humidity: number;               // 0-1
  pressure: number;               // hPa
  
  // Derived effects on drones
  sensorDegradation: number;      // 0-1 how much sensors are affected
  opticalDegradation: number;     // 0-1 camera quality reduction
  thermalContrast: number;        // 0-1 thermal camera effectiveness
  gpsAccuracyPenalty: number;     // meters added to GPS error
  communicationDegradation: number; // 0-1 signal quality reduction
}

export interface WeatherForecast {
  currentWeather: WeatherState;
  forecastedChanges: {
    timeOffset: number;           // minutes from now
    condition: WeatherCondition;
    windSpeed: number;
    visibility: number;
  }[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// TIME SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export interface WorldTime {
  // Absolute time
  totalSeconds: number;
  
  // Clock time
  hours: number;                  // 0-23
  minutes: number;
  seconds: number;
  
  // Calendar
  day: number;
  month: number;
  year: number;
  
  // Derived
  timeOfDay: TimeOfDay;
  isDaytime: boolean;
  sunAzimuth: number;             // degrees
  sunElevation: number;           // degrees (negative = below horizon)
  moonPhase: number;              // 0-1 (0=new, 0.5=full)
  
  // Lighting
  ambientLight: number;           // 0-1
  directLight: number;            // 0-1
  lightDirection: Vector3;
  
  // Simulation speed
  timeScale: number;              // 1.0 = real time
}

// ═══════════════════════════════════════════════════════════════════════════════
// WORLD OBJECTS
// ═══════════════════════════════════════════════════════════════════════════════

export type ObjectType =
  | 'Building'
  | 'Vehicle'
  | 'Tree'
  | 'Rock'
  | 'Wall'
  | 'Bridge'
  | 'Tower'
  | 'Antenna'
  | 'Runway'
  | 'Helipad'
  | 'SAM'
  | 'Radar'
  | 'Bunker'
  | 'Objective';

export interface WorldObject {
  id: string;
  type: ObjectType;
  
  // Position
  position: Vector3;
  rotation: Vector3;              // Euler angles
  
  // Dimensions
  size: Vector3;                  // Bounding box
  collisionShape: 'Box' | 'Sphere' | 'Cylinder' | 'Mesh';
  
  // Properties
  isStatic: boolean;
  isDestructible: boolean;
  health: number;                 // 0-1
  maxHealth: number;
  armor: number;                  // Damage reduction
  
  // Combat relevance
  isHostile: boolean;
  hasWeapons: boolean;
  weaponRange?: number;
  canDetect: boolean;
  detectionRange?: number;
  
  // Line of sight
  blocksLOS: boolean;
  provideCover: boolean;
  coverValue: number;
  
  // Thermal
  thermalSignature: number;
  isHeatSource: boolean;
  
  // State
  isDestroyed: boolean;
  onFire: boolean;
  fireIntensity: number;
  
  // Objective
  isObjective: boolean;
  objectiveType?: 'Capture' | 'Destroy' | 'Protect' | 'Recon';
  objectiveValue?: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// EFFECTS AND EVENTS
// ═══════════════════════════════════════════════════════════════════════════════

export interface WorldEffect {
  id: string;
  type: 'Explosion' | 'Fire' | 'Smoke' | 'Debris' | 'Crater' | 'Shockwave' | 'EMP';
  
  position: Vector3;
  radius: number;
  intensity: number;              // 0-1
  
  // Timing
  startTime: number;
  duration: number;
  currentTime: number;
  
  // Physics effects
  affectsDrones: boolean;
  damagePerSecond: number;
  forceMultiplier: number;        // Push drones away
  
  // Visual/sensor effects
  blocksLOS: boolean;
  blocksIR: boolean;
  blocksRadar: boolean;
  
  // Persistence
  leavesResidue: boolean;         // Crater, burn marks
  residueType?: string;
}

export interface WorldEvent {
  id: string;
  type: 'Impact' | 'Explosion' | 'Collision' | 'Destruction' | 'Detection' | 'WeaponFire';
  
  timestamp: number;
  position: Vector3;
  
  // Participants
  sourceId?: string;
  targetId?: string;
  
  // Details
  damage?: number;
  weaponType?: string;
  resultingEffect?: string;       // Effect ID
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIVING WORLD CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class LivingWorld {
  // World bounds
  private worldSize: Vector3;
  
  // Terrain
  private terrain: TerrainMap;
  
  // Weather
  private weather: WeatherState;
  private weatherUpdateInterval: number = 60;  // seconds
  private lastWeatherUpdate: number = 0;
  
  // Time
  private time: WorldTime;
  
  // Objects
  private objects: Map<string, WorldObject> = new Map();
  private objectSpatialIndex: SpatialIndex;
  
  // Effects
  private activeEffects: Map<string, WorldEffect> = new Map();
  
  // Events
  private eventLog: WorldEvent[] = [];
  private maxEventLogSize: number = 1000;
  
  // Simulation
  private beat: number = 0;
  private physicsSubsteps: number = 4;
  
  constructor(size: Vector3 = { x: 20000, y: 4000, z: 20000 }) {
    this.worldSize = size;
    
    // Initialize terrain
    this.terrain = this.generateTerrain(size);
    
    // Initialize weather
    this.weather = this.createDefaultWeather();
    
    // Initialize time
    this.time = this.createInitialTime();
    
    // Initialize spatial index
    this.objectSpatialIndex = new SpatialIndex(size, 1000);  // 1000m cells (20× expansion)
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TERRAIN GENERATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  private generateTerrain(size: Vector3): TerrainMap {
    const cellSize = 100;  // 100 meters per cell (20× expansion: 10m → 100m)
    const width = Math.ceil(size.x / cellSize);
    const height = Math.ceil(size.z / cellSize);
    
    const cells: TerrainCell[][] = [];
    const heightmap = new Float32Array(width * height);
    const normals: Vector3[][] = [];
    
    // Generate heightmap using fractal noise
    for (let z = 0; z < height; z++) {
      cells[z] = [];
      normals[z] = [];
      
      for (let x = 0; x < width; x++) {
        // Multi-octave noise for natural terrain
        let elevation = 0;
        let amplitude = 50;  // Base amplitude in meters
        let frequency = 0.005;
        
        for (let octave = 0; octave < 6; octave++) {
          const nx = x * frequency;
          const nz = z * frequency;
          
          // Simplex-like noise approximation
          elevation += amplitude * (
            Math.sin(nx * 1.7 + nz * 0.3) * 0.5 +
            Math.sin(nx * 0.4 + nz * 1.9) * 0.3 +
            Math.sin(nx * 2.1 - nz * 0.8) * 0.2
          );
          
          amplitude *= 0.5;
          frequency *= 2;
        }
        
        // Add base elevation
        elevation = Math.max(0, elevation + 30);
        
        heightmap[z * width + x] = elevation;
        
        // Determine terrain type based on elevation and noise
        const type = this.getTerrainTypeForElevation(elevation, x, z);
        
        cells[z][x] = {
          gridX: x,
          gridZ: z,
          elevation,
          slope: 0,  // Computed after
          slopeDirection: 0,
          type,
          traversable: type !== 'Water' && type !== 'Mountain',
          coverValue: this.getCoverForTerrainType(type),
          concealmentValue: this.getConcealmentForTerrainType(type),
          blocksLOS: type === 'Forest' || type === 'Urban',
          losHeight: type === 'Forest' ? 15 : type === 'Urban' ? 30 : 0,
          thermalSignature: this.getThermalForTerrainType(type),
          damaged: false,
          damageLevel: 0,
          onFire: false,
          fireIntensity: 0,
          smokeLevel: 0,
          hasObjective: false
        };
        
        normals[z][x] = { x: 0, y: 1, z: 0 };
      }
    }
    
    // Compute slopes and normals
    for (let z = 1; z < height - 1; z++) {
      for (let x = 1; x < width - 1; x++) {
        const h = heightmap[z * width + x];
        const hN = heightmap[(z - 1) * width + x];
        const hS = heightmap[(z + 1) * width + x];
        const hE = heightmap[z * width + x + 1];
        const hW = heightmap[z * width + x - 1];
        
        // Normal from height differences
        const nx = (hW - hE) / (2 * cellSize);
        const nz = (hN - hS) / (2 * cellSize);
        const len = Math.sqrt(nx * nx + 1 + nz * nz);
        
        normals[z][x] = { x: nx / len, y: 1 / len, z: nz / len };
        
        // Slope in degrees
        cells[z][x].slope = Math.atan(Math.sqrt(nx * nx + nz * nz)) * (180 / Math.PI);
        cells[z][x].slopeDirection = Math.atan2(nz, nx) * (180 / Math.PI);
      }
    }
    
    return { width, height, cellSize, cells, heightmap, normals };
  }
  
  private getTerrainTypeForElevation(elevation: number, x: number, z: number): TerrainType {
    // Add some noise to terrain type selection
    const noise = Math.sin(x * 0.1) * Math.cos(z * 0.1);
    
    if (elevation < 5) return 'Water';
    if (elevation < 10 + noise * 3) return 'Sand';
    if (elevation > 150) return 'Snow';
    if (elevation > 100 + noise * 20) return 'Mountain';
    
    // Mid elevations vary by position
    const typeNoise = Math.sin(x * 0.05 + z * 0.03) + Math.sin(x * 0.08 - z * 0.06);
    if (typeNoise > 0.5) return 'Forest';
    if (typeNoise < -0.5) return 'Urban';
    return 'Grass';
  }
  
  private getCoverForTerrainType(type: TerrainType): number {
    const coverValues: Record<TerrainType, number> = {
      'Water': 0,
      'Sand': 0.1,
      'Grass': 0.2,
      'Forest': 0.8,
      'Urban': 0.9,
      'Mountain': 0.7,
      'Snow': 0.1,
      'Swamp': 0.4,
      'Road': 0,
      'Runway': 0
    };
    return coverValues[type];
  }
  
  private getConcealmentForTerrainType(type: TerrainType): number {
    const values: Record<TerrainType, number> = {
      'Water': 0.1,
      'Sand': 0.2,
      'Grass': 0.4,
      'Forest': 0.9,
      'Urban': 0.7,
      'Mountain': 0.5,
      'Snow': 0.1,
      'Swamp': 0.6,
      'Road': 0.1,
      'Runway': 0.1
    };
    return values[type];
  }
  
  private getThermalForTerrainType(type: TerrainType): number {
    // Relative thermal signature (affects thermal contrast)
    const values: Record<TerrainType, number> = {
      'Water': 0.3,
      'Sand': 0.8,
      'Grass': 0.5,
      'Forest': 0.4,
      'Urban': 0.7,
      'Mountain': 0.4,
      'Snow': 0.2,
      'Swamp': 0.5,
      'Road': 0.6,
      'Runway': 0.6
    };
    return values[type];
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // WEATHER SIMULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  private createDefaultWeather(): WeatherState {
    return {
      condition: 'Clear',
      windSpeed: 5,
      windDirection: 270,  // From west
      windGustiness: 0.2,
      windGustSpeed: 8,
      windVertical: 0,
      visibility: 10000,
      cloudBase: 2000,
      cloudTop: 4000,
      cloudCover: 0.2,
      fogDensity: 0,
      precipitationType: 'None',
      precipitationIntensity: 0,
      temperature: 20,
      humidity: 0.5,
      pressure: 1013.25,
      sensorDegradation: 0,
      opticalDegradation: 0,
      thermalContrast: 0.8,
      gpsAccuracyPenalty: 0,
      communicationDegradation: 0
    };
  }
  
  private updateWeather(deltaTime: number): void {
    // Slowly vary weather conditions
    const w = this.weather;
    
    // Wind variation
    w.windDirection += (Math.random() - 0.5) * 2 * deltaTime;
    w.windSpeed += (Math.random() - 0.5) * 0.5 * deltaTime;
    w.windSpeed = Math.max(0, Math.min(30, w.windSpeed));
    
    // Gusts
    if (Math.random() < 0.01) {
      w.windGustSpeed = w.windSpeed * (1.5 + Math.random() * 0.5);
    }
    
    // Temperature follows time of day
    const baseTemp = 15;
    const tempVariation = 10;
    const hourAngle = (this.time.hours - 6) / 12 * Math.PI;  // Peak at noon
    w.temperature = baseTemp + tempVariation * Math.sin(hourAngle);
    
    // Update derived effects
    this.updateWeatherEffects();
  }
  
  private updateWeatherEffects(): void {
    const w = this.weather;
    
    // Sensor degradation from precipitation
    if (w.precipitationType !== 'None') {
      w.sensorDegradation = Math.min(0.8, w.precipitationIntensity / 50);
      w.opticalDegradation = Math.min(0.9, w.precipitationIntensity / 30);
    } else {
      w.sensorDegradation = 0;
      w.opticalDegradation = 0;
    }
    
    // Fog affects everything
    if (w.fogDensity > 0) {
      w.opticalDegradation = Math.max(w.opticalDegradation, w.fogDensity * 0.9);
      w.visibility = Math.max(50, w.visibility * (1 - w.fogDensity));
    }
    
    // Temperature affects thermal contrast
    // Cold nights = good thermal contrast
    // Hot days = poor thermal contrast
    const tempFactor = 1 - Math.abs(w.temperature - 20) / 40;
    w.thermalContrast = this.time.isDaytime ? tempFactor * 0.7 : tempFactor * 1.2;
    w.thermalContrast = Math.max(0.2, Math.min(1, w.thermalContrast));
    
    // Storm affects GPS and comms
    if (w.condition === 'Storm') {
      w.gpsAccuracyPenalty = 5 + Math.random() * 10;
      w.communicationDegradation = 0.3 + Math.random() * 0.3;
    } else {
      w.gpsAccuracyPenalty = 0;
      w.communicationDegradation = 0;
    }
  }
  
  /**
   * Set weather condition
   */
  setWeather(condition: WeatherCondition): void {
    this.weather.condition = condition;
    
    // Adjust parameters for condition
    switch (condition) {
      case 'Clear':
        this.weather.cloudCover = 0.1;
        this.weather.visibility = 20000;
        this.weather.precipitationType = 'None';
        this.weather.precipitationIntensity = 0;
        this.weather.fogDensity = 0;
        break;
        
      case 'Rain':
        this.weather.cloudCover = 0.8;
        this.weather.visibility = 5000;
        this.weather.precipitationType = 'Rain';
        this.weather.precipitationIntensity = 10;
        break;
        
      case 'HeavyRain':
        this.weather.cloudCover = 1.0;
        this.weather.visibility = 1000;
        this.weather.precipitationType = 'Rain';
        this.weather.precipitationIntensity = 50;
        break;
        
      case 'Storm':
        this.weather.cloudCover = 1.0;
        this.weather.visibility = 500;
        this.weather.precipitationType = 'Rain';
        this.weather.precipitationIntensity = 80;
        this.weather.windSpeed = 20 + Math.random() * 15;
        this.weather.windGustSpeed = 40;
        break;
        
      case 'Fog':
        this.weather.fogDensity = 0.7;
        this.weather.visibility = 200;
        this.weather.cloudCover = 0.3;
        break;
        
      case 'Snow':
        this.weather.cloudCover = 0.9;
        this.weather.visibility = 2000;
        this.weather.precipitationType = 'Snow';
        this.weather.precipitationIntensity = 15;
        this.weather.temperature = -5;
        break;
    }
    
    this.updateWeatherEffects();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TIME SIMULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  private createInitialTime(): WorldTime {
    return {
      totalSeconds: 0,
      hours: 12,
      minutes: 0,
      seconds: 0,
      day: 1,
      month: 6,
      year: 2026,
      timeOfDay: 'Noon',
      isDaytime: true,
      sunAzimuth: 180,
      sunElevation: 60,
      moonPhase: 0.5,
      ambientLight: 1.0,
      directLight: 1.0,
      lightDirection: { x: 0, y: -1, z: 0.5 },
      timeScale: 60  // 1 second = 1 minute
    };
  }
  
  private updateTime(deltaSeconds: number): void {
    const t = this.time;
    
    // Advance time
    const scaledDelta = deltaSeconds * t.timeScale;
    t.totalSeconds += scaledDelta;
    t.seconds += scaledDelta;
    
    // Handle overflow
    while (t.seconds >= 60) {
      t.seconds -= 60;
      t.minutes++;
    }
    while (t.minutes >= 60) {
      t.minutes -= 60;
      t.hours++;
    }
    while (t.hours >= 24) {
      t.hours -= 24;
      t.day++;
    }
    
    // Determine time of day
    if (t.hours >= 5 && t.hours < 7) t.timeOfDay = 'Dawn';
    else if (t.hours >= 7 && t.hours < 11) t.timeOfDay = 'Morning';
    else if (t.hours >= 11 && t.hours < 14) t.timeOfDay = 'Noon';
    else if (t.hours >= 14 && t.hours < 17) t.timeOfDay = 'Afternoon';
    else if (t.hours >= 17 && t.hours < 20) t.timeOfDay = 'Dusk';
    else if (t.hours >= 20 || t.hours < 0) t.timeOfDay = 'Night';
    else t.timeOfDay = 'Midnight';
    
    t.isDaytime = t.hours >= 6 && t.hours < 20;
    
    // Calculate sun position (simplified)
    const hourAngle = (t.hours - 12) * 15;  // 15 degrees per hour
    const declination = 23.5 * Math.sin((t.day + 284) / 365 * 2 * Math.PI);
    const latitude = 33;  // Dallas, TX
    
    t.sunElevation = Math.asin(
      Math.sin(latitude * Math.PI/180) * Math.sin(declination * Math.PI/180) +
      Math.cos(latitude * Math.PI/180) * Math.cos(declination * Math.PI/180) * 
      Math.cos(hourAngle * Math.PI/180)
    ) * 180/Math.PI;
    
    t.sunAzimuth = hourAngle + 180;
    
    // Calculate lighting
    if (t.sunElevation > 0) {
      t.ambientLight = 0.3 + 0.7 * Math.min(1, t.sunElevation / 30);
      t.directLight = Math.min(1, t.sunElevation / 45);
    } else {
      t.ambientLight = 0.1 + 0.2 * t.moonPhase;
      t.directLight = 0.1 * t.moonPhase;
    }
    
    // Light direction
    const sunRad = t.sunAzimuth * Math.PI / 180;
    const sunEl = Math.max(0.1, t.sunElevation) * Math.PI / 180;
    t.lightDirection = {
      x: -Math.sin(sunRad) * Math.cos(sunEl),
      y: -Math.sin(sunEl),
      z: -Math.cos(sunRad) * Math.cos(sunEl)
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // OBJECT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  addObject(object: WorldObject): void {
    this.objects.set(object.id, object);
    this.objectSpatialIndex.insert(object.id, object.position, object.size);
  }
  
  removeObject(id: string): void {
    const obj = this.objects.get(id);
    if (obj) {
      this.objectSpatialIndex.remove(id);
      this.objects.delete(id);
    }
  }
  
  getObject(id: string): WorldObject | undefined {
    return this.objects.get(id);
  }
  
  getObjectsInRadius(center: Vector3, radius: number): WorldObject[] {
    const ids = this.objectSpatialIndex.query(center, radius);
    return ids.map(id => this.objects.get(id)).filter(o => o !== undefined) as WorldObject[];
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EFFECTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  createExplosion(position: Vector3, radius: number, damage: number): WorldEffect {
    const effect: WorldEffect = {
      id: `explosion_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      type: 'Explosion',
      position,
      radius,
      intensity: 1.0,
      startTime: this.time.totalSeconds,
      duration: 2,
      currentTime: 0,
      affectsDrones: true,
      damagePerSecond: damage * 2,
      forceMultiplier: radius * 10,
      blocksLOS: true,
      blocksIR: true,
      blocksRadar: false,
      leavesResidue: true,
      residueType: 'Crater'
    };
    
    this.activeEffects.set(effect.id, effect);
    
    // Create smoke follow-up
    setTimeout(() => {
      this.createSmoke(position, radius * 0.5, 30);
    }, 500);
    
    // Damage terrain
    this.damageTerrainAt(position, radius);
    
    // Damage objects in radius
    const affectedObjects = this.getObjectsInRadius(position, radius);
    for (const obj of affectedObjects) {
      const distance = this.distance3D(position, obj.position);
      const damageFalloff = 1 - (distance / radius);
      obj.health -= damage * damageFalloff * (1 - obj.armor);
      
      if (obj.health <= 0 && obj.isDestructible) {
        obj.isDestroyed = true;
        this.logEvent({
          id: `destroy_${Date.now()}`,
          type: 'Destruction',
          timestamp: this.time.totalSeconds,
          position: obj.position,
          targetId: obj.id,
          damage
        });
      }
    }
    
    return effect;
  }
  
  createSmoke(position: Vector3, radius: number, duration: number): WorldEffect {
    const effect: WorldEffect = {
      id: `smoke_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      type: 'Smoke',
      position,
      radius,
      intensity: 0.8,
      startTime: this.time.totalSeconds,
      duration,
      currentTime: 0,
      affectsDrones: false,
      damagePerSecond: 0,
      forceMultiplier: 0,
      blocksLOS: true,
      blocksIR: true,
      blocksRadar: false,
      leavesResidue: false
    };
    
    this.activeEffects.set(effect.id, effect);
    return effect;
  }
  
  createFire(position: Vector3, radius: number, intensity: number): WorldEffect {
    const effect: WorldEffect = {
      id: `fire_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      type: 'Fire',
      position,
      radius,
      intensity,
      startTime: this.time.totalSeconds,
      duration: 120,  // 2 minutes
      currentTime: 0,
      affectsDrones: true,
      damagePerSecond: intensity * 10,
      forceMultiplier: intensity * 5,  // Thermal updraft
      blocksLOS: false,
      blocksIR: false,  // Fire shows up on IR!
      blocksRadar: false,
      leavesResidue: true,
      residueType: 'BurnMark'
    };
    
    this.activeEffects.set(effect.id, effect);
    
    // Mark terrain as on fire
    const cell = this.getTerrainAt(position.x, position.z);
    if (cell) {
      cell.onFire = true;
      cell.fireIntensity = intensity;
    }
    
    return effect;
  }
  
  private damageTerrainAt(position: Vector3, radius: number): void {
    const cellSize = this.terrain.cellSize;
    const cellRadius = Math.ceil(radius / cellSize);
    
    const centerX = Math.floor(position.x / cellSize);
    const centerZ = Math.floor(position.z / cellSize);
    
    for (let dz = -cellRadius; dz <= cellRadius; dz++) {
      for (let dx = -cellRadius; dx <= cellRadius; dx++) {
        const x = centerX + dx;
        const z = centerZ + dz;
        
        if (x < 0 || x >= this.terrain.width || z < 0 || z >= this.terrain.height) continue;
        
        const dist = Math.sqrt(dx * dx + dz * dz) * cellSize;
        if (dist > radius) continue;
        
        const cell = this.terrain.cells[z][x];
        const damageFactor = 1 - (dist / radius);
        
        cell.damaged = true;
        cell.damageLevel = Math.min(1, cell.damageLevel + damageFactor);
        
        // Lower elevation slightly for craters
        const idx = z * this.terrain.width + x;
        this.terrain.heightmap[idx] -= damageFactor * 2;
        cell.elevation = this.terrain.heightmap[idx];
      }
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN UPDATE LOOP
  // ═══════════════════════════════════════════════════════════════════════════
  
  tick(deltaTime: number = 1/60): void {
    this.beat++;
    
    // Update time
    this.updateTime(deltaTime);
    
    // Update weather
    this.lastWeatherUpdate += deltaTime;
    if (this.lastWeatherUpdate >= this.weatherUpdateInterval) {
      this.updateWeather(deltaTime);
      this.lastWeatherUpdate = 0;
    }
    
    // Update effects
    this.updateEffects(deltaTime);
    
    // Spread fire
    this.updateFireSpread(deltaTime);
  }
  
  private updateEffects(deltaTime: number): void {
    const toRemove: string[] = [];
    
    for (const [id, effect] of this.activeEffects) {
      effect.currentTime += deltaTime;
      
      // Fade out
      const progress = effect.currentTime / effect.duration;
      effect.intensity = 1 - progress;
      
      // Expand some effects
      if (effect.type === 'Smoke') {
        effect.radius += deltaTime * 2;
      }
      
      // Remove expired effects
      if (effect.currentTime >= effect.duration) {
        toRemove.push(id);
        
        // Leave residue
        if (effect.leavesResidue && effect.residueType === 'Crater') {
          // Crater is already in terrain
        }
      }
    }
    
    for (const id of toRemove) {
      this.activeEffects.delete(id);
    }
  }
  
  private updateFireSpread(deltaTime: number): void {
    // Fire can spread to adjacent cells
    const toIgnite: { x: number; z: number; intensity: number }[] = [];
    
    for (let z = 0; z < this.terrain.height; z++) {
      for (let x = 0; x < this.terrain.width; x++) {
        const cell = this.terrain.cells[z][x];
        
        if (cell.onFire) {
          // Fire burns out over time
          cell.fireIntensity -= deltaTime * 0.01;
          
          if (cell.fireIntensity <= 0) {
            cell.onFire = false;
            cell.fireIntensity = 0;
            cell.damaged = true;
            cell.damageLevel = 1;
          } else {
            // Check for spread (only flammable terrain)
            if (cell.type === 'Forest' || cell.type === 'Grass') {
              // Check neighbors
              const neighbors = [
                { dx: -1, dz: 0 }, { dx: 1, dz: 0 },
                { dx: 0, dz: -1 }, { dx: 0, dz: 1 }
              ];
              
              for (const n of neighbors) {
                const nx = x + n.dx;
                const nz = z + n.dz;
                
                if (nx < 0 || nx >= this.terrain.width || nz < 0 || nz >= this.terrain.height) continue;
                
                const neighbor = this.terrain.cells[nz][nx];
                if (!neighbor.onFire && (neighbor.type === 'Forest' || neighbor.type === 'Grass')) {
                  // Chance to spread based on fire intensity and wind
                  const spreadChance = cell.fireIntensity * 0.001 * deltaTime;
                  if (Math.random() < spreadChance) {
                    toIgnite.push({ x: nx, z: nz, intensity: cell.fireIntensity * 0.8 });
                  }
                }
              }
            }
          }
        }
      }
    }
    
    // Ignite new fires
    for (const fire of toIgnite) {
      const cell = this.terrain.cells[fire.z][fire.x];
      cell.onFire = true;
      cell.fireIntensity = fire.intensity;
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  getTerrainAt(worldX: number, worldZ: number): TerrainCell | null {
    const x = Math.floor(worldX / this.terrain.cellSize);
    const z = Math.floor(worldZ / this.terrain.cellSize);
    
    if (x < 0 || x >= this.terrain.width || z < 0 || z >= this.terrain.height) {
      return null;
    }
    
    return this.terrain.cells[z][x];
  }
  
  getElevationAt(worldX: number, worldZ: number): number {
    const cell = this.getTerrainAt(worldX, worldZ);
    return cell?.elevation ?? 0;
  }
  
  getWindAt(position: Vector3): Vector3 {
    // Wind varies with altitude and terrain
    const baseWind = {
      x: Math.sin(this.weather.windDirection * Math.PI / 180) * this.weather.windSpeed,
      y: this.weather.windVertical,
      z: Math.cos(this.weather.windDirection * Math.PI / 180) * this.weather.windSpeed
    };
    
    // Add gusts
    const gustFactor = 1 + this.weather.windGustiness * (Math.sin(this.beat * 0.1) * 0.5 + 0.5);
    
    // Wind increases with altitude
    const altitudeFactor = 1 + position.y * 0.001;
    
    return {
      x: baseWind.x * gustFactor * altitudeFactor,
      y: baseWind.y,
      z: baseWind.z * gustFactor * altitudeFactor
    };
  }
  
  getAirDensityAt(altitude: number): number {
    return PHYSICS.AIR_DENSITY_SEA_LEVEL - altitude * PHYSICS.AIR_DENSITY_LAPSE_RATE;
  }
  
  getTemperatureAt(altitude: number): number {
    return this.weather.temperature - altitude * PHYSICS.TEMP_LAPSE_RATE;
  }
  
  /**
   * Check line of sight between two points
   */
  hasLineOfSight(from: Vector3, to: Vector3): boolean {
    const dx = to.x - from.x;
    const dy = to.y - from.y;
    const dz = to.z - from.z;
    const distance = Math.sqrt(dx*dx + dy*dy + dz*dz);
    
    if (distance < 1) return true;
    
    const steps = Math.ceil(distance / 5);  // Check every 5 meters
    
    for (let i = 1; i < steps; i++) {
      const t = i / steps;
      const x = from.x + dx * t;
      const y = from.y + dy * t;
      const z = from.z + dz * t;
      
      // Check terrain
      const cell = this.getTerrainAt(x, z);
      if (cell && cell.blocksLOS && y < cell.elevation + cell.losHeight) {
        return false;
      }
      
      // Check objects
      const nearObjects = this.getObjectsInRadius({ x, y, z }, 10);
      for (const obj of nearObjects) {
        if (obj.blocksLOS && this.pointInBox({ x, y, z }, obj.position, obj.size)) {
          return false;
        }
      }
      
      // Check smoke/effects
      for (const effect of this.activeEffects.values()) {
        if (effect.blocksLOS) {
          const dist = this.distance3D({ x, y, z }, effect.position);
          if (dist < effect.radius) {
            return false;
          }
        }
      }
    }
    
    return true;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY
  // ═══════════════════════════════════════════════════════════════════════════
  
  private distance3D(a: Vector3, b: Vector3): number {
    return Math.sqrt(
      (a.x - b.x) ** 2 +
      (a.y - b.y) ** 2 +
      (a.z - b.z) ** 2
    );
  }
  
  private pointInBox(point: Vector3, boxCenter: Vector3, boxSize: Vector3): boolean {
    return (
      Math.abs(point.x - boxCenter.x) < boxSize.x / 2 &&
      Math.abs(point.y - boxCenter.y) < boxSize.y / 2 &&
      Math.abs(point.z - boxCenter.z) < boxSize.z / 2
    );
  }
  
  private logEvent(event: WorldEvent): void {
    this.eventLog.push(event);
    if (this.eventLog.length > this.maxEventLogSize) {
      this.eventLog.shift();
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC GETTERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  getWeather(): WeatherState { return this.weather; }
  getTime(): WorldTime { return this.time; }
  getTerrain(): TerrainMap { return this.terrain; }
  getActiveEffects(): WorldEffect[] { return Array.from(this.activeEffects.values()); }
  getEventLog(): WorldEvent[] { return this.eventLog; }
  getWorldSize(): Vector3 { return this.worldSize; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SPATIAL INDEX — Fast object queries
// ═══════════════════════════════════════════════════════════════════════════════

class SpatialIndex {
  private cellSize: number;
  private cells: Map<string, Set<string>> = new Map();
  private objectPositions: Map<string, { cell: string; position: Vector3 }> = new Map();
  
  constructor(worldSize: Vector3, cellSize: number) {
    this.cellSize = cellSize;
  }
  
  private getCellKey(x: number, z: number): string {
    const cx = Math.floor(x / this.cellSize);
    const cz = Math.floor(z / this.cellSize);
    return `${cx},${cz}`;
  }
  
  insert(id: string, position: Vector3, size: Vector3): void {
    const key = this.getCellKey(position.x, position.z);
    
    if (!this.cells.has(key)) {
      this.cells.set(key, new Set());
    }
    
    this.cells.get(key)!.add(id);
    this.objectPositions.set(id, { cell: key, position });
  }
  
  remove(id: string): void {
    const data = this.objectPositions.get(id);
    if (data) {
      this.cells.get(data.cell)?.delete(id);
      this.objectPositions.delete(id);
    }
  }
  
  query(center: Vector3, radius: number): string[] {
    const results: string[] = [];
    const cellRadius = Math.ceil(radius / this.cellSize);
    
    const centerCellX = Math.floor(center.x / this.cellSize);
    const centerCellZ = Math.floor(center.z / this.cellSize);
    
    for (let dz = -cellRadius; dz <= cellRadius; dz++) {
      for (let dx = -cellRadius; dx <= cellRadius; dx++) {
        const key = `${centerCellX + dx},${centerCellZ + dz}`;
        const cell = this.cells.get(key);
        
        if (cell) {
          for (const id of cell) {
            const data = this.objectPositions.get(id);
            if (data) {
              const dist = Math.sqrt(
                (data.position.x - center.x) ** 2 +
                (data.position.z - center.z) ** 2
              );
              if (dist <= radius) {
                results.push(id);
              }
            }
          }
        }
      }
    }
    
    return results;
  }
}
