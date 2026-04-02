// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: DestructionMonitor — REAL Structural Destruction
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// EVERYTHING BREAKS. REALISTICALLY.
//   - Trees: wood fiber simulation, break at weak points
//   - Buildings: structural integrity, load-bearing, progressive collapse
//   - Terrain: craters, erosion, landslides
//
// Based on real structural engineering and material science.
// ============================================================================

import React, { useState, useMemo, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;
const GRAVITY = 9.80665;

// ─── MATERIAL PROPERTIES (matching backend) ───────────────────────────────────
const MATERIALS = {
  Wood: {
    tensileStrength: 40e6,        // Pa
    compressiveStrength: 30e6,
    density: 600,                 // kg/m³
    fractureEnergy: 10000,        // J/m²
    color: '#8B4513',
  },
  Concrete: {
    tensileStrength: 3e6,
    compressiveStrength: 30e6,
    density: 2400,
    fractureEnergy: 100,
    color: '#808080',
  },
  Steel: {
    tensileStrength: 400e6,
    compressiveStrength: 400e6,
    density: 7850,
    fractureEnergy: 50000,
    color: '#4682B4',
  },
  Glass: {
    tensileStrength: 40e6,
    compressiveStrength: 1000e6,
    density: 2500,
    fractureEnergy: 10,
    color: '#87CEEB',
  },
  Earth: {
    tensileStrength: 0,
    compressiveStrength: 1e6,
    density: 1800,
    fractureEnergy: 50,
    color: '#654321',
  },
};

// ─── HEALTH BAR ───────────────────────────────────────────────────────────────
function HealthBar({ current, maximum, label }) {
  const pct = current / maximum;
  const color = pct > 0.6 ? '#00ff88' : pct > 0.3 ? '#ffaa00' : '#ff4444';
  
  return (
    <div style={{ marginBottom: 6 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
        <span style={{ fontSize: 8, color: '#68a' }}>{label}</span>
        <span style={{ fontSize: 8, color }}>{current.toFixed(0)} / {maximum.toFixed(0)}</span>
      </div>
      <div style={{
        height: 6,
        background: '#0a1a2e',
        borderRadius: 3,
        overflow: 'hidden',
      }}>
        <div style={{
          width: `${pct * 100}%`,
          height: '100%',
          background: color,
          transition: 'width 0.3s',
        }} />
      </div>
    </div>
  );
}

// ─── INTEGRITY METER ──────────────────────────────────────────────────────────
function IntegrityMeter({ value, weakPoints }) {
  const brokenCount = weakPoints.filter(wp => wp.isBroken).length;
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 6,
      padding: 10,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>STRUCTURAL INTEGRITY</div>
      
      {/* Circular gauge */}
      <div style={{
        width: 80,
        height: 80,
        margin: '0 auto',
        position: 'relative',
      }}>
        <svg width="80" height="80" viewBox="0 0 80 80">
          {/* Background circle */}
          <circle
            cx="40"
            cy="40"
            r="35"
            fill="none"
            stroke="#1a3a5c"
            strokeWidth="6"
          />
          {/* Progress arc */}
          <circle
            cx="40"
            cy="40"
            r="35"
            fill="none"
            stroke={value > 0.6 ? '#00ff88' : value > 0.3 ? '#ffaa00' : '#ff4444'}
            strokeWidth="6"
            strokeDasharray={`${value * 220} 220`}
            strokeLinecap="round"
            transform="rotate(-90 40 40)"
          />
        </svg>
        <div style={{
          position: 'absolute',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          textAlign: 'center',
        }}>
          <div style={{ fontSize: 18, color: '#4af', fontWeight: 'bold' }}>
            {(value * 100).toFixed(0)}%
          </div>
        </div>
      </div>
      
      <div style={{ fontSize: 8, color: '#68a', textAlign: 'center', marginTop: 6 }}>
        Weak Points: {brokenCount}/{weakPoints.length} broken
      </div>
    </div>
  );
}

// ─── WEAK POINT DIAGRAM ───────────────────────────────────────────────────────
function WeakPointDiagram({ weakPoints, objectType }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 6,
      padding: 10,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>WEAK POINTS</div>
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fill, minmax(60px, 1fr))',
        gap: 4,
      }}>
        {weakPoints.map((wp, i) => {
          const stressRatio = wp.stress / wp.strength;
          const color = wp.isBroken ? '#ff4444' : stressRatio > 0.8 ? '#ffaa00' : '#00ff88';
          
          return (
            <div key={i} style={{
              background: '#050a14',
              border: `1px solid ${color}`,
              borderRadius: 4,
              padding: 4,
              textAlign: 'center',
            }}>
              <div style={{ fontSize: 7, color: '#68a' }}>Point {i + 1}</div>
              <div style={{ fontSize: 10, color }}>{wp.isBroken ? 'BROKEN' : `${(stressRatio * 100).toFixed(0)}%`}</div>
              <div style={{ fontSize: 7, color: '#68a' }}>
                {(wp.stress / 1000).toFixed(0)} kPa
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ─── FRAGMENT LIST ────────────────────────────────────────────────────────────
function FragmentList({ fragments }) {
  const totalMass = fragments.reduce((s, f) => s + f.mass, 0);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 6,
      padding: 10,
      maxHeight: 150,
      overflow: 'auto',
    }}>
      <div style={{ fontSize: 9, color: '#ff8800', marginBottom: 6 }}>
        DEBRIS ({fragments.length} fragments, {totalMass.toFixed(1)} kg)
      </div>
      {fragments.slice(0, 10).map((frag, i) => (
        <div key={i} style={{
          display: 'flex',
          justifyContent: 'space-between',
          fontSize: 8,
          color: '#68a',
          padding: '2px 0',
          borderBottom: '1px solid #1a2a3c',
        }}>
          <span>Fragment {i + 1}</span>
          <span>{frag.mass.toFixed(2)} kg</span>
          <span>{frag.velocity ? Math.sqrt(frag.velocity.x**2 + frag.velocity.y**2 + frag.velocity.z**2).toFixed(1) : 0} m/s</span>
        </div>
      ))}
      {fragments.length > 10 && (
        <div style={{ fontSize: 8, color: '#446', textAlign: 'center', marginTop: 4 }}>
          + {fragments.length - 10} more
        </div>
      )}
    </div>
  );
}

// ─── DESTRUCTIBLE OBJECT CARD ─────────────────────────────────────────────────
function DestructibleObjectCard({ object, selected, onSelect }) {
  const stateColor = object.isDestroyed ? '#ff4444' : object.isCollapsing ? '#ffaa00' : '#00ff88';
  const stateLabel = object.isDestroyed ? 'DESTROYED' : object.isCollapsing ? 'COLLAPSING' : 'INTACT';
  
  return (
    <div
      onClick={() => onSelect(object)}
      style={{
        background: selected ? '#1a2a4e' : '#0a1a2e',
        border: `1px solid ${selected ? '#4af' : '#1a3a5c'}`,
        borderRadius: 4,
        padding: 10,
        cursor: 'pointer',
        marginBottom: 6,
      }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
        <span style={{ fontSize: 10, color: '#4af', fontWeight: 'bold' }}>
          {object.name || `${object.objType} #${object.id}`}
        </span>
        <span style={{
          fontSize: 8,
          padding: '2px 6px',
          borderRadius: 8,
          background: `${stateColor}22`,
          color: stateColor,
          border: `1px solid ${stateColor}`,
        }}>
          {stateLabel}
        </span>
      </div>
      
      <HealthBar
        current={object.health?.current || 0}
        maximum={object.health?.maximum || 100}
        label="Health"
      />
      
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 8, color: '#68a' }}>
        <span>Mass: {object.mass?.toFixed(0) || 0} kg</span>
        <span>Integrity: {((object.health?.integrity || 0) * 100).toFixed(0)}%</span>
      </div>
      
      {object.isCollapsing && (
        <div style={{
          marginTop: 6,
          height: 4,
          background: '#0a1a2e',
          borderRadius: 2,
          overflow: 'hidden',
        }}>
          <div style={{
            width: `${(object.collapseProgress || 0) * 100}%`,
            height: '100%',
            background: '#ff8800',
            transition: 'width 0.3s',
          }} />
        </div>
      )}
    </div>
  );
}

// ─── 3D DESTRUCTION PREVIEW ───────────────────────────────────────────────────
function DestructionPreview({ object }) {
  const meshRef = useRef();
  
  useFrame(({ clock }) => {
    if (!meshRef.current) return;
    const t = clock.getElapsedTime();
    
    if (object?.isCollapsing) {
      // Simulate collapse
      const progress = object.collapseProgress || 0;
      meshRef.current.rotation.z = progress * (π / 4) * (object.collapseDirection?.x > 0 ? 1 : -1);
      meshRef.current.position.y = -progress * 2;
    } else {
      meshRef.current.rotation.y = t * 0.2;
    }
  });
  
  const geometry = useMemo(() => {
    switch (object?.objType) {
      case 'Tree':
        return <cylinderGeometry args={[0.3, 0.5, 3, 8]} />;
      case 'Building':
        return <boxGeometry args={[2, 3, 2]} />;
      case 'Wall':
        return <boxGeometry args={[3, 2, 0.3]} />;
      default:
        return <boxGeometry args={[1, 1, 1]} />;
    }
  }, [object?.objType]);
  
  const integrity = object?.health?.integrity || 1;
  const color = integrity > 0.6 ? '#4af' : integrity > 0.3 ? '#ffaa00' : '#ff4444';
  
  return (
    <Canvas camera={{ position: [4, 3, 4], fov: 50 }}>
      <ambientLight intensity={0.4} />
      <directionalLight position={[5, 5, 5]} intensity={0.6} />
      <mesh ref={meshRef}>
        {geometry}
        <meshStandardMaterial
          color={color}
          wireframe={object?.isDestroyed}
          transparent
          opacity={object?.isDestroyed ? 0.3 : 1}
        />
      </mesh>
      <gridHelper args={[10, 10, '#1a3a5c', '#0a1a2e']} />
    </Canvas>
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
    padding: '8px 12px',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  title: {
    fontSize: 11,
    color: '#ff8800',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 8,
    padding: 10,
    overflow: 'hidden',
  },
  leftColumn: {
    display: 'flex',
    flexDirection: 'column',
    gap: 8,
    overflow: 'auto',
  },
  rightColumn: {
    display: 'flex',
    flexDirection: 'column',
    gap: 8,
    overflow: 'auto',
  },
  preview: {
    height: 200,
    background: '#050a14',
    border: '1px solid #1a3a5c',
    borderRadius: 6,
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function DestructionMonitor({ destructionState = {} }) {
  const [selectedObject, setSelectedObject] = useState(null);
  
  // Sample destruction state if none provided
  const objects = destructionState.objects?.length > 0 ? destructionState.objects : [
    {
      id: 1,
      objType: 'Building',
      name: 'Target Structure Alpha',
      mass: 50000,
      health: { current: 75, maximum: 100, integrity: 0.75, weakPoints: [
        { position: { x: 0, y: 2, z: 0 }, strength: 30e6, stress: 20e6, isBroken: false },
        { position: { x: 1, y: 1, z: 0 }, strength: 25e6, stress: 5e6, isBroken: false },
        { position: { x: -1, y: 1, z: 0 }, strength: 25e6, stress: 28e6, isBroken: true },
      ]},
      isDestroyed: false,
      isCollapsing: false,
      collapseProgress: 0,
      collapseDirection: { x: 1, y: 0, z: 0 },
      fragments: [],
    },
    {
      id: 2,
      objType: 'Tree',
      name: 'Oak Tree 47',
      mass: 500,
      health: { current: 30, maximum: 100, integrity: 0.3, weakPoints: [
        { position: { x: 0, y: 1, z: 0 }, strength: 40e6, stress: 35e6, isBroken: false },
        { position: { x: 0, y: 0.5, z: 0 }, strength: 45e6, stress: 50e6, isBroken: true },
      ]},
      isDestroyed: false,
      isCollapsing: true,
      collapseProgress: 0.4,
      collapseDirection: { x: 0.7, y: 0, z: 0.7 },
      fragments: [
        { mass: 50, velocity: { x: 2, y: 1, z: 1 } },
        { mass: 30, velocity: { x: -1, y: 2, z: 0 } },
      ],
    },
    {
      id: 3,
      objType: 'Wall',
      name: 'Perimeter Wall Section',
      mass: 2000,
      health: { current: 0, maximum: 100, integrity: 0, weakPoints: [
        { position: { x: 0, y: 0, z: 0 }, strength: 3e6, stress: 5e6, isBroken: true },
      ]},
      isDestroyed: true,
      isCollapsing: false,
      collapseProgress: 1,
      collapseDirection: { x: 0, y: -1, z: 0 },
      fragments: [
        { mass: 200, velocity: { x: 3, y: -2, z: 1 } },
        { mass: 150, velocity: { x: -2, y: -3, z: 2 } },
        { mass: 100, velocity: { x: 1, y: -1, z: -1 } },
        { mass: 80, velocity: { x: -1, y: -2, z: -2 } },
        { mass: 50, velocity: { x: 2, y: -1, z: 0 } },
      ],
    },
  ];
  
  const selected = selectedObject || objects[0];
  const totalDestroyed = objects.filter(o => o.isDestroyed).length;
  const totalCollapsing = objects.filter(o => o.isCollapsing).length;
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>💥 Destruction Monitor</span>
        <span style={{ fontSize: 9, color: '#ff4444' }}>Destroyed: {totalDestroyed}</span>
        <span style={{ fontSize: 9, color: '#ffaa00' }}>Collapsing: {totalCollapsing}</span>
        <span style={{ fontSize: 9, color: '#00ff88', marginLeft: 'auto' }}>
          Intact: {objects.length - totalDestroyed - totalCollapsing}
        </span>
      </div>
      
      <div style={styles.content}>
        <div style={styles.leftColumn}>
          <div style={{ fontSize: 9, color: '#6af', marginBottom: 4 }}>DESTRUCTIBLE OBJECTS</div>
          {objects.map(obj => (
            <DestructibleObjectCard
              key={obj.id}
              object={obj}
              selected={selected?.id === obj.id}
              onSelect={setSelectedObject}
            />
          ))}
        </div>
        
        <div style={styles.rightColumn}>
          {selected && (
            <>
              <div style={styles.preview}>
                <DestructionPreview object={selected} />
              </div>
              
              <IntegrityMeter
                value={selected.health?.integrity || 0}
                weakPoints={selected.health?.weakPoints || []}
              />
              
              {selected.health?.weakPoints?.length > 0 && (
                <WeakPointDiagram
                  weakPoints={selected.health.weakPoints}
                  objectType={selected.objType}
                />
              )}
              
              {selected.fragments?.length > 0 && (
                <FragmentList fragments={selected.fragments} />
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}
