// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: RealPhysicsMonitor — REAL Physics Visualization
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// This is NOT game physics. This is REAL PHYSICS.
//   - F = ma (Newton's Second Law)
//   - p = mv (Momentum)
//   - E = ½mv² (Kinetic Energy)
//   - U = mgh (Potential Energy)
//   - Drag: F_d = ½ρv²C_dA
//   - Lift: F_l = ½ρv²C_lA
//
// Everything based on real physical constants.
// ============================================================================

import React, { useState, useMemo } from 'react';

// ─── PHYSICAL CONSTANTS (matching backend) ────────────────────────────────────
const CONSTANTS = {
  GRAVITY: 9.80665,                    // m/s²
  SPEED_OF_LIGHT: 299792458,           // m/s
  AIR_DENSITY_SEA_LEVEL: 1.225,        // kg/m³
  WATER_DENSITY: 1000,                 // kg/m³
  BOLTZMANN: 1.380649e-23,             // J/K
  PLANCK: 6.62607015e-34,              // J·s
  φ: 1.6180339887498948482,            // Golden ratio
  π: 3.1415926535897932385,
};

// ─── FORCE ARROW ──────────────────────────────────────────────────────────────
function ForceArrow({ label, magnitude, maxMag, color, direction }) {
  const pct = Math.min(1, Math.abs(magnitude) / maxMag);
  const isNegative = magnitude < 0;
  
  return (
    <div style={{ marginBottom: 8 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
        <span style={{ fontSize: 9, color: '#6af' }}>{label}</span>
        <span style={{ fontSize: 9, color }}>
          {magnitude.toFixed(2)} {direction}
        </span>
      </div>
      <div style={{
        display: 'flex',
        alignItems: 'center',
        height: 12,
        background: '#0a1a2e',
        borderRadius: 2,
        overflow: 'hidden',
      }}>
        <div style={{
          width: '50%',
          height: '100%',
          display: 'flex',
          justifyContent: 'flex-end',
        }}>
          {isNegative && (
            <div style={{
              width: `${pct * 100}%`,
              height: '100%',
              background: color,
              transition: 'width 0.2s',
            }} />
          )}
        </div>
        <div style={{
          width: 2,
          height: '100%',
          background: '#4af',
        }} />
        <div style={{
          width: '50%',
          height: '100%',
          display: 'flex',
          justifyContent: 'flex-start',
        }}>
          {!isNegative && (
            <div style={{
              width: `${pct * 100}%`,
              height: '100%',
              background: color,
              transition: 'width 0.2s',
            }} />
          )}
        </div>
      </div>
    </div>
  );
}

// ─── VECTOR DISPLAY ───────────────────────────────────────────────────────────
function VectorDisplay({ label, vector, color }) {
  const mag = Math.sqrt(vector.x ** 2 + vector.y ** 2 + vector.z ** 2);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 4,
      padding: 8,
      marginBottom: 6,
    }}>
      <div style={{ fontSize: 9, color, marginBottom: 4 }}>{label}</div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 4 }}>
        <div>
          <div style={{ fontSize: 7, color: '#68a' }}>X</div>
          <div style={{ fontSize: 10, color: '#ff6644' }}>{vector.x.toFixed(3)}</div>
        </div>
        <div>
          <div style={{ fontSize: 7, color: '#68a' }}>Y</div>
          <div style={{ fontSize: 10, color: '#44ff88' }}>{vector.y.toFixed(3)}</div>
        </div>
        <div>
          <div style={{ fontSize: 7, color: '#68a' }}>Z</div>
          <div style={{ fontSize: 10, color: '#4488ff' }}>{vector.z.toFixed(3)}</div>
        </div>
      </div>
      <div style={{ fontSize: 8, color: '#68a', marginTop: 4 }}>
        |v| = {mag.toFixed(3)} m/s
      </div>
    </div>
  );
}

// ─── ENERGY GAUGE ─────────────────────────────────────────────────────────────
function EnergyGauge({ label, value, maxValue, unit, color }) {
  const pct = Math.min(1, value / maxValue);
  
  return (
    <div style={{ marginBottom: 8 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
        <span style={{ fontSize: 9, color }}>{label}</span>
        <span style={{ fontSize: 9, color: '#4af' }}>
          {value.toExponential(2)} {unit}
        </span>
      </div>
      <div style={{
        height: 8,
        background: '#0a1a2e',
        borderRadius: 4,
        overflow: 'hidden',
      }}>
        <div style={{
          width: `${pct * 100}%`,
          height: '100%',
          background: `linear-gradient(90deg, ${color}88, ${color})`,
          transition: 'width 0.3s',
        }} />
      </div>
    </div>
  );
}

// ─── PHYSICS ENTITY CARD ──────────────────────────────────────────────────────
function PhysicsEntityCard({ entity, selected, onSelect }) {
  const kineticEnergy = 0.5 * entity.mass * (entity.velocity.x ** 2 + entity.velocity.y ** 2 + entity.velocity.z ** 2);
  const potentialEnergy = entity.mass * CONSTANTS.GRAVITY * entity.position.y;
  const momentum = {
    x: entity.mass * entity.velocity.x,
    y: entity.mass * entity.velocity.y,
    z: entity.mass * entity.velocity.z,
  };
  
  return (
    <div
      onClick={() => onSelect(entity)}
      style={{
        background: selected ? '#1a2a4e' : '#0a1a2e',
        border: `1px solid ${selected ? '#4af' : '#1a3a5c'}`,
        borderRadius: 4,
        padding: 10,
        cursor: 'pointer',
        marginBottom: 6,
      }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
        <span style={{ fontSize: 10, color: '#4af', fontWeight: 'bold' }}>
          {entity.name || `Entity #${entity.id}`}
        </span>
        <span style={{ fontSize: 8, color: '#68a' }}>{entity.type}</span>
      </div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 4, fontSize: 8 }}>
        <div>
          <div style={{ color: '#68a' }}>Mass</div>
          <div style={{ color: '#ff8800' }}>{entity.mass.toFixed(1)} kg</div>
        </div>
        <div>
          <div style={{ color: '#68a' }}>Speed</div>
          <div style={{ color: '#00ff88' }}>
            {Math.sqrt(entity.velocity.x ** 2 + entity.velocity.y ** 2 + entity.velocity.z ** 2).toFixed(2)} m/s
          </div>
        </div>
        <div>
          <div style={{ color: '#68a' }}>KE</div>
          <div style={{ color: '#ff4488' }}>{kineticEnergy.toExponential(1)} J</div>
        </div>
        <div>
          <div style={{ color: '#68a' }}>PE</div>
          <div style={{ color: '#4488ff' }}>{potentialEnergy.toExponential(1)} J</div>
        </div>
      </div>
    </div>
  );
}

// ─── COLLISION LOG ────────────────────────────────────────────────────────────
function CollisionLog({ collisions }) {
  return (
    <div style={{
      background: '#0a0a1e',
      border: '1px solid #1a3a5c',
      borderRadius: 4,
      padding: 8,
      maxHeight: 120,
      overflow: 'auto',
    }}>
      <div style={{ fontSize: 9, color: '#ff4444', marginBottom: 4 }}>COLLISION LOG</div>
      {collisions.length === 0 ? (
        <div style={{ fontSize: 8, color: '#446' }}>No recent collisions</div>
      ) : (
        collisions.map((col, i) => (
          <div key={i} style={{ fontSize: 8, color: '#adf', marginBottom: 2 }}>
            <span style={{ color: '#ff8800' }}>{col.entityA}</span>
            {' ↔ '}
            <span style={{ color: '#ff8800' }}>{col.entityB}</span>
            {' — '}
            <span style={{ color: '#ff4488' }}>{col.impulse.toFixed(1)} N·s</span>
            {' — '}
            <span style={{ color: '#68a' }}>{col.type}</span>
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
    padding: '8px 12px',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  title: {
    fontSize: 11,
    color: '#ff4488',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  badge: {
    fontSize: 8,
    padding: '2px 6px',
    borderRadius: 8,
    background: '#220022',
    color: '#ff4488',
    border: '1px solid #ff4488',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 8,
    padding: 10,
    overflow: 'auto',
  },
  section: {
    background: '#050a14',
    border: '1px solid #1a2a3c',
    borderRadius: 4,
    padding: 10,
  },
  sectionTitle: {
    fontSize: 10,
    color: '#6af',
    marginBottom: 8,
    letterSpacing: '0.1em',
    textTransform: 'uppercase',
    borderBottom: '1px solid #1a3a5c',
    paddingBottom: 4,
  },
  constants: {
    display: 'grid',
    gridTemplateColumns: 'repeat(2, 1fr)',
    gap: 4,
    fontSize: 8,
  },
  constant: {
    color: '#68a',
  },
  constantValue: {
    color: '#4af',
    fontFamily: 'monospace',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function RealPhysicsMonitor({ physicsState = {} }) {
  const [selectedEntity, setSelectedEntity] = useState(null);
  
  // Sample physics state if none provided
  const state = {
    simulationTime: physicsState.simulationTime || 0,
    deltaTime: physicsState.deltaTime || 0.016667,
    gravity: physicsState.gravity || { x: 0, y: -9.80665, z: 0 },
    airDensity: physicsState.airDensity || 1.225,
    entities: physicsState.entities || [
      {
        id: 1,
        name: 'Drone Alpha',
        type: 'Quadrotor',
        mass: 5.0,
        position: { x: 10, y: 50, z: 20 },
        velocity: { x: 5.2, y: -0.3, z: 2.1 },
        acceleration: { x: 0.1, y: -9.8, z: 0 },
        forces: { thrust: 52, drag: 3.2, lift: 49 },
      },
      {
        id: 2,
        name: 'Drone Beta',
        type: 'Quadrotor',
        mass: 5.0,
        position: { x: -15, y: 45, z: 10 },
        velocity: { x: -2.1, y: 0.5, z: 3.3 },
        acceleration: { x: -0.2, y: -9.7, z: 0.1 },
        forces: { thrust: 50, drag: 2.8, lift: 48 },
      },
      {
        id: 3,
        name: 'Target Building',
        type: 'Structure',
        mass: 500000,
        position: { x: 50, y: 15, z: 30 },
        velocity: { x: 0, y: 0, z: 0 },
        acceleration: { x: 0, y: 0, z: 0 },
        forces: { thrust: 0, drag: 0, lift: 0 },
      },
    ],
    collisions: physicsState.collisions || [
      { entityA: 'Drone Alpha', entityB: 'Air Particle', impulse: 0.02, type: 'Drag' },
    ],
    totalEnergy: physicsState.totalEnergy || 125000,
    totalMomentum: physicsState.totalMomentum || { x: 15.5, y: -2.0, z: 27.0 },
  };
  
  const selected = selectedEntity || state.entities[0];
  
  // Calculate physics for selected entity
  const entityPhysics = useMemo(() => {
    if (!selected) return null;
    
    const v = selected.velocity;
    const speed = Math.sqrt(v.x ** 2 + v.y ** 2 + v.z ** 2);
    const kineticEnergy = 0.5 * selected.mass * speed ** 2;
    const potentialEnergy = selected.mass * CONSTANTS.GRAVITY * selected.position.y;
    const totalEnergy = kineticEnergy + potentialEnergy;
    
    // Drag calculation: F_d = ½ρv²C_dA
    const dragCoeff = 0.5;
    const area = 0.2;
    const dragForce = 0.5 * state.airDensity * speed ** 2 * dragCoeff * area;
    
    return {
      speed,
      kineticEnergy,
      potentialEnergy,
      totalEnergy,
      dragForce,
      momentum: {
        x: selected.mass * v.x,
        y: selected.mass * v.y,
        z: selected.mass * v.z,
      },
    };
  }, [selected, state.airDensity]);
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={styles.title}>⚛ Real Physics Engine</span>
        <span style={styles.badge}>NEWTONIAN</span>
        <span style={{ fontSize: 9, color: '#68a', marginLeft: 'auto' }}>
          t = {state.simulationTime.toFixed(3)}s | Δt = {(state.deltaTime * 1000).toFixed(2)}ms
        </span>
      </div>
      
      <div style={styles.content}>
        {/* Left Column: Entities */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <div style={styles.section}>
            <div style={styles.sectionTitle}>Physics Entities</div>
            {state.entities.map(entity => (
              <PhysicsEntityCard
                key={entity.id}
                entity={entity}
                selected={selected?.id === entity.id}
                onSelect={setSelectedEntity}
              />
            ))}
          </div>
          
          <CollisionLog collisions={state.collisions} />
        </div>
        
        {/* Right Column: Selected Entity Details */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {selected && entityPhysics && (
            <>
              <div style={styles.section}>
                <div style={styles.sectionTitle}>
                  {selected.name} — Kinematics
                </div>
                <VectorDisplay label="Position (m)" vector={selected.position} color="#ffd700" />
                <VectorDisplay label="Velocity (m/s)" vector={selected.velocity} color="#00ff88" />
                <VectorDisplay label="Acceleration (m/s²)" vector={selected.acceleration} color="#ff4488" />
                <VectorDisplay label="Momentum (kg·m/s)" vector={entityPhysics.momentum} color="#aa44ff" />
              </div>
              
              <div style={styles.section}>
                <div style={styles.sectionTitle}>Energy (Joules)</div>
                <EnergyGauge label="E_kinetic = ½mv²" value={entityPhysics.kineticEnergy} maxValue={10000} unit="J" color="#ff4488" />
                <EnergyGauge label="E_potential = mgh" value={entityPhysics.potentialEnergy} maxValue={10000} unit="J" color="#4488ff" />
                <EnergyGauge label="E_total" value={entityPhysics.totalEnergy} maxValue={20000} unit="J" color="#ffd700" />
              </div>
              
              <div style={styles.section}>
                <div style={styles.sectionTitle}>Forces (Newtons)</div>
                <ForceArrow label="Thrust" magnitude={selected.forces?.thrust || 0} maxMag={100} color="#00ff88" direction="N ↑" />
                <ForceArrow label="Drag (F_d = ½ρv²C_dA)" magnitude={-entityPhysics.dragForce} maxMag={50} color="#ff8800" direction="N ←" />
                <ForceArrow label="Weight (F = mg)" magnitude={-selected.mass * CONSTANTS.GRAVITY} maxMag={100} color="#ff4488" direction="N ↓" />
                <ForceArrow label="Lift" magnitude={selected.forces?.lift || 0} maxMag={100} color="#4488ff" direction="N ↑" />
              </div>
            </>
          )}
          
          <div style={styles.section}>
            <div style={styles.sectionTitle}>Physical Constants</div>
            <div style={styles.constants}>
              <span style={styles.constant}>g =</span>
              <span style={styles.constantValue}>{CONSTANTS.GRAVITY} m/s²</span>
              <span style={styles.constant}>ρ_air =</span>
              <span style={styles.constantValue}>{state.airDensity} kg/m³</span>
              <span style={styles.constant}>φ =</span>
              <span style={styles.constantValue}>{CONSTANTS.φ.toFixed(6)}</span>
              <span style={styles.constant}>π =</span>
              <span style={styles.constantValue}>{CONSTANTS.π.toFixed(6)}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
