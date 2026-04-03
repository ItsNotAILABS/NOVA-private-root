// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldWeatherEngine — Dynamic Weather & Atmosphere Simulation
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD WEATHER ENGINE                                        ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  WIRED INTO EXISTING ARCHITECTURE:                                             ║
// ║    • Uses NonlinearDynamicsEngine for chaotic weather patterns                 ║
// ║    • Connects to HarmonicAnalysisEngine for atmospheric waves                  ║
// ║    • Integrates with StabilityBudgetEngine for weather event costs             ║
// ║                                                                                ║
// ║  WEATHER SYSTEMS:                                                              ║
// ║    • Wind field simulation (turbulence, gusts)                                 ║
// ║    • Precipitation (rain, snow, hail)                                          ║
// ║    • Cloud formation and movement                                              ║
// ║    • Visibility (fog, dust, smoke)                                             ║
// ║    • Temperature gradients                                                     ║
// ║    • Atmospheric pressure systems                                              ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type { Vec3 } from './WorldPhysicsEngine';
import { vec3 } from './WorldPhysicsEngine';
import { fbm, perlin2D, voronoi } from './WorldTerrainEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// ATMOSPHERIC CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const ATMOSPHERE = {
  // Standard atmosphere
  SEA_LEVEL_PRESSURE: 101325,         // Pa
  SEA_LEVEL_TEMP: 288.15,             // K (15°C)
  TEMP_LAPSE_RATE: 0.0065,            // K/m in troposphere
  TROPOPAUSE_HEIGHT: 11000,           // m
  
  // Air properties
  AIR_DENSITY_SEA: 1.225,             // kg/m³
  SPECIFIC_GAS_CONSTANT: 287.058,     // J/(kg·K)
  SPECIFIC_HEAT_CP: 1005,             // J/(kg·K)
  SPECIFIC_HEAT_CV: 718,              // J/(kg·K)
  
  // Water
  WATER_VAPOR_SAT_PRESSURE_0C: 611,   // Pa at 0°C
  LATENT_HEAT_VAPORIZATION: 2.5e6,    // J/kg
  
  // Physics
  CORIOLIS_OMEGA: 7.292e-5,           // rad/s (Earth rotation)
  
  // Golden ratio for natural patterns
  PHI: 1.6180339887498948482,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// WEATHER TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type WeatherCondition =
  | 'Clear'
  | 'FewClouds'
  | 'Cloudy'
  | 'Overcast'
  | 'LightRain'
  | 'Rain'
  | 'HeavyRain'
  | 'Thunderstorm'
  | 'LightSnow'
  | 'Snow'
  | 'Blizzard'
  | 'Fog'
  | 'Mist'
  | 'Dust'
  | 'Sandstorm'
  | 'Hail';

export type CloudType =
  | 'None'
  | 'Cirrus'
  | 'Cirrostratus'
  | 'Cirrocumulus'
  | 'Altostratus'
  | 'Altocumulus'
  | 'Stratus'
  | 'Stratocumulus'
  | 'Cumulus'
  | 'Cumulonimbus'
  | 'Nimbostratus';

export type WindCategory =
  | 'Calm'
  | 'LightBreeze'
  | 'Breeze'
  | 'StrongBreeze'
  | 'Gale'
  | 'Storm'
  | 'Hurricane';

// ═══════════════════════════════════════════════════════════════════════════════
// WEATHER STATE
// ═══════════════════════════════════════════════════════════════════════════════

export interface AtmosphericState {
  // At position
  temperature: number;        // Kelvin
  pressure: number;           // Pa
  density: number;            // kg/m³
  humidity: number;           // 0-1 relative
  dewPoint: number;           // Kelvin
  
  // Wind
  windVelocity: Vec3;         // m/s
  windSpeed: number;          // m/s magnitude
  windDirection: number;      // degrees (from)
  gustSpeed: number;          // m/s
  turbulenceIntensity: number;// 0-1
  
  // Visibility
  visibility: number;         // meters
  cloudBase: number;          // meters AGL
  cloudTop: number;           // meters AGL
  cloudCoverage: number;      // 0-1 (oktas / 8)
  cloudType: CloudType;
  
  // Precipitation
  precipitation: number;      // mm/hour
  precipitationType: 'None' | 'Rain' | 'Snow' | 'Sleet' | 'Hail';
  icing: boolean;
  
  // Overall
  condition: WeatherCondition;
  windCategory: WindCategory;
}

export interface WeatherCell {
  x: number;
  y: number;
  pressure: number;
  temperature: number;
  humidity: number;
  windU: number;            // East-west component
  windV: number;            // North-south component
  windW: number;            // Vertical component
  cloudDensity: number;
  precipitation: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ATMOSPHERIC CALCULATIONS
// ═══════════════════════════════════════════════════════════════════════════════

export function standardAtmosphere(altitude: number): {
  temperature: number;
  pressure: number;
  density: number;
} {
  const T0 = ATMOSPHERE.SEA_LEVEL_TEMP;
  const P0 = ATMOSPHERE.SEA_LEVEL_PRESSURE;
  const L = ATMOSPHERE.TEMP_LAPSE_RATE;
  const g = 9.80665;
  const R = ATMOSPHERE.SPECIFIC_GAS_CONSTANT;
  
  if (altitude < ATMOSPHERE.TROPOPAUSE_HEIGHT) {
    // Troposphere: temperature decreases linearly
    const T = T0 - L * altitude;
    const P = P0 * Math.pow(T / T0, g / (R * L));
    const rho = P / (R * T);
    return { temperature: T, pressure: P, density: rho };
  } else {
    // Stratosphere (simplified): isothermal
    const T_trop = T0 - L * ATMOSPHERE.TROPOPAUSE_HEIGHT;
    const P_trop = P0 * Math.pow(T_trop / T0, g / (R * L));
    const deltaH = altitude - ATMOSPHERE.TROPOPAUSE_HEIGHT;
    const P = P_trop * Math.exp(-g * deltaH / (R * T_trop));
    const rho = P / (R * T_trop);
    return { temperature: T_trop, pressure: P, density: rho };
  }
}

export function saturationVaporPressure(tempK: number): number {
  // Magnus formula
  const tempC = tempK - 273.15;
  const a = 17.27;
  const b = 237.7;
  return ATMOSPHERE.WATER_VAPOR_SAT_PRESSURE_0C * Math.exp(a * tempC / (b + tempC));
}

export function dewPointTemperature(tempK: number, relHumidity: number): number {
  // Inverse Magnus formula
  const tempC = tempK - 273.15;
  const a = 17.27;
  const b = 237.7;
  const gamma = Math.log(relHumidity) + a * tempC / (b + tempC);
  return 273.15 + b * gamma / (a - gamma);
}

export function cloudBaseAltitude(surfaceTemp: number, surfaceDewPoint: number): number {
  // Approximate cloud base from temperature-dew point spread
  // 125m per degree C difference
  const spread = surfaceTemp - surfaceDewPoint;
  return Math.max(0, spread * 125);
}

// ═══════════════════════════════════════════════════════════════════════════════
// WIND SIMULATION
// ═══════════════════════════════════════════════════════════════════════════════

export interface WindField {
  cells: WeatherCell[][];
  sizeX: number;
  sizeY: number;
  cellSize: number;      // World units per cell
  time: number;
}

export function createWindField(
  sizeX: number,
  sizeY: number,
  cellSize: number
): WindField {
  const cells: WeatherCell[][] = [];
  
  for (let y = 0; y < sizeY; y++) {
    cells[y] = [];
    for (let x = 0; x < sizeX; x++) {
      cells[y][x] = {
        x, y,
        pressure: ATMOSPHERE.SEA_LEVEL_PRESSURE,
        temperature: ATMOSPHERE.SEA_LEVEL_TEMP,
        humidity: 0.5,
        windU: 0,
        windV: 0,
        windW: 0,
        cloudDensity: 0,
        precipitation: 0,
      };
    }
  }
  
  return { cells, sizeX, sizeY, cellSize, time: 0 };
}

export function generatePressureField(
  field: WindField,
  seed: number,
  time: number
): void {
  const scale = 0.002;
  
  for (let y = 0; y < field.sizeY; y++) {
    for (let x = 0; x < field.sizeX; x++) {
      // Use fbm for natural pressure patterns
      const nx = x * scale + time * 0.01;
      const ny = y * scale + time * 0.008;
      
      const variation = fbm(nx, ny, 4, 2, 0.5, seed);
      
      // Pressure varies ±3000 Pa from standard
      field.cells[y][x].pressure = ATMOSPHERE.SEA_LEVEL_PRESSURE + variation * 3000;
    }
  }
}

export function computeGeostrophicWind(
  field: WindField,
  latitude: number
): void {
  // Geostrophic wind: wind parallel to isobars
  // v = (1/ρf) * ∂P/∂n
  
  const f = 2 * ATMOSPHERE.CORIOLIS_OMEGA * Math.sin(latitude * Math.PI / 180);
  const rho = ATMOSPHERE.AIR_DENSITY_SEA;
  
  for (let y = 1; y < field.sizeY - 1; y++) {
    for (let x = 1; x < field.sizeX - 1; x++) {
      const dPdx = (field.cells[y][x + 1].pressure - field.cells[y][x - 1].pressure) / 
                   (2 * field.cellSize);
      const dPdy = (field.cells[y + 1][x].pressure - field.cells[y - 1][x].pressure) / 
                   (2 * field.cellSize);
      
      // Geostrophic balance (Northern hemisphere)
      const fRho = f * rho;
      if (Math.abs(fRho) > 1e-10) {
        field.cells[y][x].windU = -dPdy / fRho;
        field.cells[y][x].windV = dPdx / fRho;
      }
    }
  }
}

export function addTurbulence(
  field: WindField,
  intensity: number,
  seed: number,
  time: number
): void {
  const scale = 0.05;
  
  for (let y = 0; y < field.sizeY; y++) {
    for (let x = 0; x < field.sizeX; x++) {
      const nx = x * scale + time * 0.1;
      const ny = y * scale + time * 0.12;
      
      // Use different noise channels for each wind component
      const turbU = perlin2D(nx, ny, seed) * intensity;
      const turbV = perlin2D(nx + 100, ny + 100, seed) * intensity;
      const turbW = perlin2D(nx + 200, ny + 200, seed) * intensity * 0.5;
      
      field.cells[y][x].windU += turbU;
      field.cells[y][x].windV += turbV;
      field.cells[y][x].windW += turbW;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CLOUD SIMULATION
// ═══════════════════════════════════════════════════════════════════════════════

export interface CloudLayer {
  base: number;           // meters
  top: number;            // meters
  coverage: number;       // 0-1
  type: CloudType;
  density: number;        // kg/m³ water content
  precipitating: boolean;
}

export function classifyCloudType(
  base: number,
  top: number,
  verticalDevelopment: number,
  humidity: number
): CloudType {
  const thickness = top - base;
  
  // High clouds (above 6000m)
  if (base > 6000) {
    if (thickness > 1000) return 'Cirrostratus';
    if (verticalDevelopment > 0.5) return 'Cirrocumulus';
    return 'Cirrus';
  }
  
  // Mid clouds (2000-6000m)
  if (base > 2000) {
    if (thickness > 2000 && humidity > 0.8) return 'Nimbostratus';
    if (verticalDevelopment > 0.5) return 'Altocumulus';
    return 'Altostratus';
  }
  
  // Low clouds (below 2000m)
  if (verticalDevelopment > 0.8 && thickness > 5000) return 'Cumulonimbus';
  if (verticalDevelopment > 0.5) return 'Cumulus';
  if (thickness > 500) return 'Stratocumulus';
  return 'Stratus';
}

export function generateCloudField(
  sizeX: number,
  sizeY: number,
  humidity: number,
  time: number,
  seed: number
): Float32Array {
  const data = new Float32Array(sizeX * sizeY);
  const scale = 0.01;
  
  for (let y = 0; y < sizeY; y++) {
    for (let x = 0; x < sizeX; x++) {
      const nx = x * scale + time * 0.05;
      const ny = y * scale + time * 0.04;
      
      // Use Voronoi for cellular cloud structures
      const vor = voronoi(nx * 5, ny * 5, seed);
      const voronoiFactor = Math.max(0, 1 - vor.distance * 2);
      
      // Combine with FBM for wispy edges
      const fbmVal = (fbm(nx, ny, 5, 2, 0.5, seed + 1000) + 1) * 0.5;
      
      // Cloud density based on humidity and noise
      let cloud = fbmVal * 0.6 + voronoiFactor * 0.4;
      
      // Threshold based on humidity (lower humidity = less clouds)
      const threshold = 1 - humidity;
      cloud = Math.max(0, (cloud - threshold) / (1 - threshold));
      
      data[y * sizeX + x] = Math.pow(cloud, 1.5); // Sharpen edges
    }
  }
  
  return data;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRECIPITATION SIMULATION
// ═══════════════════════════════════════════════════════════════════════════════

export function computePrecipitation(
  cloudDensity: number,
  temperature: number,
  humidity: number
): { rate: number; type: 'None' | 'Rain' | 'Snow' | 'Sleet' | 'Hail' } {
  if (cloudDensity < 0.3 || humidity < 0.6) {
    return { rate: 0, type: 'None' };
  }
  
  // Precipitation rate in mm/hour
  const rate = cloudDensity * humidity * 20; // Up to 20mm/hr
  
  // Type based on temperature
  const tempC = temperature - 273.15;
  
  if (tempC > 3) {
    return { rate, type: 'Rain' };
  } else if (tempC > 0) {
    return { rate: rate * 0.7, type: 'Sleet' };
  } else {
    // Convert water equivalent to snow (roughly 10:1 ratio)
    return { rate: rate * 10, type: 'Snow' };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VISIBILITY CALCULATION
// ═══════════════════════════════════════════════════════════════════════════════

export function computeVisibility(
  precipitation: number,
  precipType: 'None' | 'Rain' | 'Snow' | 'Sleet' | 'Hail',
  humidity: number,
  cloudBase: number,
  altitude: number
): number {
  let visibility = 50000; // Max 50km
  
  // Precipitation reduces visibility
  if (precipitation > 0) {
    switch (precipType) {
      case 'Rain':
        visibility = Math.min(visibility, 10000 / (1 + precipitation * 0.5));
        break;
      case 'Snow':
        visibility = Math.min(visibility, 5000 / (1 + precipitation * 0.1));
        break;
      case 'Sleet':
      case 'Hail':
        visibility = Math.min(visibility, 3000 / (1 + precipitation * 0.3));
        break;
    }
  }
  
  // Fog (high humidity, low temperature spread)
  if (humidity > 0.95) {
    const fogFactor = (humidity - 0.95) / 0.05;
    visibility = Math.min(visibility, 1000 * (1 - fogFactor * 0.9));
  }
  
  // In-cloud visibility
  if (altitude > cloudBase) {
    visibility = Math.min(visibility, 200);
  }
  
  return Math.max(50, visibility); // Minimum 50m
}

// ═══════════════════════════════════════════════════════════════════════════════
// WEATHER CLASSIFICATION
// ═══════════════════════════════════════════════════════════════════════════════

export function classifyWeather(
  cloudCoverage: number,
  precipitation: number,
  precipType: 'None' | 'Rain' | 'Snow' | 'Sleet' | 'Hail',
  windSpeed: number,
  visibility: number
): WeatherCondition {
  // Severe conditions first
  if (precipType === 'Hail') return 'Hail';
  if (windSpeed > 30 && precipType === 'Snow') return 'Blizzard';
  if (windSpeed > 25 && visibility < 1000) return 'Sandstorm';
  if (precipitation > 10 && windSpeed > 15) return 'Thunderstorm';
  
  // Precipitation
  if (precipType === 'Snow') {
    if (precipitation > 20) return 'Snow';
    return 'LightSnow';
  }
  if (precipType === 'Rain') {
    if (precipitation > 15) return 'HeavyRain';
    if (precipitation > 5) return 'Rain';
    return 'LightRain';
  }
  
  // Visibility
  if (visibility < 200) return 'Fog';
  if (visibility < 1000) return 'Mist';
  if (visibility < 3000 && cloudCoverage < 0.3) return 'Dust';
  
  // Cloud coverage
  if (cloudCoverage > 0.9) return 'Overcast';
  if (cloudCoverage > 0.6) return 'Cloudy';
  if (cloudCoverage > 0.2) return 'FewClouds';
  return 'Clear';
}

export function classifyWind(speed: number): WindCategory {
  if (speed < 0.5) return 'Calm';
  if (speed < 5) return 'LightBreeze';
  if (speed < 10) return 'Breeze';
  if (speed < 17) return 'StrongBreeze';
  if (speed < 25) return 'Gale';
  if (speed < 33) return 'Storm';
  return 'Hurricane';
}

// ═══════════════════════════════════════════════════════════════════════════════
// TIME & DAY/NIGHT CYCLE
// ═══════════════════════════════════════════════════════════════════════════════

export interface TimeState {
  worldTime: number;        // Seconds since epoch
  dayOfYear: number;        // 1-365
  timeOfDay: number;        // 0-24 hours
  season: 'Spring' | 'Summer' | 'Autumn' | 'Winter';
  sunAltitude: number;      // degrees above horizon
  sunAzimuth: number;       // degrees from north
  moonPhase: number;        // 0-1 (0=new, 0.5=full)
  isDaytime: boolean;
  lightLevel: number;       // 0-1
}

export function computeSunPosition(
  latitude: number,
  longitude: number,
  dayOfYear: number,
  timeOfDay: number
): { altitude: number; azimuth: number } {
  // Simplified solar position algorithm
  const declination = 23.45 * Math.sin((360 / 365) * (dayOfYear - 81) * Math.PI / 180);
  
  const hourAngle = (timeOfDay - 12) * 15; // 15 degrees per hour
  
  const latRad = latitude * Math.PI / 180;
  const decRad = declination * Math.PI / 180;
  const haRad = hourAngle * Math.PI / 180;
  
  // Altitude
  const sinAlt = Math.sin(latRad) * Math.sin(decRad) + 
                 Math.cos(latRad) * Math.cos(decRad) * Math.cos(haRad);
  const altitude = Math.asin(sinAlt) * 180 / Math.PI;
  
  // Azimuth
  const cosAz = (Math.sin(decRad) - Math.sin(latRad) * sinAlt) / 
                (Math.cos(latRad) * Math.cos(Math.asin(sinAlt)));
  let azimuth = Math.acos(Math.max(-1, Math.min(1, cosAz))) * 180 / Math.PI;
  
  if (hourAngle > 0) azimuth = 360 - azimuth;
  
  return { altitude, azimuth };
}

export function computeLightLevel(
  sunAltitude: number,
  cloudCoverage: number
): number {
  // Base light from sun position
  let light = 0;
  
  if (sunAltitude > 0) {
    // Daytime: altitude affects intensity
    light = Math.sin(sunAltitude * Math.PI / 180);
    light = Math.pow(light, 0.5); // Gamma correction
  } else if (sunAltitude > -18) {
    // Twilight
    light = (sunAltitude + 18) / 18 * 0.3;
  } else {
    // Night (moonlight approximation)
    light = 0.02;
  }
  
  // Clouds reduce light
  light *= (1 - cloudCoverage * 0.6);
  
  return Math.max(0.01, Math.min(1, light));
}

export function getSeason(dayOfYear: number, latitude: number): 'Spring' | 'Summer' | 'Autumn' | 'Winter' {
  // Northern hemisphere
  const isNorth = latitude >= 0;
  
  if (dayOfYear < 80 || dayOfYear >= 355) {
    return isNorth ? 'Winter' : 'Summer';
  } else if (dayOfYear < 172) {
    return isNorth ? 'Spring' : 'Autumn';
  } else if (dayOfYear < 266) {
    return isNorth ? 'Summer' : 'Winter';
  } else {
    return isNorth ? 'Autumn' : 'Spring';
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WEATHER ENGINE — WIRED TO ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════

export interface WeatherWorldState {
  windField: WindField;
  cloudField: Float32Array;
  cloudLayers: CloudLayer[];
  timeState: TimeState;
  globalHumidity: number;
  globalTemperatureOffset: number;
  
  // Architecture integration
  coherence: number;
  stabilityBudget: number;
  lawCompliance: number;
}

export class WorldWeatherEngine {
  private state: WeatherWorldState;
  private config: {
    fieldSizeX: number;
    fieldSizeY: number;
    cellSize: number;
    latitude: number;
    longitude: number;
    seed: number;
    timeScale: number;     // Real seconds per world hour
  };
  
  constructor(config?: Partial<WorldWeatherEngine['config']>) {
    this.config = {
      fieldSizeX: 64,
      fieldSizeY: 64,
      cellSize: 1000,
      latitude: 32.78,     // Dallas, TX
      longitude: -96.80,
      seed: 42,
      timeScale: 60,       // 1 minute = 1 hour
      ...config,
    };
    
    this.state = {
      windField: createWindField(
        this.config.fieldSizeX,
        this.config.fieldSizeY,
        this.config.cellSize
      ),
      cloudField: new Float32Array(this.config.fieldSizeX * this.config.fieldSizeY),
      cloudLayers: [],
      timeState: {
        worldTime: 0,
        dayOfYear: 172,    // Summer solstice
        timeOfDay: 12,     // Noon
        season: 'Summer',
        sunAltitude: 60,
        sunAzimuth: 180,
        moonPhase: 0.5,
        isDaytime: true,
        lightLevel: 1.0,
      },
      globalHumidity: 0.5,
      globalTemperatureOffset: 0,
      coherence: 1.0,
      stabilityBudget: 100.0,
      lawCompliance: 1.0,
    };
    
    this.updateWeather(0);
  }
  
  // Wire to architecture
  setOrganismState(coherence: number, stabilityBudget: number): void {
    this.state.coherence = coherence;
    this.state.stabilityBudget = stabilityBudget;
  }
  
  setGlobalConditions(humidity: number, tempOffset: number): void {
    this.state.globalHumidity = Math.max(0, Math.min(1, humidity));
    this.state.globalTemperatureOffset = tempOffset;
  }
  
  tick(dt: number): void {
    // Scale time by coherence
    const effectiveDt = dt * this.state.coherence;
    
    this.state.windField.time += effectiveDt;
    
    // Update time state
    const worldHours = effectiveDt / this.config.timeScale;
    this.state.timeState.timeOfDay += worldHours;
    
    if (this.state.timeState.timeOfDay >= 24) {
      this.state.timeState.timeOfDay -= 24;
      this.state.timeState.dayOfYear++;
      if (this.state.timeState.dayOfYear > 365) {
        this.state.timeState.dayOfYear = 1;
      }
    }
    
    this.state.timeState.worldTime += effectiveDt;
    
    // Update weather periodically
    if (Math.floor(this.state.windField.time) % 10 === 0) {
      this.updateWeather(this.state.windField.time);
    }
    
    // Update time-dependent values
    this.updateTimeState();
  }
  
  private updateWeather(time: number): void {
    const { windField, globalHumidity } = this.state;
    const { seed, latitude, fieldSizeX, fieldSizeY } = this.config;
    
    // Generate pressure field
    generatePressureField(windField, seed, time);
    
    // Compute geostrophic wind from pressure
    computeGeostrophicWind(windField, latitude);
    
    // Add turbulence (scaled by inverse stability budget for realism)
    const turbulenceIntensity = 3 + (100 - this.state.stabilityBudget) * 0.05;
    addTurbulence(windField, turbulenceIntensity, seed + 100, time);
    
    // Generate cloud field
    this.state.cloudField = generateCloudField(
      fieldSizeX,
      fieldSizeY,
      globalHumidity,
      time,
      seed + 200
    );
    
    // Update cloud layers
    this.updateCloudLayers();
    
    // Update law compliance based on weather severity
    const maxWind = this.getMaxWindSpeed();
    const severityFactor = Math.min(1, maxWind / 50);
    this.state.lawCompliance = Math.max(0.5, 1 - severityFactor * 0.5);
  }
  
  private updateCloudLayers(): void {
    const humidity = this.state.globalHumidity;
    const temp = ATMOSPHERE.SEA_LEVEL_TEMP + this.state.globalTemperatureOffset;
    const dewPoint = dewPointTemperature(temp, humidity);
    const baseAlt = cloudBaseAltitude(temp, dewPoint);
    
    // Average cloud coverage
    let totalCoverage = 0;
    for (const v of this.state.cloudField) {
      totalCoverage += v;
    }
    const avgCoverage = totalCoverage / this.state.cloudField.length;
    
    this.state.cloudLayers = [];
    
    if (avgCoverage > 0.1) {
      const type = classifyCloudType(
        baseAlt,
        baseAlt + 2000,
        avgCoverage,
        humidity
      );
      
      this.state.cloudLayers.push({
        base: baseAlt,
        top: baseAlt + 2000 * (1 + avgCoverage),
        coverage: avgCoverage,
        type,
        density: avgCoverage * 0.5,
        precipitating: avgCoverage > 0.6 && humidity > 0.7,
      });
    }
  }
  
  private updateTimeState(): void {
    const { latitude, longitude } = this.config;
    const { timeState, cloudLayers } = this.state;
    
    // Sun position
    const sun = computeSunPosition(
      latitude,
      longitude,
      timeState.dayOfYear,
      timeState.timeOfDay
    );
    
    timeState.sunAltitude = sun.altitude;
    timeState.sunAzimuth = sun.azimuth;
    timeState.isDaytime = sun.altitude > 0;
    
    // Season
    timeState.season = getSeason(timeState.dayOfYear, latitude);
    
    // Light level
    const cloudCoverage = cloudLayers.length > 0 ? cloudLayers[0].coverage : 0;
    timeState.lightLevel = computeLightLevel(sun.altitude, cloudCoverage);
    
    // Moon phase (simplified 29.5 day cycle)
    timeState.moonPhase = (timeState.dayOfYear % 29.5) / 29.5;
  }
  
  getAtmosphericState(worldX: number, worldY: number, altitude: number): AtmosphericState {
    const { windField, cloudField, cloudLayers, globalHumidity, globalTemperatureOffset } = this.state;
    
    // Get cell indices
    const cellX = Math.floor(worldX / this.config.cellSize) % this.config.fieldSizeX;
    const cellY = Math.floor(worldY / this.config.cellSize) % this.config.fieldSizeY;
    const safeX = Math.max(0, Math.min(this.config.fieldSizeX - 1, cellX));
    const safeY = Math.max(0, Math.min(this.config.fieldSizeY - 1, cellY));
    
    const cell = windField.cells[safeY][safeX];
    
    // Standard atmosphere modified by weather
    const stdAtm = standardAtmosphere(altitude);
    const temperature = stdAtm.temperature + globalTemperatureOffset;
    const humidity = globalHumidity * (1 - altitude / 20000);
    const dewPoint = dewPointTemperature(temperature, humidity);
    
    // Wind
    const windVelocity: Vec3 = {
      x: cell.windU,
      y: cell.windW,
      z: cell.windV,
    };
    const windSpeed = vec3.length(windVelocity);
    const windDirection = Math.atan2(-cell.windU, -cell.windV) * 180 / Math.PI;
    
    // Gusts (20% variation)
    const gustSpeed = windSpeed * (1 + 0.2 * Math.sin(this.state.windField.time * 0.5));
    
    // Turbulence intensity
    const turbulenceIntensity = Math.min(1, windSpeed / 20);
    
    // Cloud info
    const cloudIdx = safeY * this.config.fieldSizeX + safeX;
    const cloudDensity = cloudField[cloudIdx];
    const cloudBase = cloudLayers.length > 0 ? cloudLayers[0].base : 10000;
    const cloudTop = cloudLayers.length > 0 ? cloudLayers[0].top : 12000;
    const cloudType = cloudLayers.length > 0 ? cloudLayers[0].type : 'None';
    
    // Precipitation
    const { rate: precipitation, type: precipitationType } = computePrecipitation(
      cloudDensity,
      temperature,
      humidity
    );
    
    // Visibility
    const visibility = computeVisibility(
      precipitation,
      precipitationType,
      humidity,
      cloudBase,
      altitude
    );
    
    // Icing
    const icing = altitude > cloudBase && altitude < cloudTop && temperature < 273.15;
    
    // Overall condition
    const condition = classifyWeather(
      cloudDensity,
      precipitation,
      precipitationType,
      windSpeed,
      visibility
    );
    
    const windCategory = classifyWind(windSpeed);
    
    return {
      temperature,
      pressure: cell.pressure,
      density: stdAtm.density,
      humidity,
      dewPoint,
      windVelocity,
      windSpeed,
      windDirection: windDirection < 0 ? windDirection + 360 : windDirection,
      gustSpeed,
      turbulenceIntensity,
      visibility,
      cloudBase,
      cloudTop,
      cloudCoverage: cloudDensity,
      cloudType,
      precipitation,
      precipitationType,
      icing,
      condition,
      windCategory,
    };
  }
  
  getTimeState(): TimeState {
    return { ...this.state.timeState };
  }
  
  getWindAt(worldX: number, worldY: number, altitude: number): Vec3 {
    const atm = this.getAtmosphericState(worldX, worldY, altitude);
    return atm.windVelocity;
  }
  
  private getMaxWindSpeed(): number {
    let maxSpeed = 0;
    for (const row of this.state.windField.cells) {
      for (const cell of row) {
        const speed = Math.sqrt(cell.windU ** 2 + cell.windV ** 2);
        maxSpeed = Math.max(maxSpeed, speed);
      }
    }
    return maxSpeed;
  }
  
  // Spawn weather event (costs stability budget)
  spawnStorm(centerX: number, centerY: number, intensity: number): boolean {
    const cost = intensity * 20;
    if (this.state.stabilityBudget < cost) return false;
    
    this.state.stabilityBudget -= cost;
    
    // Add low pressure center
    const cellX = Math.floor(centerX / this.config.cellSize);
    const cellY = Math.floor(centerY / this.config.cellSize);
    
    const radius = 5 + intensity * 10;
    for (let dy = -radius; dy <= radius; dy++) {
      for (let dx = -radius; dx <= radius; dx++) {
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist > radius) continue;
        
        const factor = 1 - dist / radius;
        const cx = (cellX + dx + this.config.fieldSizeX) % this.config.fieldSizeX;
        const cy = (cellY + dy + this.config.fieldSizeY) % this.config.fieldSizeY;
        
        this.state.windField.cells[cy][cx].pressure -= 
          3000 * intensity * factor * factor;
      }
    }
    
    // Recompute winds
    computeGeostrophicWind(this.state.windField, this.config.latitude);
    
    return true;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SINGLETON
// ═══════════════════════════════════════════════════════════════════════════════

export const worldWeather = new WorldWeatherEngine();
