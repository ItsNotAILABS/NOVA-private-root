// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: SharpWaveRippleMonitor — Memory Replay Visualization
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Visualizes hippocampal sharp wave ripples (SWR):
//   - Memory consolidation events
//   - Replay sequences
//   - Preplay (future prediction)
//   - Emotional charge of memories
// ============================================================================

import React, { useRef, useMemo, useState, useEffect } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;

// ─── RIPPLE VISUALIZATION ─────────────────────────────────────────────────────
function Ripple({ ripple, index }) {
  const meshRef = useRef();
  const ringRef = useRef();
  
  useFrame(({ clock }) => {
    if (!meshRef.current) return;
    const t = clock.getElapsedTime();
    
    // Ripple expands and fades
    const age = (t % 3) / 3;
    const scale = 0.5 + age * 2;
    const opacity = (1 - age) * ripple.amplitude;
    
    meshRef.current.scale.setScalar(scale);
    meshRef.current.material.opacity = opacity;
    
    if (ringRef.current) {
      ringRef.current.rotation.z = t * 0.5 + index * φ;
    }
  });
  
  const color = ripple.isPreplay 
    ? new THREE.Color(0x00aaff)  // Blue for preplay
    : new THREE.Color(0xff8800); // Orange for replay
  
  const x = (index % 4 - 1.5) * 2.5;
  const y = Math.floor(index / 4) * 2 - 1;
  
  return (
    <group position={[x, y, 0]}>
      <mesh ref={meshRef}>
        <ringGeometry args={[0.3, 0.5, 32]} />
        <meshBasicMaterial color={color} transparent opacity={0.5} side={THREE.DoubleSide} />
      </mesh>
      <mesh ref={ringRef}>
        <ringGeometry args={[0.6, 0.65, 6]} />
        <meshBasicMaterial color={color} transparent opacity={0.3} wireframe />
      </mesh>
      {/* Emotional charge indicator */}
      <mesh position={[0, 0, 0.1]}>
        <circleGeometry args={[0.15, 16]} />
        <meshBasicMaterial 
          color={ripple.emotionalCharge > 0.5 ? 0xff4444 : 0x44ff88} 
          transparent 
          opacity={ripple.emotionalCharge} 
        />
      </mesh>
    </group>
  );
}

function RippleScene({ ripples }) {
  return (
    <>
      <ambientLight intensity={0.4} />
      {ripples.map((ripple, i) => (
        <Ripple key={ripple.id || i} ripple={ripple} index={i} />
      ))}
    </>
  );
}

// ─── MEMORY TRACE ITEM ────────────────────────────────────────────────────────
function MemoryTraceItem({ trace, index }) {
  const [expanded, setExpanded] = useState(false);
  
  const typeColor = {
    replay: '#ff8800',
    preplay: '#00aaff',
    consolidation: '#aa44ff',
  };
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: `1px solid ${typeColor[trace.type] || '#1a3a5c'}`,
      borderRadius: 4,
      padding: '6px 8px',
      marginBottom: 4,
      cursor: 'pointer',
    }} onClick={() => setExpanded(!expanded)}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <span style={{ fontSize: 9, color: typeColor[trace.type] || '#4af', fontWeight: 'bold' }}>
          {trace.type?.toUpperCase() || 'MEMORY'} #{trace.id}
        </span>
        <span style={{ fontSize: 8, color: '#68a' }}>
          {trace.age?.toFixed(1)}s ago
        </span>
      </div>
      <div style={{ fontSize: 8, color: '#adf', marginTop: 2 }}>
        {trace.content?.slice(0, expanded ? 200 : 50) || 'Memory trace'}
        {!expanded && trace.content?.length > 50 && '...'}
      </div>
      <div style={{ display: 'flex', gap: 8, marginTop: 4 }}>
        <span style={{ fontSize: 7, color: '#68a' }}>
          Strength: {(trace.strength * 100).toFixed(0)}%
        </span>
        <span style={{ fontSize: 7, color: trace.emotionalCharge > 0.5 ? '#ff6644' : '#44aa66' }}>
          Emotion: {(trace.emotionalCharge * 100).toFixed(0)}%
        </span>
        <span style={{ fontSize: 7, color: '#aa88ff' }}>
          Replays: {trace.replayCount || 0}
        </span>
      </div>
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
  stats: {
    marginLeft: 'auto',
    display: 'flex',
    gap: 12,
    fontSize: 9,
  },
  stat: (color) => ({
    color: color,
    display: 'flex',
    alignItems: 'center',
    gap: 4,
  }),
  canvas: {
    height: 120,
    borderBottom: '1px solid #1a3a5c',
  },
  content: {
    flex: 1,
    overflow: 'auto',
    padding: 8,
  },
  sectionTitle: {
    fontSize: 9,
    color: '#6af',
    marginBottom: 6,
    letterSpacing: '0.1em',
    textTransform: 'uppercase',
  },
  emptyState: {
    textAlign: 'center',
    padding: 20,
    color: '#446',
    fontSize: 10,
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function SharpWaveRippleMonitor({ organismState = {} }) {
  const {
    ripples = [],
    memoryTraces = [],
    replayActive = false,
    preplayActive = false,
    consolidationProgress = 0,
  } = organismState;
  
  // Generate sample ripples if none provided
  const displayRipples = ripples.length > 0 ? ripples : Array.from({ length: 6 }, (_, i) => ({
    id: i,
    amplitude: 0.3 + Math.random() * 0.5,
    frequency: 150 + Math.random() * 100,
    isPreplay: i % 3 === 0,
    emotionalCharge: Math.random(),
  }));
  
  // Generate sample traces if none provided
  const displayTraces = memoryTraces.length > 0 ? memoryTraces : [
    { id: 1, type: 'replay', content: 'Territorial boundary patrol sequence', age: 2.5, strength: 0.85, emotionalCharge: 0.3, replayCount: 4 },
    { id: 2, type: 'preplay', content: 'Predicted approach vector for resource acquisition', age: 0.8, strength: 0.92, emotionalCharge: 0.6, replayCount: 1 },
    { id: 3, type: 'consolidation', content: 'Formation diamond pattern locked', age: 5.2, strength: 0.78, emotionalCharge: 0.2, replayCount: 7 },
  ];
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>◈ Sharp Wave Ripples</span>
        <div style={styles.stats}>
          <span style={styles.stat(replayActive ? '#ff8800' : '#333')}>
            ● REPLAY
          </span>
          <span style={styles.stat(preplayActive ? '#00aaff' : '#333')}>
            ● PREPLAY
          </span>
          <span style={{ fontSize: 8, color: '#aa44ff' }}>
            Consolidation: {(consolidationProgress * 100).toFixed(0)}%
          </span>
        </div>
      </div>
      
      <div style={styles.canvas}>
        <Canvas camera={{ position: [0, 0, 6], fov: 50 }}>
          <RippleScene ripples={displayRipples} />
        </Canvas>
      </div>
      
      <div style={styles.content}>
        <div style={styles.sectionTitle}>Memory Traces</div>
        {displayTraces.length === 0 ? (
          <div style={styles.emptyState}>No active memory traces</div>
        ) : (
          displayTraces.map((trace, i) => (
            <MemoryTraceItem key={trace.id || i} trace={trace} index={i} />
          ))
        )}
      </div>
    </div>
  );
}
