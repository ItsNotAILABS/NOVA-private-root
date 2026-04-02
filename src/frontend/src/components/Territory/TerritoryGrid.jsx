// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: TerritoryGrid — Atlas Territory Management
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Complete territory management system:
//   - Hex grid territory mapping
//   - Resource distribution
//   - Control zones and borders
//   - Strategic value assessment
//   - Expansion/contraction tracking
//   - Faction territories
//   - Contested zones
// ============================================================================

import React, { useState, useMemo, useCallback } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

// ─── TERRITORY TYPES ──────────────────────────────────────────────────────────
const TERRITORY_TYPES = {
  controlled: { color: '#00ff88', label: 'Controlled', description: 'Full sovereign control' },
  contested: { color: '#ffaa00', label: 'Contested', description: 'Active conflict zone' },
  neutral: { color: '#4488ff', label: 'Neutral', description: 'Unclaimed territory' },
  hostile: { color: '#ff4444', label: 'Hostile', description: 'Enemy controlled' },
  allied: { color: '#aa88ff', label: 'Allied', description: 'Friendly territory' },
  restricted: { color: '#ff88aa', label: 'Restricted', description: 'No-fly zone' },
};

// ─── RESOURCE TYPES ───────────────────────────────────────────────────────────
const RESOURCE_TYPES = {
  energy: { icon: '⚡', color: '#ffff00', label: 'Energy' },
  minerals: { icon: '💎', color: '#00ffff', label: 'Minerals' },
  data: { icon: '📊', color: '#aa44ff', label: 'Data' },
  strategic: { icon: '⭐', color: '#ffd700', label: 'Strategic Value' },
};

// ─── HEX GRID VISUALIZATION ───────────────────────────────────────────────────
function HexTile({ q, r, territory, selected, onSelect }) {
  // Axial to pixel conversion
  const x = 1.5 * q;
  const y = Math.sqrt(3) * (r + q / 2);
  
  const color = TERRITORY_TYPES[territory.type]?.color || '#1a3a5c';
  const isSelected = selected?.q === q && selected?.r === r;
  
  return (
    <g
      transform={`translate(${x * 30 + 200}, ${y * 30 + 200})`}
      onClick={() => onSelect({ q, r, ...territory })}
      style={{ cursor: 'pointer' }}
    >
      {/* Hex shape */}
      <polygon
        points="30,0 15,26 -15,26 -30,0 -15,-26 15,-26"
        fill={color}
        fillOpacity={0.3 + territory.control * 0.5}
        stroke={isSelected ? '#ffffff' : color}
        strokeWidth={isSelected ? 3 : 1}
      />
      
      {/* Control indicator */}
      <circle
        cx="0"
        cy="0"
        r={8 * territory.control}
        fill={color}
        opacity={0.8}
      />
      
      {/* Resource icons */}
      {territory.resources?.slice(0, 2).map((res, i) => (
        <text
          key={res}
          x={i * 12 - 6}
          y={15}
          fontSize="10"
          textAnchor="middle"
        >
          {RESOURCE_TYPES[res]?.icon || '•'}
        </text>
      ))}
    </g>
  );
}

function HexGrid({ territories, selected, onSelect }) {
  return (
    <svg width="100%" height="100%" viewBox="0 0 400 400">
      <defs>
        <pattern id="grid" width="60" height="52" patternUnits="userSpaceOnUse">
          <path
            d="M30,0 L15,26 L-15,26 L-30,0 L-15,-26 L15,-26 Z"
            fill="none"
            stroke="#1a3a5c"
            strokeWidth="0.5"
            transform="translate(30, 26)"
          />
        </pattern>
      </defs>
      <rect width="100%" height="100%" fill="#050a14" />
      
      {territories.map(t => (
        <HexTile
          key={`${t.q},${t.r}`}
          {...t}
          territory={t}
          selected={selected}
          onSelect={onSelect}
        />
      ))}
    </svg>
  );
}

// ─── TERRITORY DETAIL ─────────────────────────────────────────────────────────
function TerritoryDetail({ territory }) {
  if (!territory) {
    return (
      <div style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        height: '100%',
        color: '#68a',
        fontSize: 10,
      }}>
        Select a territory to view details
      </div>
    );
  }
  
  const typeData = TERRITORY_TYPES[territory.type] || TERRITORY_TYPES.neutral;
  
  return (
    <div style={{
      background: '#050a14',
      border: `1px solid ${typeData.color}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
        <div style={{
          width: 16,
          height: 16,
          borderRadius: 4,
          background: typeData.color,
        }} />
        <div>
          <div style={{ fontSize: 12, color: typeData.color, fontWeight: 'bold' }}>
            Sector ({territory.q}, {territory.r})
          </div>
          <div style={{ fontSize: 9, color: '#68a' }}>{typeData.description}</div>
        </div>
      </div>
      
      {/* Control meter */}
      <div style={{ marginBottom: 12 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
          <span style={{ fontSize: 9, color: '#6af' }}>Control Level</span>
          <span style={{ fontSize: 9, color: typeData.color }}>
            {(territory.control * 100).toFixed(0)}%
          </span>
        </div>
        <div style={{
          height: 8,
          background: '#0a1a2e',
          borderRadius: 4,
          overflow: 'hidden',
        }}>
          <div style={{
            width: `${territory.control * 100}%`,
            height: '100%',
            background: typeData.color,
          }} />
        </div>
      </div>
      
      {/* Resources */}
      <div style={{ marginBottom: 12 }}>
        <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>RESOURCES</div>
        <div style={{ display: 'flex', gap: 8 }}>
          {(territory.resources || []).map(res => (
            <div key={res} style={{
              display: 'flex',
              alignItems: 'center',
              gap: 4,
              padding: '4px 8px',
              borderRadius: 4,
              background: `${RESOURCE_TYPES[res]?.color}22`,
              border: `1px solid ${RESOURCE_TYPES[res]?.color}`,
            }}>
              <span>{RESOURCE_TYPES[res]?.icon}</span>
              <span style={{ fontSize: 8, color: RESOURCE_TYPES[res]?.color }}>
                {RESOURCE_TYPES[res]?.label}
              </span>
            </div>
          ))}
          {(!territory.resources || territory.resources.length === 0) && (
            <span style={{ fontSize: 9, color: '#68a' }}>No resources</span>
          )}
        </div>
      </div>
      
      {/* Statistics */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 8 }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Strategic Value</div>
          <div style={{ fontSize: 14, color: '#ffd700' }}>
            {territory.strategicValue?.toFixed(0) || 0}
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Drone Presence</div>
          <div style={{ fontSize: 14, color: '#00ff88' }}>
            {territory.droneCount || 0}
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Threat Level</div>
          <div style={{ fontSize: 14, color: territory.threat > 0.5 ? '#ff4444' : '#ffaa00' }}>
            {(territory.threat * 100).toFixed(0)}%
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Stability</div>
          <div style={{ fontSize: 14, color: territory.stability > 0.7 ? '#00ff88' : '#ffaa00' }}>
            {(territory.stability * 100).toFixed(0)}%
          </div>
        </div>
      </div>
    </div>
  );
}

// ─── TERRITORY STATS ──────────────────────────────────────────────────────────
function TerritoryStats({ territories }) {
  const stats = useMemo(() => {
    const counts = {};
    Object.keys(TERRITORY_TYPES).forEach(t => counts[t] = 0);
    
    let totalControl = 0;
    let totalValue = 0;
    
    territories.forEach(t => {
      counts[t.type] = (counts[t.type] || 0) + 1;
      totalControl += t.control || 0;
      totalValue += t.strategicValue || 0;
    });
    
    return {
      counts,
      avgControl: territories.length > 0 ? totalControl / territories.length : 0,
      totalValue,
      total: territories.length,
    };
  }, [territories]);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#6af', marginBottom: 8 }}>TERRITORY SUMMARY</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginBottom: 12 }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 20, color: '#00ff88' }}>{stats.counts.controlled || 0}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Controlled</div>
        </div>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 20, color: '#ffaa00' }}>{stats.counts.contested || 0}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Contested</div>
        </div>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 20, color: '#ff4444' }}>{stats.counts.hostile || 0}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Hostile</div>
        </div>
      </div>
      
      <div style={{ marginBottom: 8 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9 }}>
          <span style={{ color: '#68a' }}>Average Control</span>
          <span style={{ color: '#4af' }}>{(stats.avgControl * 100).toFixed(0)}%</span>
        </div>
        <div style={{
          height: 6,
          background: '#050a14',
          borderRadius: 3,
          overflow: 'hidden',
          marginTop: 2,
        }}>
          <div style={{
            width: `${stats.avgControl * 100}%`,
            height: '100%',
            background: '#4af',
          }} />
        </div>
      </div>
      
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9 }}>
        <span style={{ color: '#68a' }}>Total Strategic Value</span>
        <span style={{ color: '#ffd700' }}>{stats.totalValue.toFixed(0)}</span>
      </div>
    </div>
  );
}

// ─── EXPANSION TRACKER ────────────────────────────────────────────────────────
function ExpansionTracker({ history }) {
  const maxValue = Math.max(...history.map(h => h.controlled), 1);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #00ff88',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#00ff88', marginBottom: 8 }}>📈 EXPANSION HISTORY</div>
      
      <div style={{
        height: 80,
        display: 'flex',
        alignItems: 'flex-end',
        gap: 2,
      }}>
        {history.map((point, i) => (
          <div
            key={i}
            style={{
              flex: 1,
              height: `${(point.controlled / maxValue) * 100}%`,
              background: `linear-gradient(to top, #00ff8844, #00ff88)`,
              borderRadius: '2px 2px 0 0',
              minHeight: 2,
            }}
            title={`Tick ${point.tick}: ${point.controlled} sectors`}
          />
        ))}
      </div>
      
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 7, color: '#68a', marginTop: 4 }}>
        <span>Past</span>
        <span>Present</span>
      </div>
    </div>
  );
}

// ─── BORDER CONFLICTS ─────────────────────────────────────────────────────────
function BorderConflicts({ conflicts }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ff4444',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#ff4444', marginBottom: 8 }}>⚔️ BORDER CONFLICTS</div>
      
      {conflicts.length === 0 ? (
        <div style={{ fontSize: 9, color: '#68a' }}>No active conflicts</div>
      ) : (
        conflicts.map((conflict, i) => (
          <div key={i} style={{
            padding: 8,
            marginBottom: 4,
            borderRadius: 4,
            background: '#050a14',
            border: `1px solid ${conflict.intensity > 0.7 ? '#ff4444' : '#ffaa00'}`,
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
              <span style={{ fontSize: 9, color: '#adf' }}>
                ({conflict.location.q}, {conflict.location.r})
              </span>
              <span style={{
                fontSize: 8,
                color: conflict.intensity > 0.7 ? '#ff4444' : '#ffaa00',
              }}>
                {conflict.intensity > 0.7 ? 'HIGH' : conflict.intensity > 0.4 ? 'MEDIUM' : 'LOW'}
              </span>
            </div>
            <div style={{
              height: 4,
              background: '#0a1a2e',
              borderRadius: 2,
              overflow: 'hidden',
            }}>
              <div style={{
                width: `${conflict.intensity * 100}%`,
                height: '100%',
                background: conflict.intensity > 0.7 ? '#ff4444' : '#ffaa00',
              }} />
            </div>
            <div style={{ fontSize: 7, color: '#68a', marginTop: 2 }}>
              {conflict.description || 'Active engagement'}
            </div>
          </div>
        ))
      )}
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
    fontSize: 12,
    color: '#00ff88',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 280px',
    gap: 10,
    padding: 10,
    overflow: 'hidden',
  },
  leftPanel: {
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
  },
  mapContainer: {
    flex: 1,
    background: '#050a14',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
    overflow: 'hidden',
  },
  rightPanel: {
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
    overflow: 'auto',
  },
  legend: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: 8,
    padding: '8px 12px',
    background: '#050a14',
    borderRadius: 6,
  },
  legendItem: (color) => ({
    display: 'flex',
    alignItems: 'center',
    gap: 4,
    fontSize: 8,
    color: '#68a',
  }),
  legendDot: (color) => ({
    width: 8,
    height: 8,
    borderRadius: '50%',
    background: color,
  }),
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function TerritoryGrid({ territoryState = {} }) {
  const [selectedTerritory, setSelectedTerritory] = useState(null);
  
  // Generate sample territories if none provided
  const territories = territoryState.territories || useMemo(() => {
    const result = [];
    const types = Object.keys(TERRITORY_TYPES);
    const resources = Object.keys(RESOURCE_TYPES);
    
    for (let q = -3; q <= 3; q++) {
      for (let r = -3; r <= 3; r++) {
        if (Math.abs(q + r) <= 3) {
          const dist = Math.sqrt(q * q + r * r);
          result.push({
            q,
            r,
            type: dist < 1.5 ? 'controlled' : 
                  dist < 2.5 ? (Math.random() > 0.5 ? 'contested' : 'controlled') :
                  dist < 3.5 ? (Math.random() > 0.7 ? 'hostile' : 'neutral') : 'neutral',
            control: Math.max(0, 1 - dist * 0.2 + Math.random() * 0.3),
            resources: Math.random() > 0.6 ? 
              [resources[Math.floor(Math.random() * resources.length)]] : [],
            strategicValue: Math.floor((4 - dist) * 20 + Math.random() * 30),
            droneCount: Math.floor(Math.random() * 10),
            threat: Math.random() * (dist > 2 ? 0.8 : 0.3),
            stability: 1 - dist * 0.1 + Math.random() * 0.2,
          });
        }
      }
    }
    return result;
  }, []);
  
  const expansionHistory = territoryState.history || [
    { tick: 1, controlled: 5 },
    { tick: 2, controlled: 7 },
    { tick: 3, controlled: 6 },
    { tick: 4, controlled: 9 },
    { tick: 5, controlled: 11 },
    { tick: 6, controlled: 10 },
    { tick: 7, controlled: 13 },
    { tick: 8, controlled: 15 },
  ];
  
  const conflicts = territoryState.conflicts || [
    { location: { q: 2, r: 1 }, intensity: 0.75, description: 'Heavy engagement' },
    { location: { q: -2, r: 2 }, intensity: 0.45, description: 'Skirmish' },
  ];
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={{ fontSize: 20 }}>🗺️</span>
        <span style={styles.title}>Atlas Territory Grid</span>
        <span style={{ fontSize: 9, color: '#68a', marginLeft: 'auto' }}>
          {territories.length} sectors
        </span>
      </div>
      
      <div style={styles.content}>
        <div style={styles.leftPanel}>
          <div style={styles.mapContainer}>
            <HexGrid
              territories={territories}
              selected={selectedTerritory}
              onSelect={setSelectedTerritory}
            />
          </div>
          
          <div style={styles.legend}>
            {Object.entries(TERRITORY_TYPES).map(([type, data]) => (
              <div key={type} style={styles.legendItem(data.color)}>
                <div style={styles.legendDot(data.color)} />
                <span>{data.label}</span>
              </div>
            ))}
          </div>
        </div>
        
        <div style={styles.rightPanel}>
          <TerritoryDetail territory={selectedTerritory} />
          <TerritoryStats territories={territories} />
          <ExpansionTracker history={expansionHistory} />
          <BorderConflicts conflicts={conflicts} />
        </div>
      </div>
    </div>
  );
}
