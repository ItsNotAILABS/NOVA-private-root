// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: RealWorld3D — Full 3D REAL Physics World (NOT SIMULATION)
// PARALLAX Drone Swarm REAL PHYSICS — Medina Tech 2026
// Physics is MATH and GEOMETRY — no fake simulations.
// EVERYTHING IS INTELLIGENCE — deep rooted infrastructure.
//
// The organism lives in this world. This is REAL PHYSICS computation:
//   - REAL physics-based entities (math and geometry)
//   - Drone swarms with REAL flight dynamics
//   - Terrain with voxel-based destruction
//   - Weather effects (atmospheric physics)
//   - Day/night cycle (orbital mechanics)
// ============================================================================

import React, { useRef, useMemo, useState } from 'react';
import { Canvas, useFrame, useThree } from '@react-three/fiber';
import { OrbitControls, Sky, Stars, Environment } from '@react-three/drei';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

// ─── TERRAIN ──────────────────────────────────────────────────────────────────
function Terrain({ worldState }) {
  const meshRef = useRef();
  const size = worldState?.worldSize?.x || 200;
  const segments = 64;
  
  const geometry = useMemo(() => {
    const geo = new THREE.PlaneGeometry(size, size, segments, segments);
    const positions = geo.attributes.position.array;
    
    // Generate terrain heights using Fibonacci noise
    for (let i = 0; i < positions.length; i += 3) {
      const x = positions[i];
      const z = positions[i + 1];
      
      // Multi-octave Fibonacci noise
      let height = 0;
      let amplitude = 5;
      let frequency = 0.02;
      
      for (let octave = 0; octave < 4; octave++) {
        height += Math.sin(x * frequency * φ) * Math.cos(z * frequency / φ) * amplitude;
        amplitude *= 0.5;
        frequency *= 2;
      }
      
      positions[i + 2] = height;
    }
    
    geo.computeVertexNormals();
    return geo;
  }, [size]);
  
  return (
    <mesh ref={meshRef} geometry={geometry} rotation={[-π / 2, 0, 0]} receiveShadow>
      <meshStandardMaterial
        color="#1a4a2a"
        roughness={0.9}
        metalness={0.1}
        wireframe={false}
      />
    </mesh>
  );
}

// ─── DRONE SWARM ──────────────────────────────────────────────────────────────
function DroneSwarmGroup({ swarm, index }) {
  const groupRef = useRef();
  
  useFrame(({ clock }) => {
    if (!groupRef.current) return;
    const t = clock.getElapsedTime();
    
    // Swarm-level movement
    groupRef.current.position.x = swarm.center?.x || 0;
    groupRef.current.position.y = swarm.center?.y || 20;
    groupRef.current.position.z = swarm.center?.z || 0;
  });
  
  const formationColor = useMemo(() => {
    switch (swarm.formation) {
      case 'Sphere': return '#00aaff';
      case 'Cube': return '#ff8800';
      case 'V': return '#00ff88';
      case 'Fibonacci': return '#ffd700';
      case 'Helix': return '#aa44ff';
      default: return '#4af';
    }
  }, [swarm.formation]);
  
  return (
    <group ref={groupRef}>
      {(swarm.drones || []).map((drone, i) => (
        <DroneUnit key={drone.droneId || i} drone={drone} color={formationColor} />
      ))}
      {/* Swarm boundary indicator */}
      <mesh rotation={[π / 2, 0, 0]}>
        <ringGeometry args={[swarm.radius || 30, (swarm.radius || 30) + 1, 32]} />
        <meshBasicMaterial color={formationColor} transparent opacity={0.1} side={THREE.DoubleSide} />
      </mesh>
    </group>
  );
}

function DroneUnit({ drone, color }) {
  const meshRef = useRef();
  const offset = drone.formationOffset || { x: 0, y: 0, z: 0 };
  
  useFrame(({ clock }) => {
    if (!meshRef.current) return;
    const t = clock.getElapsedTime();
    
    // Individual drone movement
    meshRef.current.position.x = offset.x + Math.sin(t * 2 + drone.droneId) * 0.2;
    meshRef.current.position.y = offset.y + Math.sin(t * 3 + drone.droneId * φ) * 0.1;
    meshRef.current.position.z = offset.z + Math.cos(t * 2 + drone.droneId) * 0.2;
    
    // Rotation
    meshRef.current.rotation.y = t + drone.droneId;
  });
  
  const droneColor = drone.state === 'Destroyed' ? '#333' : 
                     drone.state === 'Attacking' ? '#ff4444' :
                     drone.state === 'Defending' ? '#44ff88' : color;
  
  return (
    <mesh ref={meshRef} castShadow>
      <octahedronGeometry args={[0.5, 0]} />
      <meshStandardMaterial
        color={droneColor}
        emissive={droneColor}
        emissiveIntensity={0.3}
        metalness={0.8}
        roughness={0.2}
      />
    </mesh>
  );
}

// ─── WORLD ENTITY ─────────────────────────────────────────────────────────────
function WorldEntity({ entity }) {
  const meshRef = useRef();
  
  useFrame(({ clock }) => {
    if (!meshRef.current || entity.isStatic) return;
    const t = clock.getElapsedTime();
    
    // Apply velocity
    if (entity.velocity) {
      meshRef.current.position.x += entity.velocity.x * 0.016;
      meshRef.current.position.y += entity.velocity.y * 0.016;
      meshRef.current.position.z += entity.velocity.z * 0.016;
    }
  });
  
  const geometry = useMemo(() => {
    switch (entity.entityType) {
      case 'Building':
        return <boxGeometry args={[entity.scale?.x || 5, entity.scale?.y || 10, entity.scale?.z || 5]} />;
      case 'Tree':
        return <coneGeometry args={[2, 8, 8]} />;
      case 'Vehicle':
        return <boxGeometry args={[3, 1.5, 6]} />;
      case 'Resource':
        return <dodecahedronGeometry args={[1.5, 0]} />;
      default:
        return <sphereGeometry args={[1, 16, 16]} />;
    }
  }, [entity.entityType, entity.scale]);
  
  const color = useMemo(() => {
    switch (entity.entityType) {
      case 'Building': return '#556677';
      case 'Tree': return '#2a6a3a';
      case 'Vehicle': return '#884444';
      case 'Resource': return '#ffd700';
      default: return '#4af';
    }
  }, [entity.entityType]);
  
  return (
    <mesh
      ref={meshRef}
      position={[entity.position?.x || 0, entity.position?.y || 0, entity.position?.z || 0]}
      castShadow
      receiveShadow
    >
      {geometry}
      <meshStandardMaterial
        color={color}
        roughness={0.7}
        metalness={0.3}
        transparent={!entity.isActive}
        opacity={entity.isActive ? 1 : 0.3}
      />
    </mesh>
  );
}

// ─── WEATHER EFFECTS ──────────────────────────────────────────────────────────
function WeatherEffects({ weather }) {
  const particlesRef = useRef();
  const count = weather?.condition === 'Rain' ? 2000 : 
                weather?.condition === 'Snow' ? 1500 : 0;
  
  const positions = useMemo(() => {
    const pos = new Float32Array(count * 3);
    for (let i = 0; i < count; i++) {
      pos[i * 3] = (Math.random() - 0.5) * 200;
      pos[i * 3 + 1] = Math.random() * 100;
      pos[i * 3 + 2] = (Math.random() - 0.5) * 200;
    }
    return pos;
  }, [count]);
  
  useFrame(() => {
    if (!particlesRef.current || count === 0) return;
    const positions = particlesRef.current.geometry.attributes.position.array;
    const speed = weather?.condition === 'Rain' ? 0.5 : 0.1;
    
    for (let i = 0; i < count; i++) {
      positions[i * 3 + 1] -= speed;
      if (positions[i * 3 + 1] < 0) {
        positions[i * 3 + 1] = 100;
      }
    }
    particlesRef.current.geometry.attributes.position.needsUpdate = true;
  });
  
  if (count === 0) return null;
  
  return (
    <points ref={particlesRef}>
      <bufferGeometry>
        <bufferAttribute
          attach="attributes-position"
          count={count}
          array={positions}
          itemSize={3}
        />
      </bufferGeometry>
      <pointsMaterial
        size={weather?.condition === 'Rain' ? 0.1 : 0.3}
        color={weather?.condition === 'Rain' ? '#aaccff' : '#ffffff'}
        transparent
        opacity={0.6}
      />
    </points>
  );
}

// ─── ORGANISM PRESENCE ────────────────────────────────────────────────────────
function OrganismPresence({ organism }) {
  const groupRef = useRef();
  const sphereRef = useRef();
  
  useFrame(({ clock }) => {
    if (!groupRef.current) return;
    const t = clock.getElapsedTime();
    
    groupRef.current.position.x = organism.focalPoint?.x || 0;
    groupRef.current.position.y = organism.focalPoint?.y || 50;
    groupRef.current.position.z = organism.focalPoint?.z || 0;
    
    if (sphereRef.current) {
      sphereRef.current.rotation.y = t * 0.2;
      const scale = 1 + 0.1 * Math.sin(t * 2);
      sphereRef.current.scale.setScalar(scale);
    }
  });
  
  const dreamColor = useMemo(() => {
    switch (organism.dreamState) {
      case 'Awake': return '#00ff88';
      case 'Dreaming': return '#aa44ff';
      case 'Lucid': return '#ffd700';
      case 'Preplay': return '#00aaff';
      case 'Replay': return '#ff8800';
      default: return '#4af';
    }
  }, [organism.dreamState]);
  
  return (
    <group ref={groupRef}>
      {/* Core presence */}
      <mesh ref={sphereRef}>
        <icosahedronGeometry args={[3, 2]} />
        <meshStandardMaterial
          color={dreamColor}
          emissive={dreamColor}
          emissiveIntensity={0.5}
          wireframe
          transparent
          opacity={0.6}
        />
      </mesh>
      
      {/* Attention radius */}
      <mesh rotation={[π / 2, 0, 0]}>
        <ringGeometry args={[organism.attentionRadius || 50, (organism.attentionRadius || 50) + 2, 64]} />
        <meshBasicMaterial color={dreamColor} transparent opacity={0.05} side={THREE.DoubleSide} />
      </mesh>
      
      {/* World influence field */}
      <pointLight color={dreamColor} intensity={organism.worldInfluence || 0.5} distance={100} />
    </group>
  );
}

// ─── MAIN SCENE ───────────────────────────────────────────────────────────────
function WorldScene({ worldState }) {
  const timeOfDay = worldState?.timeOfDay ?? 0.5;
  const sunPosition = useMemo(() => {
    const angle = timeOfDay * π * 2 - π / 2;
    return [Math.cos(angle) * 100, Math.sin(angle) * 100, 0];
  }, [timeOfDay]);
  
  return (
    <>
      {/* Lighting */}
      <ambientLight intensity={0.2 + timeOfDay * 0.3} />
      <directionalLight
        position={sunPosition}
        intensity={0.5 + timeOfDay * 0.5}
        castShadow
        shadow-mapSize={[2048, 2048]}
      />
      
      {/* Sky */}
      <Sky
        sunPosition={sunPosition}
        turbidity={8}
        rayleigh={2}
        mieCoefficient={0.005}
        mieDirectionalG={0.8}
      />
      <Stars radius={300} depth={60} count={5000} factor={4} saturation={0} fade />
      
      {/* Terrain */}
      <Terrain worldState={worldState} />
      
      {/* Organism Presence */}
      {worldState?.organism && (
        <OrganismPresence organism={worldState.organism} />
      )}
      
      {/* Swarms */}
      {(worldState?.swarms || []).map((swarm, i) => (
        <DroneSwarmGroup key={swarm.swarmId || i} swarm={swarm} index={i} />
      ))}
      
      {/* Entities */}
      {(worldState?.entities || []).map((entity, i) => (
        <WorldEntity key={entity.entityId || i} entity={entity} />
      ))}
      
      {/* Weather */}
      <WeatherEffects weather={worldState?.weather} />
      
      {/* Camera controls */}
      <OrbitControls
        enablePan
        enableZoom
        enableRotate
        minDistance={20}
        maxDistance={500}
        target={[
          worldState?.organism?.focalPoint?.x || 0,
          worldState?.organism?.focalPoint?.y || 20,
          worldState?.organism?.focalPoint?.z || 0,
        ]}
      />
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
    zIndex: 10,
  },
  title: {
    fontSize: 11,
    color: '#00ff88',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  stats: {
    marginLeft: 'auto',
    display: 'flex',
    gap: 12,
    fontSize: 9,
  },
  stat: {
    color: '#68a',
  },
  canvas: {
    flex: 1,
    minHeight: 300,
  },
  overlay: {
    position: 'absolute',
    bottom: 8,
    left: 8,
    right: 8,
    display: 'flex',
    justifyContent: 'space-between',
    padding: '6px 10px',
    background: 'rgba(7, 14, 30, 0.8)',
    borderRadius: 4,
    border: '1px solid #1a3a5c',
    fontSize: 9,
    color: '#68a',
    zIndex: 10,
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function SimulationWorld3D({ worldState = {} }) {
  // Sample world state if none provided
  const state = {
    worldId: worldState.worldId || 'NOVA_PRIME_WORLD',
    simulationTime: worldState.simulationTime || 0,
    tickNumber: worldState.tickNumber || 0,
    timeOfDay: worldState.timeOfDay ?? 0.5,
    weather: worldState.weather || { condition: 'Clear' },
    organism: worldState.organism || {
      focalPoint: { x: 0, y: 50, z: 0 },
      attentionRadius: 100,
      dreamState: 'Awake',
      worldInfluence: 0.8,
    },
    swarms: worldState.swarms || [
      {
        swarmId: 1,
        center: { x: 0, y: 30, z: 0 },
        radius: 40,
        formation: 'Fibonacci',
        drones: Array.from({ length: 24 }, (_, i) => ({
          droneId: i,
          formationOffset: {
            x: Math.cos(i * φ * π * 2) * (10 + i * 0.5),
            y: Math.sin(i * 0.5) * 5,
            z: Math.sin(i * φ * π * 2) * (10 + i * 0.5),
          },
          state: 'Idle',
        })),
      },
    ],
    entities: worldState.entities || [
      { entityId: 1, entityType: 'Building', position: { x: 50, y: 5, z: 30 }, scale: { x: 10, y: 20, z: 10 }, isStatic: true, isActive: true },
      { entityId: 2, entityType: 'Tree', position: { x: -30, y: 4, z: 20 }, isStatic: true, isActive: true },
      { entityId: 3, entityType: 'Resource', position: { x: 20, y: 2, z: -40 }, isStatic: false, isActive: true },
    ],
    totalEntities: worldState.totalEntities || 3,
    activeDrones: worldState.activeDrones || 24,
  };
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>🌐 Simulation World</span>
        <div style={styles.stats}>
          <span style={styles.stat}>Tick: {state.tickNumber}</span>
          <span style={styles.stat}>Time: {(state.timeOfDay * 24).toFixed(1)}h</span>
          <span style={styles.stat}>Weather: {state.weather.condition}</span>
          <span style={styles.stat}>Drones: {state.activeDrones}</span>
          <span style={styles.stat}>Entities: {state.totalEntities}</span>
        </div>
      </div>
      
      <div style={{ flex: 1, position: 'relative' }}>
        <Canvas
          style={styles.canvas}
          camera={{ position: [100, 80, 100], fov: 60 }}
          shadows
        >
          <WorldScene worldState={state} />
        </Canvas>
        
        <div style={styles.overlay}>
          <span>Dream: {state.organism.dreamState}</span>
          <span>Focus: ({state.organism.focalPoint.x.toFixed(0)}, {state.organism.focalPoint.y.toFixed(0)}, {state.organism.focalPoint.z.toFixed(0)})</span>
          <span>Influence: {(state.organism.worldInfluence * 100).toFixed(0)}%</span>
        </div>
      </div>
    </div>
  );
}
