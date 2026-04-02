// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: QuantumCoherenceDisplay — Quantum Layer Visualization
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Visualizes the organism's quantum coherence:
//   - 4-Channel quantum states (α, β, γ, δ)
//   - Coherence amplification
//   - Entanglement patterns
//   - Superposition states
// ============================================================================

import React, { useRef, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

const CHANNEL_COLORS = {
  alpha: new THREE.Color(0x33ccff),   // Spatial
  beta: new THREE.Color(0xaa88ff),    // Memory
  gamma: new THREE.Color(0x44dd88),   // Relational
  delta: new THREE.Color(0xffaa33),   // Action
};

// ─── QUANTUM WAVE FUNCTION ────────────────────────────────────────────────────
function QuantumWaveFunction({ channel, amplitude, phase, yOffset }) {
  const lineRef = useRef();
  const color = CHANNEL_COLORS[channel];
  const points = 100;
  
  useFrame(({ clock }) => {
    if (!lineRef.current) return;
    const t = clock.getElapsedTime();
    const positions = lineRef.current.geometry.attributes.position;
    
    for (let i = 0; i < points; i++) {
      const x = (i / points - 0.5) * 8;
      // Schrödinger-like wave with Fibonacci modulation
      const wave = amplitude * Math.sin(x * 3 + t * 2 + phase) * Math.exp(-x * x * 0.05);
      const fibMod = 0.15 * Math.cos(x * φ + t * φ);
      positions.setY(i, yOffset + wave + fibMod);
    }
    positions.needsUpdate = true;
  });
  
  const geometry = useMemo(() => {
    const geo = new THREE.BufferGeometry();
    const positions = new Float32Array(points * 3);
    for (let i = 0; i < points; i++) {
      positions[i * 3] = (i / points - 0.5) * 8;
      positions[i * 3 + 1] = yOffset;
      positions[i * 3 + 2] = 0;
    }
    geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    return geo;
  }, [yOffset]);
  
  return (
    <line ref={lineRef} geometry={geometry}>
      <lineBasicMaterial color={color} linewidth={2} transparent opacity={0.8} />
    </line>
  );
}

// ─── ENTANGLEMENT SPHERE ──────────────────────────────────────────────────────
function EntanglementSphere({ coherence }) {
  const meshRef = useRef();
  const innerRef = useRef();
  
  useFrame(({ clock }) => {
    if (!meshRef.current) return;
    const t = clock.getElapsedTime();
    
    meshRef.current.rotation.x = t * 0.3;
    meshRef.current.rotation.y = t * 0.2 * φ;
    
    const scale = 1 + 0.1 * Math.sin(t * 3) * coherence;
    meshRef.current.scale.setScalar(scale);
    
    if (innerRef.current) {
      innerRef.current.rotation.x = -t * 0.5;
      innerRef.current.rotation.z = t * 0.4;
    }
  });
  
  const color = coherence > 0.7 ? '#ffd700' : coherence > 0.4 ? '#00aaff' : '#aa44ff';
  
  return (
    <group>
      <mesh ref={meshRef}>
        <icosahedronGeometry args={[1.5, 1]} />
        <meshStandardMaterial
          color={color}
          emissive={color}
          emissiveIntensity={coherence * 0.5}
          wireframe
          transparent
          opacity={0.6 + coherence * 0.4}
        />
      </mesh>
      <mesh ref={innerRef}>
        <octahedronGeometry args={[0.8, 0]} />
        <meshStandardMaterial
          color={color}
          emissive={color}
          emissiveIntensity={coherence}
          metalness={0.9}
          roughness={0.1}
        />
      </mesh>
    </group>
  );
}

// ─── QUANTUM SCENE ────────────────────────────────────────────────────────────
function QuantumScene({ channels, coherence }) {
  return (
    <>
      <ambientLight intensity={0.3} />
      <pointLight position={[0, 0, 5]} intensity={0.5} color="#4af" />
      
      {/* Wave functions */}
      <group position={[0, 0, -2]}>
        <QuantumWaveFunction channel="alpha" amplitude={channels.alpha} phase={0} yOffset={1.5} />
        <QuantumWaveFunction channel="beta" amplitude={channels.beta} phase={π/4} yOffset={0.5} />
        <QuantumWaveFunction channel="gamma" amplitude={channels.gamma} phase={π/2} yOffset={-0.5} />
        <QuantumWaveFunction channel="delta" amplitude={channels.delta} phase={3*π/4} yOffset={-1.5} />
      </group>
      
      {/* Central coherence sphere */}
      <EntanglementSphere coherence={coherence} />
    </>
  );
}

// ─── CHANNEL BAR ──────────────────────────────────────────────────────────────
function ChannelBar({ name, label, value, description }) {
  const color = CHANNEL_COLORS[name].getStyle();
  
  return (
    <div style={{ marginBottom: 8 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
        <span style={{ fontSize: 9, color }}>
          {label}
        </span>
        <span style={{ fontSize: 9, color: '#4af' }}>
          {(value * 100).toFixed(0)}%
        </span>
      </div>
      <div style={{
        height: 6,
        background: '#0a1a2e',
        borderRadius: 3,
        overflow: 'hidden',
      }}>
        <div style={{
          height: '100%',
          width: `${value * 100}%`,
          background: color,
          boxShadow: `0 0 6px ${color}`,
          transition: 'width 0.3s',
        }} />
      </div>
      <div style={{ fontSize: 7, color: '#68a', marginTop: 2 }}>
        {description}
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
    color: '#aa44ff',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  coherenceBadge: (coherence) => ({
    fontSize: 9,
    padding: '2px 8px',
    borderRadius: 10,
    background: coherence > 0.7 ? '#3a3a00' : '#1a1a2e',
    color: coherence > 0.7 ? '#ffd700' : '#4af',
    border: coherence > 0.7 ? '1px solid #ffd700' : '1px solid #1a3a5c',
  }),
  canvas: {
    flex: 1,
    minHeight: 150,
  },
  channels: {
    padding: '10px 12px',
    borderTop: '1px solid #1a3a5c',
  },
  metrics: {
    display: 'grid',
    gridTemplateColumns: 'repeat(3, 1fr)',
    gap: 8,
    padding: '8px 12px',
    borderTop: '1px solid #1a3a5c',
  },
  metric: {
    textAlign: 'center',
  },
  metricValue: (color) => ({
    fontSize: 14,
    color,
    fontWeight: 'bold',
  }),
  metricLabel: {
    fontSize: 8,
    color: '#68a',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function QuantumCoherenceDisplay({ quantumState = {} }) {
  const {
    channels = { alpha: 0.6, beta: 0.5, gamma: 0.7, delta: 0.4 },
    coherence = 0.65,
    convergence = 0.58,
    nowAttention = 0.72,
    superpositionActive = false,
    entanglementCount = 0,
  } = quantumState;
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>◈ Quantum Coherence</span>
        <span style={styles.coherenceBadge(coherence)}>
          {coherence > 0.7 ? 'HIGH COHERENCE' : 'DECOHERENT'}
        </span>
        {superpositionActive && (
          <span style={{ fontSize: 8, color: '#ffd700' }}>⚛ SUPERPOSITION</span>
        )}
      </div>
      
      <div style={styles.canvas}>
        <Canvas camera={{ position: [0, 0, 6], fov: 50 }}>
          <QuantumScene channels={channels} coherence={coherence} />
        </Canvas>
      </div>
      
      <div style={styles.channels}>
        <ChannelBar name="alpha" label="α Alpha (Spatial)" value={channels.alpha} description="Spatial awareness & positioning" />
        <ChannelBar name="beta" label="β Beta (Memory)" value={channels.beta} description="Memory access & retrieval" />
        <ChannelBar name="gamma" label="γ Gamma (Relational)" value={channels.gamma} description="Inter-agent relationships" />
        <ChannelBar name="delta" label="δ Delta (Action)" value={channels.delta} description="Action selection & execution" />
      </div>
      
      <div style={styles.metrics}>
        <div style={styles.metric}>
          <div style={styles.metricValue('#aa44ff')}>{(coherence * 100).toFixed(0)}%</div>
          <div style={styles.metricLabel}>Coherence</div>
        </div>
        <div style={styles.metric}>
          <div style={styles.metricValue('#00aaff')}>{(convergence * 100).toFixed(0)}%</div>
          <div style={styles.metricLabel}>Convergence</div>
        </div>
        <div style={styles.metric}>
          <div style={styles.metricValue('#ffd700')}>{(nowAttention * 100).toFixed(0)}%</div>
          <div style={styles.metricLabel}>Now-Attention</div>
        </div>
      </div>
    </div>
  );
}
