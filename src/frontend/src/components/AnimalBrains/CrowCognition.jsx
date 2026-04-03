// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: CrowCognition — Causal Reasoning & Tool Use
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Crow-level intelligence:
//   - Causal reasoning (understanding cause and effect)
//   - Tool use and construction
//   - Future planning (up to 17 hours ahead)
//   - Face recognition
//   - Meta-cognition (knowing what you know)
//   - Problem decomposition
// ============================================================================

import React, { useState, useMemo, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const φ = 1.6180339887498948482;
const π = Math.PI;

// ─── CAUSAL CHAIN TYPES ───────────────────────────────────────────────────────
const CAUSAL_TYPES = {
  physical: { color: '#4488ff', icon: '⚙️', label: 'Physical Causation' },
  social: { color: '#ff88aa', icon: '👥', label: 'Social Causation' },
  temporal: { color: '#ffaa44', icon: '⏰', label: 'Temporal Causation' },
  intentional: { color: '#aa44ff', icon: '🎯', label: 'Intentional Causation' },
  probabilistic: { color: '#44ffaa', icon: '🎲', label: 'Probabilistic Causation' },
};

const TOOL_TYPES = {
  probe: { icon: '🔍', description: 'Extract food from holes' },
  hook: { icon: '🪝', description: 'Pull objects closer' },
  lever: { icon: '🔧', description: 'Lift or pry objects' },
  drop: { icon: '💧', description: 'Use gravity to crack' },
  composite: { icon: '🔗', description: 'Multi-step tool chains' },
};

// ─── CAUSAL GRAPH 3D ──────────────────────────────────────────────────────────
function CausalNode({ node, index, total }) {
  const meshRef = useRef();
  const angle = (index / total) * π * 2;
  const radius = 2;
  
  useFrame(({ clock }) => {
    if (!meshRef.current) return;
    const t = clock.getElapsedTime();
    
    meshRef.current.position.x = Math.cos(angle + t * 0.2) * radius;
    meshRef.current.position.z = Math.sin(angle + t * 0.2) * radius;
    meshRef.current.position.y = Math.sin(t + index) * 0.3;
    
    meshRef.current.scale.setScalar(1 + 0.1 * Math.sin(t * 2 + index));
  });
  
  const color = CAUSAL_TYPES[node.type]?.color || '#4af';
  
  return (
    <mesh ref={meshRef}>
      <sphereGeometry args={[0.3, 16, 16]} />
      <meshStandardMaterial
        color={color}
        emissive={color}
        emissiveIntensity={node.activation || 0.3}
        metalness={0.5}
        roughness={0.3}
      />
    </mesh>
  );
}

function CausalEdge({ from, to, strength }) {
  const lineRef = useRef();
  
  useFrame(({ clock }) => {
    if (!lineRef.current) return;
    const t = clock.getElapsedTime();
    
    const positions = lineRef.current.geometry.attributes.position.array;
    const fromAngle = (from / 10) * π * 2 + t * 0.2;
    const toAngle = (to / 10) * π * 2 + t * 0.2;
    
    positions[0] = Math.cos(fromAngle) * 2;
    positions[1] = 0;
    positions[2] = Math.sin(fromAngle) * 2;
    
    positions[3] = Math.cos(toAngle) * 2;
    positions[4] = 0;
    positions[5] = Math.sin(toAngle) * 2;
    
    lineRef.current.geometry.attributes.position.needsUpdate = true;
  });
  
  const geometry = useMemo(() => {
    const geo = new THREE.BufferGeometry();
    const positions = new Float32Array(6);
    geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    return geo;
  }, []);
  
  return (
    <line ref={lineRef} geometry={geometry}>
      <lineBasicMaterial color="#4af" transparent opacity={strength} />
    </line>
  );
}

function CausalGraphScene({ nodes, edges }) {
  return (
    <>
      <ambientLight intensity={0.3} />
      <pointLight position={[5, 5, 5]} intensity={0.5} />
      
      {nodes.map((node, i) => (
        <CausalNode key={node.id || i} node={node} index={i} total={nodes.length} />
      ))}
      
      {edges.map((edge, i) => (
        <CausalEdge
          key={i}
          from={edge.from}
          to={edge.to}
          strength={edge.strength || 0.5}
        />
      ))}
    </>
  );
}

// ─── REASONING CHAIN ──────────────────────────────────────────────────────────
function ReasoningChain({ chain }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #1a3a5c',
      borderRadius: 6,
      padding: 10,
      marginBottom: 8,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 8 }}>
        <span style={{ fontSize: 16 }}>🐦‍⬛</span>
        <span style={{ fontSize: 10, color: '#4af', fontWeight: 'bold' }}>
          Reasoning Chain #{chain.id}
        </span>
        <span style={{
          marginLeft: 'auto',
          fontSize: 8,
          padding: '2px 6px',
          borderRadius: 8,
          background: chain.valid ? '#003322' : '#330000',
          color: chain.valid ? '#00ff88' : '#ff4444',
        }}>
          {chain.valid ? 'VALID' : 'INVALID'}
        </span>
      </div>
      
      <div style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: 4 }}>
        {chain.steps.map((step, i) => (
          <React.Fragment key={i}>
            <div style={{
              padding: '4px 8px',
              borderRadius: 4,
              background: CAUSAL_TYPES[step.type]?.color + '22' || '#1a3a5c',
              border: `1px solid ${CAUSAL_TYPES[step.type]?.color || '#4af'}`,
              fontSize: 9,
              color: CAUSAL_TYPES[step.type]?.color || '#4af',
            }}>
              {step.label}
            </div>
            {i < chain.steps.length - 1 && (
              <span style={{ color: '#68a', fontSize: 12 }}>→</span>
            )}
          </React.Fragment>
        ))}
      </div>
      
      <div style={{ fontSize: 8, color: '#68a', marginTop: 6 }}>
        Confidence: {(chain.confidence * 100).toFixed(0)}% | Depth: {chain.depth}
      </div>
    </div>
  );
}

// ─── TOOL PLANNING ────────────────────────────────────────────────────────────
function ToolPlanning({ tools, currentTool }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ffaa44',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#ffaa44', marginBottom: 8 }}>🔧 TOOL PLANNING</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 6, marginBottom: 12 }}>
        {Object.entries(TOOL_TYPES).map(([type, data]) => (
          <div
            key={type}
            style={{
              textAlign: 'center',
              padding: 6,
              borderRadius: 6,
              background: currentTool === type ? '#2a2a4e' : '#050a14',
              border: `1px solid ${currentTool === type ? '#ffaa44' : '#1a3a5c'}`,
            }}
          >
            <div style={{ fontSize: 20 }}>{data.icon}</div>
            <div style={{ fontSize: 7, color: '#68a', marginTop: 2 }}>
              {type.charAt(0).toUpperCase() + type.slice(1)}
            </div>
          </div>
        ))}
      </div>
      
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>TOOL SEQUENCE</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
        {tools.map((tool, i) => (
          <React.Fragment key={i}>
            <div style={{
              padding: '4px 8px',
              borderRadius: 4,
              background: tool === currentTool ? '#2a2a4e' : '#050a14',
              border: `1px solid ${tool === currentTool ? '#ffaa44' : '#1a3a5c'}`,
              fontSize: 16,
            }}>
              {TOOL_TYPES[tool]?.icon || '❓'}
            </div>
            {i < tools.length - 1 && (
              <span style={{ color: '#68a', fontSize: 10 }}>→</span>
            )}
          </React.Fragment>
        ))}
      </div>
    </div>
  );
}

// ─── FUTURE PLANNING ──────────────────────────────────────────────────────────
function FuturePlanning({ plans, currentTime }) {
  const maxHorizon = Math.max(...plans.map(p => p.horizon), 1);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #aa44ff',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#aa44ff', marginBottom: 8 }}>⏰ FUTURE PLANNING</div>
      
      <div style={{
        position: 'relative',
        height: 100,
        background: '#050a14',
        borderRadius: 6,
        padding: 8,
      }}>
        {/* Timeline */}
        <div style={{
          position: 'absolute',
          left: 8,
          right: 8,
          top: '50%',
          height: 2,
          background: '#1a3a5c',
        }} />
        
        {/* Now marker */}
        <div style={{
          position: 'absolute',
          left: 8,
          top: '50%',
          transform: 'translateY(-50%)',
          width: 10,
          height: 10,
          borderRadius: '50%',
          background: '#00ff88',
          border: '2px solid #003322',
        }} />
        
        {/* Plans */}
        {plans.map((plan, i) => {
          const x = 20 + (plan.horizon / maxHorizon) * 80;
          const y = 20 + (i % 3) * 25;
          
          return (
            <div
              key={plan.id || i}
              style={{
                position: 'absolute',
                left: `${x}%`,
                top: y,
                transform: 'translateX(-50%)',
                padding: '4px 8px',
                borderRadius: 4,
                background: '#1a1a2e',
                border: `1px solid ${plan.priority > 0.7 ? '#ffd700' : '#4af'}`,
                fontSize: 8,
                color: '#adf',
                whiteSpace: 'nowrap',
              }}
              title={`${plan.description} - ${plan.horizon}h ahead`}
            >
              {plan.label}
            </div>
          );
        })}
        
        {/* Time labels */}
        <div style={{ position: 'absolute', left: 8, bottom: 4, fontSize: 7, color: '#68a' }}>Now</div>
        <div style={{ position: 'absolute', right: 8, bottom: 4, fontSize: 7, color: '#68a' }}>+{maxHorizon}h</div>
      </div>
      
      <div style={{ fontSize: 8, color: '#68a', marginTop: 6 }}>
        Planning horizon: up to 17 hours (crow maximum)
      </div>
    </div>
  );
}

// ─── META-COGNITION ───────────────────────────────────────────────────────────
function MetaCognition({ state }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #4488ff',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#4488ff', marginBottom: 8 }}>🧠 META-COGNITION</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 8 }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Confidence in Knowledge</div>
          <div style={{ fontSize: 16, color: state.knowledgeConfidence > 0.7 ? '#00ff88' : '#ffaa44' }}>
            {(state.knowledgeConfidence * 100).toFixed(0)}%
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Uncertainty Awareness</div>
          <div style={{ fontSize: 16, color: '#4af' }}>
            {(state.uncertaintyAwareness * 100).toFixed(0)}%
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Learning Rate</div>
          <div style={{ fontSize: 16, color: '#aa44ff' }}>
            {(state.learningRate * 100).toFixed(0)}%
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Memory Retrieval</div>
          <div style={{ fontSize: 16, color: '#ffaa44' }}>
            {(state.memoryRetrieval * 100).toFixed(0)}%
          </div>
        </div>
      </div>
      
      <div style={{ marginTop: 8 }}>
        <div style={{ fontSize: 8, color: '#68a', marginBottom: 4 }}>Known Unknowns</div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
          {state.knownUnknowns?.map((item, i) => (
            <span key={i} style={{
              fontSize: 7,
              padding: '2px 6px',
              borderRadius: 4,
              background: '#1a1a2e',
              color: '#ff8844',
              border: '1px solid #ff8844',
            }}>
              ?{item}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

// ─── FACE RECOGNITION ─────────────────────────────────────────────────────────
function FaceRecognition({ faces }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ff88aa',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#ff88aa', marginBottom: 8 }}>👤 FACE RECOGNITION</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8 }}>
        {faces.map((face, i) => (
          <div key={face.id || i} style={{
            textAlign: 'center',
            padding: 8,
            borderRadius: 6,
            background: '#050a14',
            border: `1px solid ${face.threat ? '#ff4444' : face.friendly ? '#00ff88' : '#1a3a5c'}`,
          }}>
            <div style={{ fontSize: 20 }}>
              {face.threat ? '😠' : face.friendly ? '😊' : '😐'}
            </div>
            <div style={{ fontSize: 8, color: '#adf', marginTop: 4 }}>{face.label}</div>
            <div style={{ fontSize: 7, color: '#68a' }}>
              {face.encounters} encounters
            </div>
          </div>
        ))}
      </div>
      
      <div style={{ fontSize: 8, color: '#68a', marginTop: 8 }}>
        Crows remember faces for years and communicate threat information to other crows
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
    color: '#2F2F2F',
    background: 'linear-gradient(90deg, #4af, #aa44ff)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 10,
    padding: 10,
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
export default function CrowCognitionPanel({ cognitionState = {} }) {
  // Sample state if none provided
  const state = {
    causalNodes: cognitionState.causalNodes || [
      { id: 1, type: 'physical', label: 'Stone', activation: 0.8 },
      { id: 2, type: 'physical', label: 'Water', activation: 0.6 },
      { id: 3, type: 'intentional', label: 'Food', activation: 0.9 },
      { id: 4, type: 'temporal', label: 'Wait', activation: 0.5 },
      { id: 5, type: 'physical', label: 'Rise', activation: 0.7 },
    ],
    causalEdges: cognitionState.causalEdges || [
      { from: 0, to: 1, strength: 0.8 },
      { from: 1, to: 4, strength: 0.7 },
      { from: 3, to: 4, strength: 0.5 },
      { from: 4, to: 2, strength: 0.9 },
    ],
    reasoningChains: cognitionState.reasoningChains || [
      {
        id: 1,
        steps: [
          { type: 'physical', label: 'Drop stone' },
          { type: 'physical', label: 'Water rises' },
          { type: 'intentional', label: 'Reach food' },
        ],
        valid: true,
        confidence: 0.92,
        depth: 3,
      },
      {
        id: 2,
        steps: [
          { type: 'social', label: 'Observe human' },
          { type: 'temporal', label: 'Remember face' },
          { type: 'intentional', label: 'Avoid threat' },
        ],
        valid: true,
        confidence: 0.85,
        depth: 3,
      },
    ],
    tools: cognitionState.tools || ['probe', 'hook', 'drop'],
    currentTool: cognitionState.currentTool || 'hook',
    futurePlans: cognitionState.futurePlans || [
      { id: 1, label: 'Cache food', horizon: 2, priority: 0.8, description: 'Store excess food' },
      { id: 2, label: 'Scout area', horizon: 6, priority: 0.6, description: 'Explore new territory' },
      { id: 3, label: 'Retrieve cache', horizon: 12, priority: 0.9, description: 'Get stored food before rain' },
    ],
    metaCognition: cognitionState.metaCognition || {
      knowledgeConfidence: 0.78,
      uncertaintyAwareness: 0.85,
      learningRate: 0.72,
      memoryRetrieval: 0.88,
      knownUnknowns: ['Weather tomorrow', 'Predator location', 'Food availability'],
    },
    faces: cognitionState.faces || [
      { id: 1, label: 'Farmer', threat: true, friendly: false, encounters: 15 },
      { id: 2, label: 'Child', threat: false, friendly: true, encounters: 8 },
      { id: 3, label: 'Stranger', threat: false, friendly: false, encounters: 2 },
      { id: 4, label: 'Feeder', threat: false, friendly: true, encounters: 30 },
    ],
  };
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={{ fontSize: 20 }}>🐦‍⬛</span>
        <span style={styles.title}>Crow Cognition — Causal Reasoning</span>
      </div>
      
      <div style={styles.content}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <div style={styles.canvas}>
            <Canvas camera={{ position: [0, 3, 5], fov: 50 }}>
              <CausalGraphScene nodes={state.causalNodes} edges={state.causalEdges} />
            </Canvas>
          </div>
          
          <div style={{ fontSize: 10, color: '#6af', marginBottom: 4 }}>REASONING CHAINS</div>
          {state.reasoningChains.map(chain => (
            <ReasoningChain key={chain.id} chain={chain} />
          ))}
        </div>
        
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <ToolPlanning tools={state.tools} currentTool={state.currentTool} />
          <FuturePlanning plans={state.futurePlans} />
          <MetaCognition state={state.metaCognition} />
          <FaceRecognition faces={state.faces} />
        </div>
      </div>
    </div>
  );
}
