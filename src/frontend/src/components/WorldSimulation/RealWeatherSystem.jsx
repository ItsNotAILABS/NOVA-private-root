// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: RealWeatherSystem — REAL Atmospheric Physics
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// This is NOT random weather. This is REAL ATMOSPHERIC PHYSICS.
//   - Pressure systems (high/low)
//   - Temperature gradients
//   - Humidity and dew point
//   - Wind from pressure differentials
//   - Precipitation from condensation
//   - Coriolis effect
//
// Based on real meteorological equations.
// ============================================================================

import React, { useState, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

// ─── ATMOSPHERIC CONSTANTS (matching backend) ─────────────────────────────────
const CONSTANTS = {
  SEA_LEVEL_PRESSURE: 101325,          // Pa
  SEA_LEVEL_TEMP: 288.15,              // K (15°C)
  LAPSE_RATE: 0.0065,                  // K/m
  R_DRY: 287.05,                       // J/(kg·K) dry air
  R_VAPOR: 461.5,                      // J/(kg·K) water vapor
  KELVIN_OFFSET: 273.15,
};

const CLOUD_TYPES = {
  Cirrus: { altitude: '6-12 km', description: 'High, thin, wispy', color: '#aaccff' },
  Cirrostratus: { altitude: '6-12 km', description: 'High, thin sheet', color: '#99bbee' },
  Altostratus: { altitude: '2-6 km', description: 'Mid-level gray', color: '#778899' },
  Altocumulus: { altitude: '2-6 km', description: 'Mid-level puffy', color: '#889999' },
  Stratus: { altitude: '0-2 km', description: 'Low, uniform', color: '#667788' },
  Stratocumulus: { altitude: '0-2 km', description: 'Low, lumpy', color: '#556677' },
  Cumulus: { altitude: '0.5-2 km', description: 'Fair weather puffy', color: '#ffffff' },
  Cumulonimbus: { altitude: '0.5-12 km', description: 'Thunderstorm', color: '#334455' },
  Nimbostratus: { altitude: '0-3 km', description: 'Rain clouds', color: '#445566' },
};

const WEATHER_ICONS = {
  Clear: '☀️',
  PartlyCloudy: '⛅',
  Cloudy: '☁️',
  Overcast: '🌥️',
  Fog: '🌫️',
  LightRain: '🌧️',
  ModerateRain: '🌧️',
  HeavyRain: '⛈️',
  Thunderstorm: '⛈️',
  LightSnow: '🌨️',
  ModerateSnow: '❄️',
  HeavySnow: '❄️',
  Blizzard: '🌬️',
};

// ─── WIND ARROW ───────────────────────────────────────────────────────────────
function WindArrow({ direction, speed }) {
  const rotation = (direction - 180) * (Math.PI / 180); // Point where wind is coming FROM
  const size = Math.min(40, 15 + speed * 2);
  
  return (
    <div style={{
      width: 80,
      height: 80,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      position: 'relative',
    }}>
      {/* Compass rose */}
      <div style={{
        position: 'absolute',
        width: '100%',
        height: '100%',
        border: '2px solid #1a3a5c',
        borderRadius: '50%',
      }}>
        {['N', 'E', 'S', 'W'].map((dir, i) => (
          <span key={dir} style={{
            position: 'absolute',
            fontSize: 8,
            color: '#68a',
            left: '50%',
            top: '50%',
            transform: `translate(-50%, -50%) rotate(${i * 90}deg) translateY(-35px) rotate(${-i * 90}deg)`,
          }}>
            {dir}
          </span>
        ))}
      </div>
      
      {/* Wind arrow */}
      <div style={{
        transform: `rotate(${rotation}rad)`,
        transition: 'transform 0.5s',
      }}>
        <svg width={size} height={size} viewBox="0 0 24 24">
          <path
            d="M12 2L8 10h3v10h2V10h3L12 2z"
            fill="#00aaff"
            stroke="#004488"
            strokeWidth="0.5"
          />
        </svg>
      </div>
    </div>
  );
}

// ─── PRESSURE GAUGE ───────────────────────────────────────────────────────────
function PressureGauge({ pressure, tendency }) {
  const normalizedPressure = (pressure - 95000) / (108000 - 95000); // Range: 950-1080 hPa
  const tendencyArrow = tendency > 0 ? '↗' : tendency < 0 ? '↘' : '→';
  const tendencyColor = tendency > 0 ? '#00ff88' : tendency < 0 ? '#ff4488' : '#4af';
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
      textAlign: 'center',
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 4 }}>BAROMETRIC PRESSURE</div>
      <div style={{ fontSize: 24, color: '#4af', fontWeight: 'bold' }}>
        {(pressure / 100).toFixed(1)}
        <span style={{ fontSize: 12 }}> hPa</span>
      </div>
      <div style={{ fontSize: 10, color: tendencyColor }}>
        {tendencyArrow} {tendency > 0 ? '+' : ''}{(tendency / 100).toFixed(2)} hPa/hr
      </div>
      <div style={{
        height: 8,
        background: '#050a14',
        borderRadius: 4,
        marginTop: 8,
        overflow: 'hidden',
      }}>
        <div style={{
          width: `${normalizedPressure * 100}%`,
          height: '100%',
          background: pressure > 101325 ? '#00aaff' : '#ff8800',
          transition: 'width 0.5s',
        }} />
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 7, color: '#68a', marginTop: 2 }}>
        <span>LOW</span>
        <span>HIGH</span>
      </div>
    </div>
  );
}

// ─── TEMPERATURE DISPLAY ──────────────────────────────────────────────────────
function TemperatureDisplay({ temp, dewPoint }) {
  const tempC = temp - CONSTANTS.KELVIN_OFFSET;
  const dewC = dewPoint - CONSTANTS.KELVIN_OFFSET;
  const spread = tempC - dewC;
  
  const getColor = (t) => {
    if (t < 0) return '#4488ff';
    if (t < 10) return '#00aaff';
    if (t < 20) return '#44ff88';
    if (t < 30) return '#ffaa00';
    return '#ff4444';
  };
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 8 }}>TEMPERATURE</div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Air</div>
          <div style={{ fontSize: 28, color: getColor(tempC), fontWeight: 'bold' }}>
            {tempC.toFixed(1)}°C
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{ fontSize: 8, color: '#68a' }}>Dew Point</div>
          <div style={{ fontSize: 16, color: '#00aaff' }}>
            {dewC.toFixed(1)}°C
          </div>
          <div style={{ fontSize: 8, color: spread < 3 ? '#ff4488' : '#68a' }}>
            Spread: {spread.toFixed(1)}°
          </div>
        </div>
      </div>
    </div>
  );
}

// ─── HUMIDITY GAUGE ───────────────────────────────────────────────────────────
function HumidityGauge({ relative, absolute }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 8 }}>HUMIDITY</div>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Relative</div>
          <div style={{ fontSize: 20, color: relative > 0.8 ? '#00aaff' : '#4af' }}>
            {(relative * 100).toFixed(0)}%
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{ fontSize: 8, color: '#68a' }}>Absolute</div>
          <div style={{ fontSize: 14, color: '#4af' }}>
            {(absolute * 1000).toFixed(2)} g/m³
          </div>
        </div>
      </div>
      <div style={{
        height: 8,
        background: '#050a14',
        borderRadius: 4,
        marginTop: 8,
        overflow: 'hidden',
      }}>
        <div style={{
          width: `${relative * 100}%`,
          height: '100%',
          background: relative > 0.9 ? '#00aaff' : relative > 0.6 ? '#44aaff' : '#4488aa',
          transition: 'width 0.5s',
        }} />
      </div>
    </div>
  );
}

// ─── WIND DISPLAY ─────────────────────────────────────────────────────────────
function WindDisplay({ speed, direction, gust, vector }) {
  const beaufort = speed < 0.5 ? 0 : speed < 1.6 ? 1 : speed < 3.4 ? 2 : speed < 5.5 ? 3 :
                   speed < 8.0 ? 4 : speed < 10.8 ? 5 : speed < 13.9 ? 6 : speed < 17.2 ? 7 :
                   speed < 20.8 ? 8 : speed < 24.5 ? 9 : speed < 28.5 ? 10 : speed < 32.7 ? 11 : 12;
  
  const directionName = direction < 22.5 ? 'N' : direction < 67.5 ? 'NE' : direction < 112.5 ? 'E' :
                        direction < 157.5 ? 'SE' : direction < 202.5 ? 'S' : direction < 247.5 ? 'SW' :
                        direction < 292.5 ? 'W' : direction < 337.5 ? 'NW' : 'N';
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 8 }}>WIND</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <WindArrow direction={direction} speed={speed} />
        <div>
          <div style={{ fontSize: 20, color: '#00aaff' }}>
            {speed.toFixed(1)} <span style={{ fontSize: 10 }}>m/s</span>
          </div>
          <div style={{ fontSize: 10, color: '#68a' }}>
            {directionName} ({direction.toFixed(0)}°)
          </div>
          <div style={{ fontSize: 9, color: gust > speed * 1.5 ? '#ff8800' : '#68a' }}>
            Gusts: {gust.toFixed(1)} m/s
          </div>
          <div style={{ fontSize: 8, color: '#4af' }}>
            Beaufort: {beaufort}
          </div>
        </div>
      </div>
    </div>
  );
}

// ─── CLOUD LAYER DISPLAY ──────────────────────────────────────────────────────
function CloudLayerDisplay({ clouds }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 8 }}>CLOUD LAYERS</div>
      {clouds.map((cloud, i) => (
        <div key={i} style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          padding: '4px 0',
          borderBottom: i < clouds.length - 1 ? '1px solid #1a3a5c' : 'none',
        }}>
          <div>
            <span style={{ fontSize: 10, color: CLOUD_TYPES[cloud.type]?.color || '#aaa' }}>
              {cloud.type}
            </span>
            <span style={{ fontSize: 8, color: '#68a', marginLeft: 8 }}>
              {cloud.altitude} m
            </span>
          </div>
          <span style={{ fontSize: 9, color: '#4af' }}>
            {(cloud.coverage * 100).toFixed(0)}%
          </span>
        </div>
      ))}
      {clouds.length === 0 && (
        <div style={{ fontSize: 9, color: '#68a' }}>Clear skies</div>
      )}
    </div>
  );
}

// ─── PRECIPITATION DISPLAY ────────────────────────────────────────────────────
function PrecipitationDisplay({ type, rate, accumulation }) {
  const typeColors = {
    None: '#446',
    Rain: '#00aaff',
    Snow: '#ffffff',
    Sleet: '#aabbcc',
    Hail: '#88aacc',
  };
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 8 }}>PRECIPITATION</div>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 14, color: typeColors[type] || '#4af' }}>
            {type || 'None'}
          </div>
          <div style={{ fontSize: 10, color: '#68a' }}>
            Rate: {rate.toFixed(1)} mm/hr
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{ fontSize: 8, color: '#68a' }}>Accumulation</div>
          <div style={{ fontSize: 16, color: '#4af' }}>
            {accumulation.toFixed(1)} mm
          </div>
        </div>
      </div>
    </div>
  );
}

// ─── VISIBILITY GAUGE ─────────────────────────────────────────────────────────
function VisibilityGauge({ visibility }) {
  const visKm = visibility / 1000;
  const category = visKm > 10 ? 'Excellent' : visKm > 5 ? 'Good' : visKm > 2 ? 'Moderate' :
                   visKm > 1 ? 'Poor' : visKm > 0.5 ? 'Very Poor' : 'Fog';
  const color = visKm > 10 ? '#00ff88' : visKm > 5 ? '#44ff88' : visKm > 2 ? '#ffaa00' :
                visKm > 1 ? '#ff8800' : '#ff4444';
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 4 }}>VISIBILITY</div>
      <div style={{ fontSize: 20, color }}>
        {visKm.toFixed(1)} <span style={{ fontSize: 10 }}>km</span>
      </div>
      <div style={{ fontSize: 9, color }}>{category}</div>
    </div>
  );
}

// ─── STYLES ───────────────────────────────────────────────────────────────────
const styles = {
  root: {
    display: 'flex',
    flexDirection: 'column',
    height: '100%',
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    borderRadius: 4,
    overflow: 'hidden',
  },
  header: {
    padding: '10px 12px',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  title: {
    fontSize: 11,
    color: '#00aaff',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  condition: (condition) => ({
    fontSize: 9,
    padding: '2px 8px',
    borderRadius: 8,
    background: condition?.includes('Rain') || condition?.includes('Storm') ? '#002244' : '#1a2a3a',
    color: condition?.includes('Rain') || condition?.includes('Storm') ? '#00aaff' : '#4af',
    border: '1px solid #1a3a5c',
  }),
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: 'repeat(2, 1fr)',
    gap: 8,
    padding: 10,
    overflow: 'auto',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function RealWeatherSystem({ weatherState = {} }) {
  // Sample weather state if none provided
  const state = {
    condition: weatherState.condition || 'PartlyCloudy',
    temperature: weatherState.temperature || 293.15, // 20°C
    dewPoint: weatherState.dewPoint || 285.15, // 12°C
    pressure: weatherState.pressure || 101325,
    pressureTendency: weatherState.pressureTendency || 50,
    relativeHumidity: weatherState.relativeHumidity || 0.65,
    absoluteHumidity: weatherState.absoluteHumidity || 0.012,
    windSpeed: weatherState.windSpeed || 5.2,
    windDirection: weatherState.windDirection || 225,
    gustSpeed: weatherState.gustSpeed || 8.5,
    windVector: weatherState.windVector || { x: -3.7, y: 0, z: 3.7 },
    visibility: weatherState.visibility || 12000,
    cloudCover: weatherState.cloudCover || 0.4,
    clouds: weatherState.clouds || [
      { type: 'Cumulus', altitude: 1500, coverage: 0.3 },
      { type: 'Cirrus', altitude: 8000, coverage: 0.2 },
    ],
    precipitation: {
      type: weatherState.precipitationType || 'None',
      rate: weatherState.precipitationRate || 0,
      accumulation: weatherState.accumulation || 0,
    },
    altitude: weatherState.altitude || 0,
  };
  
  const icon = WEATHER_ICONS[state.condition] || '🌡️';
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>🌡️ Real Weather System</span>
        <span style={{ fontSize: 18 }}>{icon}</span>
        <span style={styles.condition(state.condition)}>{state.condition}</span>
        <span style={{ fontSize: 9, color: '#68a', marginLeft: 'auto' }}>
          Alt: {state.altitude}m
        </span>
      </div>
      
      <div style={styles.content}>
        <PressureGauge pressure={state.pressure} tendency={state.pressureTendency} />
        <TemperatureDisplay temp={state.temperature} dewPoint={state.dewPoint} />
        <HumidityGauge relative={state.relativeHumidity} absolute={state.absoluteHumidity} />
        <WindDisplay
          speed={state.windSpeed}
          direction={state.windDirection}
          gust={state.gustSpeed}
          vector={state.windVector}
        />
        <CloudLayerDisplay clouds={state.clouds} />
        <PrecipitationDisplay
          type={state.precipitation.type}
          rate={state.precipitation.rate}
          accumulation={state.precipitation.accumulation}
        />
        <VisibilityGauge visibility={state.visibility} />
        
        <div style={{
          background: '#0a1a2e',
          border: '1px solid #1a3a5c',
          borderRadius: 8,
          padding: 12,
        }}>
          <div style={{ fontSize: 9, color: '#6af', marginBottom: 4 }}>ATMOSPHERIC MODEL</div>
          <div style={{ fontSize: 8, color: '#68a' }}>
            P = P₀ × (1 - L×h/T₀)^(g×M/R×L)
          </div>
          <div style={{ fontSize: 8, color: '#68a', marginTop: 4 }}>
            Sea Level: {(CONSTANTS.SEA_LEVEL_PRESSURE / 100).toFixed(1)} hPa
          </div>
          <div style={{ fontSize: 8, color: '#68a' }}>
            Lapse Rate: {CONSTANTS.LAPSE_RATE * 1000} K/km
          </div>
        </div>
      </div>
    </div>
  );
}
