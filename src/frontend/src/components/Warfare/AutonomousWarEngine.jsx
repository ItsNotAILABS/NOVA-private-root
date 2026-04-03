// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: AutonomousWarEngine — Full Warfare Doctrine System
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Complete autonomous warfare system:
//   - OODA Loop (Observe, Orient, Decide, Act)
//   - Kill chain management
//   - Rules of engagement
//   - Target acquisition and tracking
//   - Weapons systems control
//   - Battle damage assessment
//   - Electronic warfare
//   - HITL integration
// ============================================================================

import React, { useState, useMemo, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

// ─── THREAT LEVELS ────────────────────────────────────────────────────────────
const THREAT_LEVELS = {
  critical: { color: '#ff0000', label: 'CRITICAL', priority: 5 },
  high: { color: '#ff4400', label: 'HIGH', priority: 4 },
  medium: { color: '#ffaa00', label: 'MEDIUM', priority: 3 },
  low: { color: '#ffff00', label: 'LOW', priority: 2 },
  minimal: { color: '#00ff00', label: 'MINIMAL', priority: 1 },
};

// ─── ENGAGEMENT MODES ─────────────────────────────────────────────────────────
const ENGAGEMENT_MODES = {
  weapons_free: { color: '#ff0000', label: 'WEAPONS FREE', description: 'Engage at will' },
  weapons_tight: { color: '#ffaa00', label: 'WEAPONS TIGHT', description: 'Engage only if threatened' },
  weapons_hold: { color: '#00ff00', label: 'WEAPONS HOLD', description: 'Engage only on command' },
  return_fire: { color: '#ff8800', label: 'RETURN FIRE', description: 'Engage only if fired upon' },
};

// ─── OODA STATES ──────────────────────────────────────────────────────────────
const OODA_STATES = {
  observe: { color: '#4488ff', icon: '👁️', label: 'OBSERVE' },
  orient: { color: '#aa44ff', icon: '🧭', label: 'ORIENT' },
  decide: { color: '#ffaa44', icon: '🎯', label: 'DECIDE' },
  act: { color: '#ff4444', icon: '⚡', label: 'ACT' },
};

// ─── KILL CHAIN PHASES ────────────────────────────────────────────────────────
const KILL_CHAIN = [
  { id: 'find', label: 'FIND', icon: '🔍', description: 'Locate potential targets' },
  { id: 'fix', label: 'FIX', icon: '📍', description: 'Establish precise location' },
  { id: 'track', label: 'TRACK', icon: '👁️', description: 'Maintain continuous observation' },
  { id: 'target', label: 'TARGET', icon: '🎯', description: 'Select for engagement' },
  { id: 'engage', label: 'ENGAGE', icon: '⚔️', description: 'Execute engagement' },
  { id: 'assess', label: 'ASSESS', icon: '✅', description: 'Battle damage assessment' },
];

// ─── TARGET 3D VISUALIZATION ──────────────────────────────────────────────────
function TargetMarker({ target, index }) {
  const groupRef = useRef();
  const ringRef = useRef();
  
  useFrame(({ clock }) => {
    if (!groupRef.current) return;
    const t = clock.getElapsedTime();
    
    // Pulsing based on threat level
    const pulse = 1 + 0.2 * Math.sin(t * (target.threatLevel + 1) * 2);
    groupRef.current.scale.setScalar(pulse);
    
    if (ringRef.current) {
      ringRef.current.rotation.z = t * 2;
    }
  });
  
  const color = THREAT_LEVELS[target.threat]?.color || '#ff4444';
  
  return (
    <group ref={groupRef} position={[target.x, target.y, target.z]}>
      {/* Target sphere */}
      <mesh>
        <sphereGeometry args={[0.3, 16, 16]} />
        <meshStandardMaterial color={color} emissive={color} emissiveIntensity={0.5} />
      </mesh>
      
      {/* Targeting ring */}
      <mesh ref={ringRef} rotation={[π / 2, 0, 0]}>
        <ringGeometry args={[0.5, 0.6, 8]} />
        <meshBasicMaterial color={color} transparent opacity={0.7} />
      </mesh>
      
      {/* Lock indicator */}
      {target.locked && (
        <mesh rotation={[0, 0, π / 4]}>
          <ringGeometry args={[0.7, 0.75, 4]} />
          <meshBasicMaterial color="#ff0000" />
        </mesh>
      )}
    </group>
  );
}

function BattlefieldScene({ targets, drones, engagements }) {
  return (
    <>
      <ambientLight intensity={0.2} />
      <pointLight position={[10, 10, 10]} intensity={0.5} color="#ff4444" />
      <pointLight position={[-10, 10, -10]} intensity={0.3} color="#4444ff" />
      
      {/* Grid */}
      <gridHelper args={[20, 20, '#1a3a5c', '#0a1a2e']} />
      
      {/* Targets */}
      {targets.map((target, i) => (
        <TargetMarker key={target.id || i} target={target} index={i} />
      ))}
      
      {/* Drones */}
      {drones.map((drone, i) => (
        <mesh key={drone.id || i} position={[drone.x, drone.y, drone.z]}>
          <octahedronGeometry args={[0.25, 0]} />
          <meshStandardMaterial color="#00ff88" emissive="#00ff88" emissiveIntensity={0.3} />
        </mesh>
      ))}
      
      {/* Engagement lines */}
      {engagements.map((eng, i) => {
        const points = [
          new THREE.Vector3(eng.dronePos.x, eng.dronePos.y, eng.dronePos.z),
          new THREE.Vector3(eng.targetPos.x, eng.targetPos.y, eng.targetPos.z),
        ];
        const geometry = new THREE.BufferGeometry().setFromPoints(points);
        
        return (
          <line key={i} geometry={geometry}>
            <lineBasicMaterial color="#ff0000" transparent opacity={0.5 + eng.progress * 0.5} />
          </line>
        );
      })}
    </>
  );
}

// ─── OODA LOOP DISPLAY ────────────────────────────────────────────────────────
function OODALoop({ currentPhase, phaseData }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #4488ff',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#4488ff', marginBottom: 8 }}>OODA LOOP</div>
      
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        {Object.entries(OODA_STATES).map(([phase, data], i) => (
          <React.Fragment key={phase}>
            <div style={{
              textAlign: 'center',
              padding: 8,
              borderRadius: 8,
              background: currentPhase === phase ? `${data.color}22` : '#050a14',
              border: `2px solid ${currentPhase === phase ? data.color : '#1a3a5c'}`,
              minWidth: 60,
            }}>
              <div style={{ fontSize: 20 }}>{data.icon}</div>
              <div style={{ fontSize: 9, color: data.color, marginTop: 4 }}>{data.label}</div>
              {phaseData[phase] && (
                <div style={{ fontSize: 8, color: '#68a', marginTop: 2 }}>
                  {phaseData[phase].time?.toFixed(1)}s
                </div>
              )}
            </div>
            {i < 3 && (
              <div style={{ color: '#1a3a5c', fontSize: 16 }}>→</div>
            )}
          </React.Fragment>
        ))}
      </div>
      
      <div style={{
        marginTop: 8,
        height: 4,
        background: '#050a14',
        borderRadius: 2,
        overflow: 'hidden',
      }}>
        <div style={{
          width: `${((Object.keys(OODA_STATES).indexOf(currentPhase) + 1) / 4) * 100}%`,
          height: '100%',
          background: OODA_STATES[currentPhase]?.color || '#4af',
          transition: 'width 0.3s',
        }} />
      </div>
    </div>
  );
}

// ─── KILL CHAIN PROGRESS ──────────────────────────────────────────────────────
function KillChainProgress({ currentPhase, targets }) {
  const phaseIndex = KILL_CHAIN.findIndex(p => p.id === currentPhase);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ff4444',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#ff4444', marginBottom: 8 }}>F2T2EA KILL CHAIN</div>
      
      <div style={{ display: 'flex', gap: 2 }}>
        {KILL_CHAIN.map((phase, i) => {
          const isActive = i === phaseIndex;
          const isComplete = i < phaseIndex;
          
          return (
            <div
              key={phase.id}
              style={{
                flex: 1,
                textAlign: 'center',
                padding: 6,
                borderRadius: 4,
                background: isActive ? '#2a0000' : isComplete ? '#002200' : '#050a14',
                border: `1px solid ${isActive ? '#ff4444' : isComplete ? '#00ff88' : '#1a3a5c'}`,
              }}
            >
              <div style={{ fontSize: 14 }}>{phase.icon}</div>
              <div style={{ fontSize: 7, color: isActive ? '#ff4444' : isComplete ? '#00ff88' : '#68a', marginTop: 2 }}>
                {phase.label}
              </div>
            </div>
          );
        })}
      </div>
      
      {/* Targets in chain */}
      <div style={{ marginTop: 8, fontSize: 9, color: '#6af' }}>
        Active Targets: {targets.filter(t => t.inKillChain).length}
      </div>
    </div>
  );
}

// ─── TARGET LIST ──────────────────────────────────────────────────────────────
function TargetList({ targets, onSelect, selectedId }) {
  const sortedTargets = [...targets].sort((a, b) => 
    (THREAT_LEVELS[b.threat]?.priority || 0) - (THREAT_LEVELS[a.threat]?.priority || 0)
  );
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ff8800',
      borderRadius: 8,
      padding: 12,
      maxHeight: 200,
      overflow: 'auto',
    }}>
      <div style={{ fontSize: 10, color: '#ff8800', marginBottom: 8 }}>🎯 TARGET LIST</div>
      
      {sortedTargets.map(target => {
        const threatData = THREAT_LEVELS[target.threat] || THREAT_LEVELS.medium;
        
        return (
          <div
            key={target.id}
            onClick={() => onSelect(target)}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              padding: 6,
              marginBottom: 4,
              borderRadius: 4,
              background: selectedId === target.id ? '#1a2a4e' : '#050a14',
              border: `1px solid ${selectedId === target.id ? threatData.color : '#1a3a5c'}`,
              cursor: 'pointer',
            }}
          >
            <div style={{
              width: 8,
              height: 8,
              borderRadius: '50%',
              background: threatData.color,
            }} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 9, color: '#adf' }}>{target.name || `Target ${target.id}`}</div>
              <div style={{ fontSize: 7, color: '#68a' }}>{target.type} | {target.distance?.toFixed(0)}m</div>
            </div>
            <div style={{
              fontSize: 8,
              padding: '2px 6px',
              borderRadius: 4,
              background: `${threatData.color}22`,
              color: threatData.color,
            }}>
              {threatData.label}
            </div>
            {target.locked && (
              <span style={{ color: '#ff0000', fontSize: 12 }}>🔒</span>
            )}
          </div>
        );
      })}
    </div>
  );
}

// ─── RULES OF ENGAGEMENT ──────────────────────────────────────────────────────
function RulesOfEngagement({ mode, conditions, violations }) {
  const modeData = ENGAGEMENT_MODES[mode] || ENGAGEMENT_MODES.weapons_hold;
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: `1px solid ${modeData.color}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: modeData.color, marginBottom: 8 }}>⚖️ RULES OF ENGAGEMENT</div>
      
      <div style={{
        padding: 8,
        borderRadius: 6,
        background: `${modeData.color}22`,
        border: `1px solid ${modeData.color}`,
        marginBottom: 8,
      }}>
        <div style={{ fontSize: 12, color: modeData.color, fontWeight: 'bold' }}>{modeData.label}</div>
        <div style={{ fontSize: 8, color: '#68a', marginTop: 2 }}>{modeData.description}</div>
      </div>
      
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 4 }}>CONDITIONS</div>
      {conditions.map((cond, i) => (
        <div key={i} style={{
          display: 'flex',
          alignItems: 'center',
          gap: 6,
          padding: '4px 0',
          fontSize: 8,
          color: cond.met ? '#00ff88' : '#ff4444',
        }}>
          <span>{cond.met ? '✓' : '✗'}</span>
          <span>{cond.description}</span>
        </div>
      ))}
      
      {violations.length > 0 && (
        <div style={{ marginTop: 8 }}>
          <div style={{ fontSize: 9, color: '#ff4444', marginBottom: 4 }}>⚠ VIOLATIONS</div>
          {violations.map((v, i) => (
            <div key={i} style={{ fontSize: 8, color: '#ff4444', padding: '2px 0' }}>
              • {v}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// ─── WEAPONS STATUS ───────────────────────────────────────────────────────────
function WeaponsStatus({ weapons }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #aa44ff',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#aa44ff', marginBottom: 8 }}>🚀 WEAPONS STATUS</div>
      
      {weapons.map(weapon => (
        <div key={weapon.id} style={{ marginBottom: 8 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
            <span style={{ fontSize: 9, color: '#adf' }}>{weapon.name}</span>
            <span style={{
              fontSize: 8,
              color: weapon.ready ? '#00ff88' : weapon.reloading ? '#ffaa00' : '#ff4444',
            }}>
              {weapon.ready ? 'READY' : weapon.reloading ? 'RELOADING' : 'OFFLINE'}
            </span>
          </div>
          <div style={{
            display: 'flex',
            gap: 2,
            height: 8,
          }}>
            {Array.from({ length: weapon.capacity }).map((_, i) => (
              <div key={i} style={{
                flex: 1,
                background: i < weapon.ammo ? '#aa44ff' : '#1a1a2e',
                borderRadius: 2,
              }} />
            ))}
          </div>
          <div style={{ fontSize: 7, color: '#68a', marginTop: 2 }}>
            {weapon.ammo}/{weapon.capacity} | {weapon.type}
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── BATTLE DAMAGE ASSESSMENT ─────────────────────────────────────────────────
function BattleDamageAssessment({ assessments }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #00ff88',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#00ff88', marginBottom: 8 }}>📊 BATTLE DAMAGE ASSESSMENT</div>
      
      {assessments.length === 0 ? (
        <div style={{ fontSize: 9, color: '#68a' }}>No recent engagements</div>
      ) : (
        assessments.map(bda => (
          <div key={bda.id} style={{
            padding: 8,
            marginBottom: 4,
            borderRadius: 4,
            background: '#050a14',
            border: `1px solid ${bda.confirmed ? '#00ff88' : '#ffaa00'}`,
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
              <span style={{ fontSize: 9, color: '#adf' }}>Target {bda.targetId}</span>
              <span style={{
                fontSize: 8,
                color: bda.confirmed ? '#00ff88' : '#ffaa00',
              }}>
                {bda.confirmed ? 'CONFIRMED' : 'PENDING'}
              </span>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 4, fontSize: 8 }}>
              <div>
                <div style={{ color: '#68a' }}>Damage</div>
                <div style={{ color: '#ff4444' }}>{(bda.damage * 100).toFixed(0)}%</div>
              </div>
              <div>
                <div style={{ color: '#68a' }}>Status</div>
                <div style={{ color: bda.destroyed ? '#ff4444' : '#ffaa00' }}>
                  {bda.destroyed ? 'DESTROYED' : 'DAMAGED'}
                </div>
              </div>
              <div>
                <div style={{ color: '#68a' }}>Confidence</div>
                <div style={{ color: '#4af' }}>{(bda.confidence * 100).toFixed(0)}%</div>
              </div>
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
    color: '#ff4444',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  alertBadge: (active) => ({
    fontSize: 8,
    padding: '2px 8px',
    borderRadius: 8,
    background: active ? '#440000' : '#1a1a2e',
    color: active ? '#ff4444' : '#68a',
    border: `1px solid ${active ? '#ff4444' : '#1a3a5c'}`,
    animation: active ? 'pulse 1s infinite' : 'none',
  }),
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
  canvas: {
    flex: 1,
    minHeight: 250,
    background: '#050a14',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
  },
  rightPanel: {
    display: 'flex',
    flexDirection: 'column',
    gap: 10,
    overflow: 'auto',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function AutonomousWarEngine({ warState = {} }) {
  const [selectedTarget, setSelectedTarget] = useState(null);
  
  // Sample state if none provided
  const state = {
    oodaPhase: warState.oodaPhase || 'decide',
    oodaData: warState.oodaData || {
      observe: { time: 1.2 },
      orient: { time: 0.8 },
      decide: { time: 0.5 },
      act: { time: 0.3 },
    },
    killChainPhase: warState.killChainPhase || 'track',
    engagementMode: warState.engagementMode || 'weapons_tight',
    targets: warState.targets || [
      { id: 1, name: 'Hostile UAV', type: 'Aerial', threat: 'high', x: 3, y: 2, z: -2, distance: 450, locked: true, inKillChain: true },
      { id: 2, name: 'Ground Vehicle', type: 'Vehicle', threat: 'medium', x: -2, y: 0, z: 3, distance: 820, locked: false, inKillChain: true },
      { id: 3, name: 'Infantry Group', type: 'Personnel', threat: 'low', x: 4, y: 0, z: 4, distance: 1200, locked: false, inKillChain: false },
    ],
    drones: warState.drones || [
      { id: 1, x: 0, y: 3, z: 0 },
      { id: 2, x: -1, y: 2.5, z: 1 },
      { id: 3, x: 1, y: 2.5, z: -1 },
    ],
    engagements: warState.engagements || [
      { dronePos: { x: 0, y: 3, z: 0 }, targetPos: { x: 3, y: 2, z: -2 }, progress: 0.7 },
    ],
    roeConditions: warState.roeConditions || [
      { description: 'Positive target identification', met: true },
      { description: 'No civilian presence in engagement zone', met: true },
      { description: 'Commander authorization received', met: false },
      { description: 'Weapons release altitude achieved', met: true },
    ],
    roeViolations: warState.roeViolations || [],
    weapons: warState.weapons || [
      { id: 1, name: 'Missile Pod A', type: 'AGM-114', capacity: 4, ammo: 3, ready: true, reloading: false },
      { id: 2, name: 'Gun Turret', type: '30mm Cannon', capacity: 100, ammo: 85, ready: true, reloading: false },
      { id: 3, name: 'Missile Pod B', type: 'AIM-9X', capacity: 2, ammo: 0, ready: false, reloading: true },
    ],
    battleDamage: warState.battleDamage || [
      { id: 1, targetId: 5, damage: 0.95, destroyed: true, confirmed: true, confidence: 0.98 },
      { id: 2, targetId: 7, damage: 0.45, destroyed: false, confirmed: false, confidence: 0.72 },
    ],
    alertActive: warState.alertActive || true,
  };
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={{ fontSize: 20 }}>⚔️</span>
        <span style={styles.title}>Autonomous War Engine</span>
        <span style={styles.alertBadge(state.alertActive)}>
          {state.alertActive ? '⚠ COMBAT ACTIVE' : 'STANDBY'}
        </span>
        <span style={{
          marginLeft: 'auto',
          fontSize: 9,
          color: ENGAGEMENT_MODES[state.engagementMode]?.color || '#68a',
        }}>
          {ENGAGEMENT_MODES[state.engagementMode]?.label || 'UNKNOWN'}
        </span>
      </div>
      
      <div style={styles.content}>
        <div style={styles.leftPanel}>
          <OODALoop currentPhase={state.oodaPhase} phaseData={state.oodaData} />
          
          <div style={styles.canvas}>
            <Canvas camera={{ position: [8, 8, 8], fov: 50 }}>
              <BattlefieldScene
                targets={state.targets}
                drones={state.drones}
                engagements={state.engagements}
              />
            </Canvas>
          </div>
          
          <KillChainProgress currentPhase={state.killChainPhase} targets={state.targets} />
        </div>
        
        <div style={styles.rightPanel}>
          <RulesOfEngagement
            mode={state.engagementMode}
            conditions={state.roeConditions}
            violations={state.roeViolations}
          />
          
          <TargetList
            targets={state.targets}
            selectedId={selectedTarget?.id}
            onSelect={setSelectedTarget}
          />
          
          <WeaponsStatus weapons={state.weapons} />
          
          <BattleDamageAssessment assessments={state.battleDamage} />
        </div>
      </div>
    </div>
  );
}
