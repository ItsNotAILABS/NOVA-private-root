// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: DreamStateViewer — Organism Dream Visualization
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// The organism DREAMS. This visualizes those dreams:
//   - Awake state (normal processing)
//   - Dreaming (generative simulation)
//   - Lucid (conscious dream control)
//   - Preplay (future prediction)
//   - Replay (memory consolidation)
//
// Dreams become artifacts: videos, audio, game assets, NFTs
// ============================================================================

import React, { useRef, useMemo, useState } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

const DREAM_STATES = {
  awake: { color: '#00ff88', label: 'AWAKE', description: 'Normal cognitive processing' },
  dreaming: { color: '#aa44ff', label: 'DREAMING', description: 'Generative simulation active' },
  lucid: { color: '#ffd700', label: 'LUCID', description: 'Conscious dream control' },
  preplay: { color: '#00aaff', label: 'PREPLAY', description: 'Future path prediction' },
  replay: { color: '#ff8800', label: 'REPLAY', description: 'Memory consolidation' },
  deepSleep: { color: '#4400aa', label: 'DEEP SLEEP', description: 'Restoration mode' },
};

// ─── DREAM PARTICLE SYSTEM ────────────────────────────────────────────────────
function DreamParticles({ state, intensity }) {
  const pointsRef = useRef();
  const count = 500;
  
  const [positions, colors] = useMemo(() => {
    const pos = new Float32Array(count * 3);
    const col = new Float32Array(count * 3);
    const stateColor = new THREE.Color(DREAM_STATES[state]?.color || '#aa44ff');
    
    for (let i = 0; i < count; i++) {
      // Fibonacci spiral distribution
      const t = i / count;
      const angle = i * φ * π * 2;
      const radius = t * 4;
      
      pos[i * 3] = Math.cos(angle) * radius;
      pos[i * 3 + 1] = (Math.random() - 0.5) * 3;
      pos[i * 3 + 2] = Math.sin(angle) * radius;
      
      col[i * 3] = stateColor.r;
      col[i * 3 + 1] = stateColor.g;
      col[i * 3 + 2] = stateColor.b;
    }
    return [pos, col];
  }, [state]);
  
  useFrame(({ clock }) => {
    if (!pointsRef.current) return;
    const t = clock.getElapsedTime();
    const positions = pointsRef.current.geometry.attributes.position.array;
    
    for (let i = 0; i < count; i++) {
      const idx = i * 3;
      const angle = i * φ * π * 2;
      const baseRadius = (i / count) * 4;
      
      // Dream-like flowing motion
      const pulse = Math.sin(t * 0.5 + i * 0.01) * intensity;
      const radius = baseRadius + pulse;
      const yOffset = Math.sin(t + i * 0.1) * intensity * 0.5;
      
      positions[idx] = Math.cos(angle + t * 0.2) * radius;
      positions[idx + 1] = positions[idx + 1] * 0.99 + yOffset * 0.01;
      positions[idx + 2] = Math.sin(angle + t * 0.2) * radius;
    }
    pointsRef.current.geometry.attributes.position.needsUpdate = true;
    pointsRef.current.rotation.y = t * 0.1;
  });
  
  return (
    <points ref={pointsRef}>
      <bufferGeometry>
        <bufferAttribute
          attach="attributes-position"
          count={count}
          array={positions}
          itemSize={3}
        />
        <bufferAttribute
          attach="attributes-color"
          count={count}
          array={colors}
          itemSize={3}
        />
      </bufferGeometry>
      <pointsMaterial
        size={0.08}
        vertexColors
        transparent
        opacity={0.7}
        sizeAttenuation
      />
    </points>
  );
}

// ─── DREAM CORE ───────────────────────────────────────────────────────────────
function DreamCore({ state, lucidity }) {
  const meshRef = useRef();
  const color = new THREE.Color(DREAM_STATES[state]?.color || '#aa44ff');
  
  useFrame(({ clock }) => {
    if (!meshRef.current) return;
    const t = clock.getElapsedTime();
    
    // Pulsing core
    const scale = 1 + 0.2 * Math.sin(t * 2) * lucidity;
    meshRef.current.scale.setScalar(scale);
    meshRef.current.rotation.x = t * 0.3;
    meshRef.current.rotation.y = t * 0.2;
  });
  
  return (
    <mesh ref={meshRef}>
      <icosahedronGeometry args={[0.8, 2]} />
      <meshStandardMaterial
        color={color}
        emissive={color}
        emissiveIntensity={0.5 + lucidity * 0.5}
        wireframe={state === 'lucid'}
        transparent
        opacity={0.8}
      />
    </mesh>
  );
}

function DreamScene({ state, intensity, lucidity }) {
  return (
    <>
      <ambientLight intensity={0.2} />
      <pointLight position={[0, 0, 0]} intensity={0.5 + intensity} color={DREAM_STATES[state]?.color} />
      <DreamCore state={state} lucidity={lucidity} />
      <DreamParticles state={state} intensity={intensity} />
    </>
  );
}

// ─── ARTIFACT PREVIEW ─────────────────────────────────────────────────────────
function ArtifactPreview({ artifact }) {
  const typeIcons = {
    video: '🎬',
    audio: '🎵',
    image: '🖼️',
    nft: '💎',
    gameAsset: '🎮',
    simulation: '🌐',
  };
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 4,
      padding: '6px 8px',
      display: 'flex',
      alignItems: 'center',
      gap: 8,
      marginBottom: 4,
    }}>
      <span style={{ fontSize: 16 }}>{typeIcons[artifact.type] || '📦'}</span>
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 9, color: '#adf' }}>{artifact.name}</div>
        <div style={{ fontSize: 8, color: '#68a' }}>{artifact.type} • {artifact.rarity || 'common'}</div>
      </div>
      <span style={{ fontSize: 8, color: '#ffd700' }}>
        {artifact.status === 'generating' ? '⏳' : '✓'}
      </span>
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
    color: '#aa44ff',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  stateBadge: (color) => ({
    fontSize: 9,
    padding: '2px 8px',
    borderRadius: 10,
    background: `${color}22`,
    color: color,
    border: `1px solid ${color}`,
    fontWeight: 'bold',
  }),
  canvas: {
    flex: 1,
    minHeight: 180,
  },
  controls: {
    padding: '8px 12px',
    borderTop: '1px solid #1a3a5c',
    display: 'flex',
    gap: 8,
  },
  slider: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    gap: 2,
  },
  sliderLabel: {
    fontSize: 8,
    color: '#68a',
    display: 'flex',
    justifyContent: 'space-between',
  },
  artifacts: {
    padding: '8px 12px',
    borderTop: '1px solid #1a3a5c',
    maxHeight: 120,
    overflow: 'auto',
  },
  sectionTitle: {
    fontSize: 9,
    color: '#ffd700',
    marginBottom: 6,
    letterSpacing: '0.1em',
    textTransform: 'uppercase',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function DreamStateViewer({ organismState = {} }) {
  const {
    dreamState = 'dreaming',
    dreamIntensity = 0.7,
    lucidity = 0.5,
    generatingArtifacts = [],
  } = organismState;
  
  const stateInfo = DREAM_STATES[dreamState] || DREAM_STATES.dreaming;
  
  // Sample artifacts if none provided
  const artifacts = generatingArtifacts.length > 0 ? generatingArtifacts : [
    { id: 1, name: 'DreamSequence_042', type: 'video', rarity: 'rare', status: 'generating' },
    { id: 2, name: 'NeuralRhythm_017', type: 'audio', rarity: 'epic', status: 'complete' },
    { id: 3, name: 'PreplayVision_003', type: 'nft', rarity: 'legendary', status: 'generating' },
  ];
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>◈ Dream State</span>
        <span style={styles.stateBadge(stateInfo.color)}>{stateInfo.label}</span>
        <span style={{ fontSize: 8, color: '#68a', marginLeft: 'auto' }}>
          {stateInfo.description}
        </span>
      </div>
      
      <div style={styles.canvas}>
        <Canvas camera={{ position: [0, 0, 8], fov: 50 }}>
          <DreamScene state={dreamState} intensity={dreamIntensity} lucidity={lucidity} />
        </Canvas>
      </div>
      
      <div style={styles.controls}>
        <div style={styles.slider}>
          <div style={styles.sliderLabel}>
            <span>Intensity</span>
            <span style={{ color: '#aa44ff' }}>{(dreamIntensity * 100).toFixed(0)}%</span>
          </div>
          <input
            type="range"
            min={0}
            max={1}
            step={0.01}
            value={dreamIntensity}
            style={{ width: '100%', accentColor: '#aa44ff' }}
            readOnly
          />
        </div>
        <div style={styles.slider}>
          <div style={styles.sliderLabel}>
            <span>Lucidity</span>
            <span style={{ color: '#ffd700' }}>{(lucidity * 100).toFixed(0)}%</span>
          </div>
          <input
            type="range"
            min={0}
            max={1}
            step={0.01}
            value={lucidity}
            style={{ width: '100%', accentColor: '#ffd700' }}
            readOnly
          />
        </div>
      </div>
      
      <div style={styles.artifacts}>
        <div style={styles.sectionTitle}>◈ Generating Artifacts</div>
        {artifacts.map(artifact => (
          <ArtifactPreview key={artifact.id} artifact={artifact} />
        ))}
      </div>
    </div>
  );
}
