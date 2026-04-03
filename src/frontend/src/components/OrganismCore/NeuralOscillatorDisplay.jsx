// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: NeuralOscillatorDisplay — Brain Wave Visualization
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Visualizes the organism's neural oscillations:
//   - Delta (δ) 0.5-4 Hz — Deep processing
//   - Theta (θ) 4-8 Hz — Memory, navigation
//   - Alpha (α) 8-13 Hz — Relaxed awareness
//   - Beta (β) 13-30 Hz — Active cognition
//   - Gamma (γ) 30-100 Hz — Binding, consciousness
// ============================================================================

import React, { useRef, useEffect, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

// Constants
const φ = 1.6180339887498948482;
const π = Math.PI;

const WAVE_COLORS = {
  delta: new THREE.Color(0x4400ff),   // Deep blue
  theta: new THREE.Color(0x00aaff),   // Cyan
  alpha: new THREE.Color(0x00ff88),   // Green
  beta:  new THREE.Color(0xffaa00),   // Orange
  gamma: new THREE.Color(0xff00ff),   // Magenta
};

const WAVE_BANDS = [
  { name: 'delta', label: 'δ Delta', freqRange: '0.5-4 Hz', role: 'Deep Processing' },
  { name: 'theta', label: 'θ Theta', freqRange: '4-8 Hz', role: 'Memory/Navigation' },
  { name: 'alpha', label: 'α Alpha', freqRange: '8-13 Hz', role: 'Relaxed Awareness' },
  { name: 'beta',  label: 'β Beta', freqRange: '13-30 Hz', role: 'Active Cognition' },
  { name: 'gamma', label: 'γ Gamma', freqRange: '30-100 Hz', role: 'Binding/Consciousness' },
];

// ─── WAVE LINE ────────────────────────────────────────────────────────────────
function WaveLine({ band, amplitude, frequency, phase, yOffset }) {
  const lineRef = useRef();
  const color = WAVE_COLORS[band];
  const points = 200;
  
  useFrame(({ clock }) => {
    if (!lineRef.current) return;
    const t = clock.getElapsedTime();
    const positions = lineRef.current.geometry.attributes.position;
    
    for (let i = 0; i < points; i++) {
      const x = (i / points - 0.5) * 10;
      const wave = amplitude * Math.sin(frequency * x + t * 2 + phase);
      // Add Fibonacci modulation
      const fibMod = 0.1 * Math.sin(x * φ + t * 0.5);
      positions.setY(i, yOffset + wave + fibMod);
    }
    positions.needsUpdate = true;
  });
  
  const geometry = useMemo(() => {
    const geo = new THREE.BufferGeometry();
    const positions = new Float32Array(points * 3);
    for (let i = 0; i < points; i++) {
      positions[i * 3] = (i / points - 0.5) * 10;
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

// ─── 3D OSCILLATOR SCENE ──────────────────────────────────────────────────────
function OscillatorScene({ waves }) {
  return (
    <>
      <ambientLight intensity={0.3} />
      {WAVE_BANDS.map((band, i) => (
        <WaveLine
          key={band.name}
          band={band.name}
          amplitude={waves[band.name] || 0.5}
          frequency={2 + i * 0.5}
          phase={i * π / 5}
          yOffset={(2 - i) * 1.5}
        />
      ))}
    </>
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
    color: '#4af',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  badge: (active) => ({
    fontSize: 8,
    padding: '2px 6px',
    borderRadius: 10,
    background: active ? '#003322' : '#1a1a2e',
    color: active ? '#00ff88' : '#666',
    border: active ? '1px solid #00ff88' : '1px solid #333',
  }),
  canvas: {
    flex: 1,
    minHeight: 150,
  },
  legend: {
    padding: '8px 12px',
    borderTop: '1px solid #1a3a5c',
    display: 'grid',
    gridTemplateColumns: 'repeat(5, 1fr)',
    gap: 4,
  },
  legendItem: (color) => ({
    fontSize: 8,
    color: '#adf',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    gap: 2,
  }),
  colorDot: (color) => ({
    width: 8,
    height: 8,
    borderRadius: '50%',
    background: color,
    boxShadow: `0 0 6px ${color}`,
  }),
  meter: {
    display: 'flex',
    flexDirection: 'column',
    gap: 4,
    padding: '0 12px 8px',
  },
  meterRow: {
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  meterLabel: {
    fontSize: 9,
    color: '#6af',
    width: 60,
  },
  meterBar: {
    flex: 1,
    height: 6,
    background: '#0a1a2e',
    borderRadius: 3,
    overflow: 'hidden',
  },
  meterFill: (pct, color) => ({
    height: '100%',
    width: `${pct * 100}%`,
    background: color,
    boxShadow: `0 0 4px ${color}`,
    transition: 'width 0.3s',
  }),
  meterValue: {
    fontSize: 9,
    color: '#4af',
    width: 40,
    textAlign: 'right',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function NeuralOscillatorDisplay({ organismState = {} }) {
  const {
    brainWaves = {},
    isActive = true,
    dominantBand = 'alpha',
  } = organismState;
  
  // Default wave values if not provided
  const waves = {
    delta: brainWaves.delta ?? 0.3,
    theta: brainWaves.theta ?? 0.5,
    alpha: brainWaves.alpha ?? 0.7,
    beta:  brainWaves.beta ?? 0.4,
    gamma: brainWaves.gamma ?? 0.2,
  };
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>◈ Neural Oscillator</span>
        <span style={styles.badge(isActive)}>{isActive ? 'ACTIVE' : 'DORMANT'}</span>
        <span style={{ fontSize: 9, color: '#ffd700', marginLeft: 'auto' }}>
          Dominant: {dominantBand.toUpperCase()}
        </span>
      </div>
      
      <div style={styles.canvas}>
        <Canvas camera={{ position: [0, 0, 8], fov: 50 }}>
          <OscillatorScene waves={waves} />
        </Canvas>
      </div>
      
      <div style={styles.meter}>
        {WAVE_BANDS.map(band => (
          <div key={band.name} style={styles.meterRow}>
            <span style={styles.meterLabel}>{band.label}</span>
            <div style={styles.meterBar}>
              <div style={styles.meterFill(waves[band.name], WAVE_COLORS[band.name].getStyle())} />
            </div>
            <span style={styles.meterValue}>{waves[band.name].toFixed(2)}</span>
          </div>
        ))}
      </div>
      
      <div style={styles.legend}>
        {WAVE_BANDS.map(band => (
          <div key={band.name} style={styles.legendItem()}>
            <div style={styles.colorDot(WAVE_COLORS[band.name].getStyle())} />
            <span style={{ color: WAVE_COLORS[band.name].getStyle() }}>{band.freqRange}</span>
            <span style={{ fontSize: 7, color: '#68a' }}>{band.role}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
