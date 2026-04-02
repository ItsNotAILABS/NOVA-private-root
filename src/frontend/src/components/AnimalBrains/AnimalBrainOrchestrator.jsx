// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: AnimalBrainOrchestrator — Multi-Species Neural Integration
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// The organism incorporates intelligence from multiple species:
//   - Bee: Swarm intelligence, waggle dance, collective decision-making
//   - Crow: Tool use, causal reasoning, future planning
//   - Elephant: Long-term memory, social bonds, spatial navigation
//   - Octopus: Distributed cognition, camouflage, problem-solving
//   - Dolphin: Echolocation, social communication, self-awareness
//   - Owl: Auditory processing, night vision, silent flight
//   - Spider: Web construction, vibration sensing, patience
//   - Mantis Shrimp: Hyperspectral vision, fast strikes
//   - Salmon: Navigation, magnetic field sensing, homing
//   - Wolf: Pack coordination, hunting strategy, territory
//   - Cat: Visual cortex, reflexes, predator instincts
//   - Ant: Colony optimization, pheromone trails, division of labor
// ============================================================================

import React, { useState, useMemo, useRef, useEffect } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

// ─── ANIMAL BRAIN DEFINITIONS ─────────────────────────────────────────────────
const ANIMAL_BRAINS = {
  bee: {
    name: 'Bee',
    icon: '🐝',
    color: '#FFD700',
    specialization: 'Swarm Intelligence',
    traits: ['Waggle Dance', 'Collective Decision', 'Flower Memory', 'Dance Language'],
    neuronCount: 960000,
    brainMass: 0.001, // grams
    capabilities: {
      navigation: 0.95,
      communication: 0.90,
      memory: 0.70,
      learning: 0.80,
      coordination: 0.98,
    },
  },
  crow: {
    name: 'Crow',
    icon: '🐦‍⬛',
    color: '#2F2F2F',
    specialization: 'Causal Reasoning',
    traits: ['Tool Use', 'Future Planning', 'Face Recognition', 'Problem Solving'],
    neuronCount: 1500000000,
    brainMass: 10,
    capabilities: {
      reasoning: 0.95,
      toolUse: 0.90,
      memory: 0.85,
      planning: 0.88,
      learning: 0.92,
    },
  },
  elephant: {
    name: 'Elephant',
    icon: '🐘',
    color: '#808080',
    specialization: 'Long-Term Memory',
    traits: ['Episodic Memory', 'Social Bonds', 'Spatial Navigation', 'Mourning'],
    neuronCount: 257000000000,
    brainMass: 4700,
    capabilities: {
      memory: 0.98,
      social: 0.95,
      navigation: 0.90,
      empathy: 0.92,
      communication: 0.85,
    },
  },
  octopus: {
    name: 'Octopus',
    icon: '🐙',
    color: '#FF6B6B',
    specialization: 'Distributed Cognition',
    traits: ['Arm Independence', 'Camouflage', 'Escape Artist', 'Tool Use'],
    neuronCount: 500000000,
    brainMass: 0.5,
    capabilities: {
      problemSolving: 0.95,
      camouflage: 0.98,
      manipulation: 0.92,
      learning: 0.88,
      autonomy: 0.90,
    },
  },
  dolphin: {
    name: 'Dolphin',
    icon: '🐬',
    color: '#4169E1',
    specialization: 'Echolocation',
    traits: ['Sonar', 'Self-Awareness', 'Social Bonds', 'Play Behavior'],
    neuronCount: 5800000000,
    brainMass: 1500,
    capabilities: {
      echolocation: 0.98,
      social: 0.95,
      communication: 0.92,
      selfAwareness: 0.90,
      cooperation: 0.93,
    },
  },
  owl: {
    name: 'Owl',
    icon: '🦉',
    color: '#8B4513',
    specialization: 'Auditory Processing',
    traits: ['Sound Localization', 'Night Vision', 'Silent Flight', 'Head Rotation'],
    neuronCount: 300000000,
    brainMass: 8,
    capabilities: {
      hearing: 0.98,
      vision: 0.92,
      stealth: 0.95,
      hunting: 0.90,
      spatial: 0.88,
    },
  },
  spider: {
    name: 'Spider',
    icon: '🕷️',
    color: '#1C1C1C',
    specialization: 'Web Construction',
    traits: ['Vibration Sensing', 'Pattern Recognition', 'Patience', 'Precision'],
    neuronCount: 100000,
    brainMass: 0.0001,
    capabilities: {
      webBuilding: 0.98,
      vibrationSense: 0.95,
      patience: 0.90,
      precision: 0.92,
      trapDesign: 0.88,
    },
  },
  mantisShrimp: {
    name: 'Mantis Shrimp',
    icon: '🦐',
    color: '#FF1493',
    specialization: 'Hyperspectral Vision',
    traits: ['16 Color Receptors', 'UV/Polarized Light', 'Fast Strikes', 'Depth Perception'],
    neuronCount: 50000000,
    brainMass: 0.1,
    capabilities: {
      vision: 0.99,
      speed: 0.98,
      colorDetection: 0.99,
      striking: 0.95,
      depthPerception: 0.90,
    },
  },
  salmon: {
    name: 'Salmon',
    icon: '🐟',
    color: '#FA8072',
    specialization: 'Navigation',
    traits: ['Magnetic Sensing', 'Olfactory Homing', 'Current Riding', 'Endurance'],
    neuronCount: 10000000,
    brainMass: 0.5,
    capabilities: {
      navigation: 0.98,
      magneticSense: 0.95,
      olfactory: 0.92,
      endurance: 0.90,
      homing: 0.97,
    },
  },
  wolf: {
    name: 'Wolf',
    icon: '🐺',
    color: '#696969',
    specialization: 'Pack Coordination',
    traits: ['Pack Hunting', 'Territory Defense', 'Hierarchy', 'Communication'],
    neuronCount: 160000000,
    brainMass: 130,
    capabilities: {
      packHunting: 0.95,
      territory: 0.92,
      communication: 0.90,
      strategy: 0.88,
      endurance: 0.85,
    },
  },
  cat: {
    name: 'Cat',
    icon: '🐱',
    color: '#FFA500',
    specialization: 'Visual Cortex',
    traits: ['Night Vision', 'Reflexes', 'Balance', 'Predator Instincts'],
    neuronCount: 760000000,
    brainMass: 30,
    capabilities: {
      vision: 0.95,
      reflexes: 0.98,
      balance: 0.97,
      hunting: 0.90,
      agility: 0.95,
    },
  },
  ant: {
    name: 'Ant',
    icon: '🐜',
    color: '#8B0000',
    specialization: 'Colony Optimization',
    traits: ['Pheromone Trails', 'Division of Labor', 'Load Carrying', 'Tunnel Building'],
    neuronCount: 250000,
    brainMass: 0.0001,
    capabilities: {
      pathOptimization: 0.98,
      cooperation: 0.99,
      strength: 0.95,
      construction: 0.92,
      communication: 0.90,
    },
  },
};

// ─── BRAIN VISUALIZATION 3D ───────────────────────────────────────────────────
function BrainNeuronCloud({ animal, activation }) {
  const pointsRef = useRef();
  const count = 500;
  const color = new THREE.Color(ANIMAL_BRAINS[animal]?.color || '#4af');
  
  const [positions, colors] = useMemo(() => {
    const pos = new Float32Array(count * 3);
    const col = new Float32Array(count * 3);
    
    for (let i = 0; i < count; i++) {
      // Brain-shaped distribution
      const theta = Math.random() * π * 2;
      const phi = Math.acos(2 * Math.random() - 1);
      const r = 2 * (0.5 + 0.5 * Math.random());
      
      pos[i * 3] = r * Math.sin(phi) * Math.cos(theta);
      pos[i * 3 + 1] = r * Math.sin(phi) * Math.sin(theta) * 0.8; // Flatten slightly
      pos[i * 3 + 2] = r * Math.cos(phi);
      
      col[i * 3] = color.r;
      col[i * 3 + 1] = color.g;
      col[i * 3 + 2] = color.b;
    }
    return [pos, col];
  }, [animal]);
  
  useFrame(({ clock }) => {
    if (!pointsRef.current) return;
    const t = clock.getElapsedTime();
    const positions = pointsRef.current.geometry.attributes.position.array;
    
    for (let i = 0; i < count; i++) {
      const idx = i * 3;
      // Pulsing effect based on activation
      const pulse = 1 + 0.1 * Math.sin(t * 3 + i * 0.1) * activation;
      positions[idx] *= 0.999 + 0.001 * pulse;
      positions[idx + 1] *= 0.999 + 0.001 * pulse;
      positions[idx + 2] *= 0.999 + 0.001 * pulse;
    }
    pointsRef.current.geometry.attributes.position.needsUpdate = true;
    pointsRef.current.rotation.y = t * 0.1;
  });
  
  return (
    <points ref={pointsRef}>
      <bufferGeometry>
        <bufferAttribute attach="attributes-position" count={count} array={positions} itemSize={3} />
        <bufferAttribute attach="attributes-color" count={count} array={colors} itemSize={3} />
      </bufferGeometry>
      <pointsMaterial size={0.05} vertexColors transparent opacity={0.8} />
    </points>
  );
}

function BrainScene({ activeAnimal, activation }) {
  return (
    <>
      <ambientLight intensity={0.3} />
      <pointLight position={[5, 5, 5]} intensity={0.5} />
      <BrainNeuronCloud animal={activeAnimal} activation={activation} />
    </>
  );
}

// ─── CAPABILITY BAR ───────────────────────────────────────────────────────────
function CapabilityBar({ name, value, color }) {
  return (
    <div style={{ marginBottom: 4 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
        <span style={{ fontSize: 8, color: '#68a', textTransform: 'capitalize' }}>{name}</span>
        <span style={{ fontSize: 8, color }}>{(value * 100).toFixed(0)}%</span>
      </div>
      <div style={{
        height: 4,
        background: '#0a1a2e',
        borderRadius: 2,
        overflow: 'hidden',
      }}>
        <div style={{
          width: `${value * 100}%`,
          height: '100%',
          background: color,
          transition: 'width 0.3s',
        }} />
      </div>
    </div>
  );
}

// ─── ANIMAL BRAIN CARD ────────────────────────────────────────────────────────
function AnimalBrainCard({ animal, data, active, activation, onSelect }) {
  return (
    <div
      onClick={() => onSelect(animal)}
      style={{
        background: active ? '#1a2a4e' : '#0a1a2e',
        border: `2px solid ${active ? data.color : '#1a3a5c'}`,
        borderRadius: 8,
        padding: 10,
        cursor: 'pointer',
        transition: 'all 0.2s',
        boxShadow: active ? `0 0 15px ${data.color}44` : 'none',
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
        <span style={{ fontSize: 24 }}>{data.icon}</span>
        <div>
          <div style={{ fontSize: 11, color: data.color, fontWeight: 'bold' }}>{data.name}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>{data.specialization}</div>
        </div>
        {active && (
          <div style={{
            marginLeft: 'auto',
            fontSize: 10,
            padding: '2px 6px',
            borderRadius: 8,
            background: `${data.color}22`,
            color: data.color,
          }}>
            {(activation * 100).toFixed(0)}%
          </div>
        )}
      </div>
      
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4, marginBottom: 6 }}>
        {data.traits.map(trait => (
          <span key={trait} style={{
            fontSize: 7,
            padding: '1px 4px',
            borderRadius: 4,
            background: '#0a0a1e',
            color: '#68a',
            border: '1px solid #1a3a5c',
          }}>
            {trait}
          </span>
        ))}
      </div>
      
      <div style={{ fontSize: 7, color: '#68a' }}>
        Neurons: {data.neuronCount.toLocaleString()} | Mass: {data.brainMass}g
      </div>
    </div>
  );
}

// ─── ANIMAL BRAIN DETAIL ──────────────────────────────────────────────────────
function AnimalBrainDetail({ animal, data, activation }) {
  if (!data) return null;
  
  return (
    <div style={{
      background: '#050a14',
      border: `1px solid ${data.color}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12 }}>
        <span style={{ fontSize: 40 }}>{data.icon}</span>
        <div>
          <div style={{ fontSize: 16, color: data.color, fontWeight: 'bold' }}>{data.name} Brain</div>
          <div style={{ fontSize: 10, color: '#68a' }}>{data.specialization}</div>
          <div style={{ fontSize: 9, color: '#4af' }}>
            {data.neuronCount.toLocaleString()} neurons • {data.brainMass}g
          </div>
        </div>
        <div style={{
          marginLeft: 'auto',
          fontSize: 24,
          color: data.color,
          fontWeight: 'bold',
        }}>
          {(activation * 100).toFixed(0)}%
        </div>
      </div>
      
      <div style={{ marginBottom: 12 }}>
        <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>CAPABILITIES</div>
        {Object.entries(data.capabilities).map(([name, value]) => (
          <CapabilityBar key={name} name={name} value={value * activation} color={data.color} />
        ))}
      </div>
      
      <div>
        <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>TRAITS</div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
          {data.traits.map(trait => (
            <span key={trait} style={{
              fontSize: 9,
              padding: '3px 8px',
              borderRadius: 6,
              background: `${data.color}22`,
              color: data.color,
              border: `1px solid ${data.color}`,
            }}>
              {trait}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

// ─── INTEGRATION MATRIX ───────────────────────────────────────────────────────
function IntegrationMatrix({ activations }) {
  const animals = Object.keys(ANIMAL_BRAINS);
  
  return (
    <div style={{
      background: '#050a14',
      border: '1px solid #1a3a5c',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 8 }}>NEURAL INTEGRATION MATRIX</div>
      <div style={{
        display: 'grid',
        gridTemplateColumns: `repeat(${animals.length}, 1fr)`,
        gap: 2,
      }}>
        {animals.map(row => (
          animals.map(col => {
            const rowAct = activations[row] || 0;
            const colAct = activations[col] || 0;
            const integration = rowAct * colAct;
            const rowColor = new THREE.Color(ANIMAL_BRAINS[row].color);
            const colColor = new THREE.Color(ANIMAL_BRAINS[col].color);
            const mixedColor = new THREE.Color().lerpColors(rowColor, colColor, 0.5);
            
            return (
              <div
                key={`${row}-${col}`}
                title={`${ANIMAL_BRAINS[row].name} ↔ ${ANIMAL_BRAINS[col].name}: ${(integration * 100).toFixed(0)}%`}
                style={{
                  width: '100%',
                  aspectRatio: '1',
                  background: integration > 0.1 ? mixedColor.getStyle() : '#0a1a2e',
                  opacity: 0.3 + integration * 0.7,
                  borderRadius: 2,
                }}
              />
            );
          })
        ))}
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 6, fontSize: 7, color: '#68a' }}>
        {animals.slice(0, 6).map(a => (
          <span key={a}>{ANIMAL_BRAINS[a].icon}</span>
        ))}
      </div>
    </div>
  );
}

// ─── COLLECTIVE OUTPUT ────────────────────────────────────────────────────────
function CollectiveOutput({ activations }) {
  const totalActivation = Object.values(activations).reduce((s, v) => s + v, 0) / Object.keys(activations).length;
  
  // Calculate collective capabilities
  const collectiveCapabilities = {};
  const allCapabilities = new Set();
  
  Object.entries(ANIMAL_BRAINS).forEach(([animal, data]) => {
    Object.keys(data.capabilities).forEach(cap => allCapabilities.add(cap));
  });
  
  allCapabilities.forEach(cap => {
    let total = 0;
    let count = 0;
    Object.entries(ANIMAL_BRAINS).forEach(([animal, data]) => {
      if (data.capabilities[cap]) {
        total += data.capabilities[cap] * (activations[animal] || 0);
        count++;
      }
    });
    collectiveCapabilities[cap] = count > 0 ? total / count : 0;
  });
  
  // Sort by value
  const sortedCapabilities = Object.entries(collectiveCapabilities)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 8);
  
  return (
    <div style={{
      background: '#050a14',
      border: '1px solid #ffd700',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
        <div style={{ fontSize: 9, color: '#ffd700' }}>COLLECTIVE INTELLIGENCE</div>
        <div style={{ fontSize: 14, color: '#ffd700', fontWeight: 'bold' }}>
          {(totalActivation * 100).toFixed(0)}%
        </div>
      </div>
      
      {sortedCapabilities.map(([cap, value]) => (
        <CapabilityBar key={cap} name={cap} value={value} color="#ffd700" />
      ))}
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
    color: '#ffd700',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 300px',
    gap: 10,
    padding: 10,
    overflow: 'hidden',
  },
  leftPanel: {
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
    overflow: 'auto',
  },
  brainGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(3, 1fr)',
    gap: 8,
  },
  rightPanel: {
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
    overflow: 'auto',
  },
  canvas: {
    height: 200,
    background: '#050a14',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function AnimalBrainOrchestrator({ orchestratorState = {} }) {
  const [activeAnimal, setActiveAnimal] = useState('bee');
  
  // Sample activations if none provided
  const activations = orchestratorState.activations || {
    bee: 0.85,
    crow: 0.72,
    elephant: 0.68,
    octopus: 0.55,
    dolphin: 0.78,
    owl: 0.45,
    spider: 0.30,
    mantisShrimp: 0.40,
    salmon: 0.50,
    wolf: 0.65,
    cat: 0.58,
    ant: 0.90,
  };
  
  const activeData = ANIMAL_BRAINS[activeAnimal];
  const activeActivation = activations[activeAnimal] || 0;
  const totalActive = Object.values(activations).filter(v => v > 0.3).length;
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>🧠 Animal Brain Orchestrator</span>
        <span style={{ fontSize: 9, color: '#68a' }}>
          {totalActive} brains active
        </span>
        <span style={{ fontSize: 9, color: '#ffd700', marginLeft: 'auto' }}>
          {Object.keys(ANIMAL_BRAINS).length} species integrated
        </span>
      </div>
      
      <div style={styles.content}>
        <div style={styles.leftPanel}>
          <div style={styles.brainGrid}>
            {Object.entries(ANIMAL_BRAINS).map(([animal, data]) => (
              <AnimalBrainCard
                key={animal}
                animal={animal}
                data={data}
                active={activeAnimal === animal}
                activation={activations[animal] || 0}
                onSelect={setActiveAnimal}
              />
            ))}
          </div>
          
          <IntegrationMatrix activations={activations} />
        </div>
        
        <div style={styles.rightPanel}>
          <div style={styles.canvas}>
            <Canvas camera={{ position: [0, 0, 5], fov: 50 }}>
              <BrainScene activeAnimal={activeAnimal} activation={activeActivation} />
            </Canvas>
          </div>
          
          <AnimalBrainDetail
            animal={activeAnimal}
            data={activeData}
            activation={activeActivation}
          />
          
          <CollectiveOutput activations={activations} />
        </div>
      </div>
    </div>
  );
}
