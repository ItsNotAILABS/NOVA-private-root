// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: BeeSwarmIntelligence — Collective Decision Making
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Full bee swarm intelligence system:
//   - Waggle dance communication
//   - Collective decision-making
//   - Scout-recruiter dynamics
//   - Threshold-based consensus
//   - Flower memory and navigation
//   - Division of labor
// ============================================================================

import React, { useState, useMemo, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

// ─── BEE ROLES ────────────────────────────────────────────────────────────────
const BEE_ROLES = {
  scout: { color: '#FFD700', icon: '🔍', description: 'Explores new sites' },
  forager: { color: '#FFA500', icon: '🌸', description: 'Collects resources' },
  nurse: { color: '#FFB6C1', icon: '👶', description: 'Cares for larvae' },
  guard: { color: '#8B4513', icon: '🛡️', description: 'Defends the hive' },
  builder: { color: '#DAA520', icon: '🏗️', description: 'Constructs comb' },
  queen: { color: '#9400D3', icon: '👑', description: 'Lays eggs' },
};

// ─── WAGGLE DANCE VISUALIZATION ───────────────────────────────────────────────
function WaggleDance({ dance, index }) {
  const groupRef = useRef();
  const trailRef = useRef();
  
  useFrame(({ clock }) => {
    if (!groupRef.current) return;
    const t = clock.getElapsedTime();
    
    // Waggle dance pattern: figure-8 with waggle run
    const phase = (t * 2 + index) % (π * 2);
    const wagglePhase = (t * 10) % (π * 2);
    
    // Figure-8 path
    const x = Math.sin(phase) * 1.5;
    const y = Math.sin(phase * 2) * 0.5;
    
    // Waggle on the straight run
    const isWaggling = Math.abs(Math.sin(phase)) > 0.7;
    const waggle = isWaggling ? Math.sin(wagglePhase) * 0.2 : 0;
    
    groupRef.current.position.x = x + waggle;
    groupRef.current.position.y = y + index * 2 - 2;
    groupRef.current.rotation.z = Math.atan2(y, x);
  });
  
  const directionColor = new THREE.Color().setHSL(dance.direction / 360, 0.8, 0.5);
  
  return (
    <group ref={groupRef}>
      {/* Bee body */}
      <mesh>
        <capsuleGeometry args={[0.15, 0.3, 8, 8]} />
        <meshStandardMaterial color="#FFD700" emissive="#FFD700" emissiveIntensity={0.3} />
      </mesh>
      {/* Direction indicator */}
      <mesh position={[0.3, 0, 0]} rotation={[0, 0, π / 2]}>
        <coneGeometry args={[0.1, 0.2, 8]} />
        <meshStandardMaterial color={directionColor} />
      </mesh>
      {/* Wings */}
      <mesh position={[0, 0.15, 0]} rotation={[0, 0, π / 4]}>
        <planeGeometry args={[0.3, 0.15]} />
        <meshBasicMaterial color="#ffffff" transparent opacity={0.5} side={THREE.DoubleSide} />
      </mesh>
    </group>
  );
}

function DanceFloor({ dances }) {
  return (
    <>
      <ambientLight intensity={0.4} />
      <pointLight position={[0, 5, 5]} intensity={0.6} color="#FFD700" />
      
      {/* Hive background */}
      <mesh rotation={[0, 0, 0]} position={[0, 0, -1]}>
        <planeGeometry args={[6, 6]} />
        <meshStandardMaterial color="#8B4513" />
      </mesh>
      
      {/* Honeycomb pattern */}
      {Array.from({ length: 25 }).map((_, i) => {
        const row = Math.floor(i / 5);
        const col = i % 5;
        const x = (col - 2) * 1.1 + (row % 2) * 0.55;
        const y = (row - 2) * 0.95;
        return (
          <mesh key={i} position={[x, y, -0.9]} rotation={[0, 0, π / 6]}>
            <cylinderGeometry args={[0.5, 0.5, 0.1, 6]} />
            <meshStandardMaterial color="#DAA520" />
          </mesh>
        );
      })}
      
      {/* Dancing bees */}
      {dances.map((dance, i) => (
        <WaggleDance key={dance.id || i} dance={dance} index={i} />
      ))}
    </>
  );
}

// ─── DANCE CARD ───────────────────────────────────────────────────────────────
function DanceCard({ dance, onSelect }) {
  const quality = dance.quality || 0.5;
  const qualityColor = quality > 0.8 ? '#00ff88' : quality > 0.5 ? '#ffaa00' : '#ff4444';
  
  return (
    <div
      onClick={() => onSelect(dance)}
      style={{
        background: '#0a1a2e',
        border: '1px solid #FFD700',
        borderRadius: 6,
        padding: 8,
        cursor: 'pointer',
        marginBottom: 6,
      }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
        <span style={{ fontSize: 10, color: '#FFD700' }}>Scout #{dance.scoutId}</span>
        <span style={{ fontSize: 9, color: qualityColor }}>
          Quality: {(quality * 100).toFixed(0)}%
        </span>
      </div>
      
      <div style={{ display: 'flex', gap: 12, fontSize: 8, color: '#68a' }}>
        <span>Direction: {dance.direction?.toFixed(0)}°</span>
        <span>Distance: {dance.distance?.toFixed(0)}m</span>
        <span>Duration: {dance.duration?.toFixed(1)}s</span>
      </div>
      
      <div style={{
        marginTop: 6,
        height: 4,
        background: '#050a14',
        borderRadius: 2,
        overflow: 'hidden',
      }}>
        <div style={{
          width: `${(dance.recruits || 0) / 10 * 100}%`,
          height: '100%',
          background: '#FFD700',
        }} />
      </div>
      <div style={{ fontSize: 7, color: '#68a', marginTop: 2 }}>
        Recruits: {dance.recruits || 0}
      </div>
    </div>
  );
}

// ─── HIVE STATE ───────────────────────────────────────────────────────────────
function HiveState({ population, roles, resources }) {
  const totalBees = Object.values(population).reduce((s, v) => s + v, 0);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #8B4513',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#FFD700', marginBottom: 8 }}>🐝 HIVE STATE</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginBottom: 12 }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 18, color: '#FFD700' }}>{totalBees}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Total Bees</div>
        </div>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 18, color: '#FFA500' }}>{resources.honey?.toFixed(0) || 0}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Honey (g)</div>
        </div>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 18, color: '#DAA520' }}>{resources.pollen?.toFixed(0) || 0}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Pollen (g)</div>
        </div>
      </div>
      
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>DIVISION OF LABOR</div>
      {Object.entries(BEE_ROLES).map(([role, data]) => (
        <div key={role} style={{ marginBottom: 4 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 8 }}>
            <span style={{ color: data.color }}>
              {data.icon} {role.charAt(0).toUpperCase() + role.slice(1)}
            </span>
            <span style={{ color: '#4af' }}>{population[role] || 0}</span>
          </div>
          <div style={{
            height: 4,
            background: '#050a14',
            borderRadius: 2,
            overflow: 'hidden',
          }}>
            <div style={{
              width: `${((population[role] || 0) / totalBees) * 100}%`,
              height: '100%',
              background: data.color,
            }} />
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── CONSENSUS METER ──────────────────────────────────────────────────────────
function ConsensusMeter({ sites, threshold }) {
  const maxVotes = Math.max(...sites.map(s => s.votes || 0), 1);
  const leader = sites.reduce((best, site) => 
    (site.votes || 0) > (best.votes || 0) ? site : best, sites[0]);
  const consensusReached = leader && (leader.votes || 0) >= threshold;
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: `1px solid ${consensusReached ? '#00ff88' : '#1a3a5c'}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
        <div style={{ fontSize: 10, color: '#6af' }}>CONSENSUS BUILDING</div>
        {consensusReached && (
          <span style={{ fontSize: 9, color: '#00ff88', fontWeight: 'bold' }}>
            ✓ DECISION REACHED
          </span>
        )}
      </div>
      
      <div style={{ fontSize: 8, color: '#68a', marginBottom: 6 }}>
        Threshold: {threshold} votes required
      </div>
      
      {sites.map((site, i) => (
        <div key={site.id || i} style={{ marginBottom: 6 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 8 }}>
            <span style={{ color: site === leader ? '#FFD700' : '#4af' }}>
              Site {site.id}: {site.name || 'Unknown'}
            </span>
            <span style={{ color: '#4af' }}>{site.votes || 0} votes</span>
          </div>
          <div style={{
            height: 8,
            background: '#050a14',
            borderRadius: 4,
            overflow: 'hidden',
            position: 'relative',
          }}>
            <div style={{
              position: 'absolute',
              left: `${(threshold / maxVotes) * 100}%`,
              top: 0,
              bottom: 0,
              width: 2,
              background: '#ff4444',
            }} />
            <div style={{
              width: `${((site.votes || 0) / maxVotes) * 100}%`,
              height: '100%',
              background: site === leader ? '#FFD700' : '#4af',
              transition: 'width 0.3s',
            }} />
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── FLOWER MAP ───────────────────────────────────────────────────────────────
function FlowerMap({ flowers, hivePosition }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #00ff88',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#00ff88', marginBottom: 8 }}>🌸 FLOWER MEMORY MAP</div>
      
      <div style={{
        height: 150,
        background: '#050a14',
        borderRadius: 6,
        position: 'relative',
        overflow: 'hidden',
      }}>
        {/* Hive */}
        <div style={{
          position: 'absolute',
          left: '50%',
          top: '50%',
          transform: 'translate(-50%, -50%)',
          width: 20,
          height: 20,
          background: '#8B4513',
          borderRadius: '50%',
          border: '2px solid #FFD700',
          zIndex: 10,
        }} />
        
        {/* Flowers */}
        {flowers.map((flower, i) => {
          const angle = flower.direction * (π / 180);
          const distance = Math.min(flower.distance / 100, 60);
          const x = 50 + Math.cos(angle) * distance;
          const y = 50 - Math.sin(angle) * distance;
          const qualityColor = flower.quality > 0.7 ? '#ff69b4' : flower.quality > 0.4 ? '#ffa500' : '#888';
          
          return (
            <div
              key={flower.id || i}
              title={`${flower.type || 'Flower'}: ${(flower.quality * 100).toFixed(0)}% quality, ${flower.distance}m`}
              style={{
                position: 'absolute',
                left: `${x}%`,
                top: `${y}%`,
                transform: 'translate(-50%, -50%)',
                fontSize: 12,
                opacity: 0.5 + flower.quality * 0.5,
              }}
            >
              🌸
            </div>
          );
        })}
        
        {/* Compass */}
        {['N', 'E', 'S', 'W'].map((dir, i) => (
          <span key={dir} style={{
            position: 'absolute',
            fontSize: 8,
            color: '#68a',
            ...(i === 0 ? { top: 4, left: '50%', transform: 'translateX(-50%)' } :
               i === 1 ? { right: 4, top: '50%', transform: 'translateY(-50%)' } :
               i === 2 ? { bottom: 4, left: '50%', transform: 'translateX(-50%)' } :
                        { left: 4, top: '50%', transform: 'translateY(-50%)' }),
          }}>
            {dir}
          </span>
        ))}
      </div>
      
      <div style={{ fontSize: 8, color: '#68a', marginTop: 6 }}>
        {flowers.length} flower patches in memory
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
    padding: '10px 12px',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  title: {
    fontSize: 12,
    color: '#FFD700',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 1fr 280px',
    gap: 10,
    padding: 10,
    overflow: 'hidden',
  },
  canvas: {
    background: '#050a14',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
  },
  panel: {
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
    overflow: 'auto',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function BeeSwarmIntelligence({ swarmState = {} }) {
  const [selectedDance, setSelectedDance] = useState(null);
  
  // Sample state if none provided
  const state = {
    population: swarmState.population || {
      scout: 50,
      forager: 300,
      nurse: 100,
      guard: 30,
      builder: 40,
      queen: 1,
    },
    resources: swarmState.resources || {
      honey: 2500,
      pollen: 800,
      nectar: 1200,
    },
    dances: swarmState.dances || [
      { id: 1, scoutId: 7, direction: 45, distance: 150, duration: 2.3, quality: 0.85, recruits: 8 },
      { id: 2, scoutId: 12, direction: 180, distance: 300, duration: 4.1, quality: 0.62, recruits: 4 },
      { id: 3, scoutId: 23, direction: 270, distance: 80, duration: 1.2, quality: 0.91, recruits: 12 },
    ],
    sites: swarmState.sites || [
      { id: 1, name: 'Meadow A', votes: 15, quality: 0.85 },
      { id: 2, name: 'Garden B', votes: 8, quality: 0.65 },
      { id: 3, name: 'Forest C', votes: 22, quality: 0.92 },
    ],
    flowers: swarmState.flowers || [
      { id: 1, type: 'Lavender', direction: 45, distance: 150, quality: 0.85 },
      { id: 2, type: 'Sunflower', direction: 180, distance: 300, quality: 0.62 },
      { id: 3, type: 'Clover', direction: 270, distance: 80, quality: 0.91 },
      { id: 4, type: 'Rose', direction: 120, distance: 200, quality: 0.75 },
      { id: 5, type: 'Wildflower', direction: 330, distance: 250, quality: 0.55 },
    ],
    consensusThreshold: swarmState.consensusThreshold || 20,
  };
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>🐝 Bee Swarm Intelligence</span>
        <span style={{ fontSize: 9, color: '#68a' }}>
          {state.dances.length} active dances
        </span>
      </div>
      
      <div style={styles.content}>
        <div style={styles.canvas}>
          <Canvas camera={{ position: [0, 0, 5], fov: 50 }}>
            <DanceFloor dances={state.dances} />
          </Canvas>
        </div>
        
        <div style={styles.panel}>
          <div style={{ fontSize: 10, color: '#FFD700', marginBottom: 4 }}>WAGGLE DANCES</div>
          {state.dances.map(dance => (
            <DanceCard key={dance.id} dance={dance} onSelect={setSelectedDance} />
          ))}
          
          <ConsensusMeter sites={state.sites} threshold={state.consensusThreshold} />
        </div>
        
        <div style={styles.panel}>
          <HiveState
            population={state.population}
            roles={BEE_ROLES}
            resources={state.resources}
          />
          
          <FlowerMap flowers={state.flowers} />
        </div>
      </div>
    </div>
  );
}
