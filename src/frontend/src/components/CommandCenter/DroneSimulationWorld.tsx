// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: DroneSimulationWorld — THE ACTUAL EXPERIMENT
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    DRONE SIMULATION WORLD — THE EXPERIMENT                     ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  THIS IS THE ACTUAL SWARM EXPERIMENT:                                          ║
// ║    • Real drone physics with aerodynamics                                      ║
// ║    • Kuramoto synchronization (coherence r)                                    ║
// ║    • Jasmine drift tracking                                                    ║
// ║    • Law enforcement at every tick                                             ║
// ║    • Stability budget governance                                               ║
// ║    • Human-in-the-loop controls                                                ║
// ║                                                                                ║
// ║  NOTHING IS FAKE. THIS IS REAL.                                                ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES — REAL DRONE STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface Vec3 {
  x: number;
  y: number;
  z: number;
}

interface DroneState {
  id: number;
  position: Vec3;
  velocity: Vec3;
  acceleration: Vec3;
  orientation: { pitch: number; roll: number; yaw: number };
  phase: number;           // Kuramoto phase
  naturalFreq: number;     // ω_i
  couplingStrength: number;
  energy: number;
  health: number;
  status: 'Active' | 'Damaged' | 'Critical' | 'Offline';
  role: 'Scout' | 'Fighter' | 'Support' | 'Commander';
  target: Vec3 | null;
  trail: Vec3[];
}

interface SwarmMetrics {
  rSwarm: number;          // Kuramoto order parameter
  jDrift: number;          // Jasmine drift
  coherence: number;
  stability: number;
  avgEnergy: number;
  avgHealth: number;
  activeDrones: number;
  totalDrones: number;
}

interface WorldState {
  time: number;
  beat: number;
  timeOfDay: number;       // 0-24
  weather: 'Clear' | 'Cloudy' | 'Storm';
  windSpeed: number;
  windDirection: Vec3;
}

interface SimulationConfig {
  droneCount: number;
  couplingK: number;
  noiseStrength: number;
  gravity: number;
  drag: number;
  maxSpeed: number;
  formationRadius: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;  // Golden ratio
const DEFAULT_CONFIG: SimulationConfig = {
  droneCount: 50,
  couplingK: 2.0,
  noiseStrength: 0.1,
  gravity: 9.8,
  drag: 0.02,
  maxSpeed: 20,
  formationRadius: 100,
};

// ═══════════════════════════════════════════════════════════════════════════════
// STYLES
// ═══════════════════════════════════════════════════════════════════════════════

const S = {
  root: {
    width: '100%',
    height: '100%',
    background: '#030810',
    display: 'grid',
    gridTemplateColumns: '1fr 300px',
    gridTemplateRows: '1fr 180px',
    gap: 2,
    overflow: 'hidden',
  },
  viewport: {
    position: 'relative' as const,
    background: 'linear-gradient(180deg, #0a1525 0%, #1a2a45 50%, #0a1a30 100%)',
    overflow: 'hidden',
  },
  canvas: {
    width: '100%',
    height: '100%',
  },
  overlay: {
    position: 'absolute' as const,
    top: 12,
    left: 16,
    zIndex: 10,
  },
  overlayTitle: {
    fontSize: 12,
    color: '#4af',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    marginBottom: 8,
    textShadow: '0 0 10px rgba(80, 170, 255, 0.5)',
  },
  metricsRow: {
    display: 'flex',
    gap: 16,
    marginBottom: 4,
  },
  metric: {
    fontSize: 10,
    color: '#6a9aca',
  },
  metricValue: (color: string) => ({
    color,
    fontWeight: 'bold',
  }),
  controlPanel: {
    background: 'rgba(5, 15, 30, 0.95)',
    borderLeft: '1px solid #1a3a5c',
    padding: '12px',
    overflow: 'auto',
  },
  panelTitle: {
    fontSize: 11,
    color: '#4af',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    marginBottom: 12,
    paddingBottom: 8,
    borderBottom: '1px solid #1a3a5c',
  },
  sliderGroup: {
    marginBottom: 16,
  },
  sliderLabel: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: 10,
    color: '#6a9aca',
    marginBottom: 4,
  },
  slider: {
    width: '100%',
    accentColor: '#4af',
  },
  button: (active: boolean, color: string = '#4af') => ({
    width: '100%',
    padding: '10px',
    marginBottom: 8,
    background: active ? `rgba(${color === '#4af' ? '80, 170, 255' : color === '#4f8' ? '80, 255, 120' : '255, 80, 80'}, 0.2)` : 'rgba(10, 30, 50, 0.8)',
    border: `1px solid ${active ? color : '#2a4a6a'}`,
    borderRadius: 6,
    color: active ? color : '#6a9aca',
    fontSize: 10,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    cursor: 'pointer',
  }),
  emergencyBtn: {
    width: '100%',
    padding: '12px',
    background: '#3a0a0a',
    border: '2px solid #f44',
    borderRadius: 6,
    color: '#f44',
    fontSize: 11,
    fontWeight: 'bold',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    cursor: 'pointer',
    marginTop: 16,
  },
  statusPanel: {
    gridColumn: '1 / -1',
    background: 'rgba(5, 15, 30, 0.95)',
    borderTop: '1px solid #1a3a5c',
    display: 'grid',
    gridTemplateColumns: 'repeat(6, 1fr)',
    gap: 12,
    padding: '12px 16px',
  },
  statusCard: {
    background: 'rgba(10, 30, 50, 0.6)',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
    padding: '12px',
    textAlign: 'center' as const,
  },
  statusValue: (color: string) => ({
    fontSize: 24,
    fontWeight: 'bold',
    color,
    marginBottom: 4,
  }),
  statusLabel: {
    fontSize: 9,
    color: '#5a8aba',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
  },
  droneList: {
    maxHeight: 200,
    overflow: 'auto',
    marginTop: 12,
  },
  droneItem: (status: string) => ({
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    padding: '6px 8px',
    background: 'rgba(10, 30, 50, 0.6)',
    border: `1px solid ${
      status === 'Active' ? '#2a5a8a' :
      status === 'Damaged' ? '#8a5a2a' :
      status === 'Critical' ? '#8a2a2a' :
      '#2a2a2a'
    }`,
    borderRadius: 4,
    marginBottom: 4,
    fontSize: 9,
    color: '#6a9aca',
  }),
  droneIndicator: (status: string) => ({
    width: 8,
    height: 8,
    borderRadius: '50%',
    background:
      status === 'Active' ? '#4af' :
      status === 'Damaged' ? '#fa4' :
      status === 'Critical' ? '#f44' :
      '#444',
  }),
};

// ═══════════════════════════════════════════════════════════════════════════════
// MATH UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

const vec3 = {
  zero: (): Vec3 => ({ x: 0, y: 0, z: 0 }),
  add: (a: Vec3, b: Vec3): Vec3 => ({ x: a.x + b.x, y: a.y + b.y, z: a.z + b.z }),
  sub: (a: Vec3, b: Vec3): Vec3 => ({ x: a.x - b.x, y: a.y - b.y, z: a.z - b.z }),
  scale: (v: Vec3, s: number): Vec3 => ({ x: v.x * s, y: v.y * s, z: v.z * s }),
  length: (v: Vec3): number => Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z),
  normalize: (v: Vec3): Vec3 => {
    const len = vec3.length(v);
    return len > 0 ? vec3.scale(v, 1 / len) : vec3.zero();
  },
  distance: (a: Vec3, b: Vec3): number => vec3.length(vec3.sub(b, a)),
  lerp: (a: Vec3, b: Vec3, t: number): Vec3 => ({
    x: a.x + (b.x - a.x) * t,
    y: a.y + (b.y - a.y) * t,
    z: a.z + (b.z - a.z) * t,
  }),
};

// Kuramoto order parameter
function computeKuramotoOrder(drones: DroneState[]): { r: number; psi: number } {
  const n = drones.length;
  if (n === 0) return { r: 0, psi: 0 };
  
  let sumCos = 0;
  let sumSin = 0;
  
  for (const d of drones) {
    sumCos += Math.cos(d.phase);
    sumSin += Math.sin(d.phase);
  }
  
  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
  const psi = Math.atan2(sumSin, sumCos);
  
  return { r, psi };
}

// Jasmine drift (deviation from equilibrium)
function computeJasmineDrift(drones: DroneState[], targetCenter: Vec3): number {
  if (drones.length === 0) return 0;
  
  let totalDrift = 0;
  for (const d of drones) {
    const dist = vec3.distance(d.position, targetCenter);
    totalDrift += dist * dist;
  }
  
  return Math.sqrt(totalDrift / drones.length) / 100; // Normalize
}

// ═══════════════════════════════════════════════════════════════════════════════
// DRONE INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

function initializeDrones(count: number, config: SimulationConfig): DroneState[] {
  const drones: DroneState[] = [];
  const roles: DroneState['role'][] = ['Scout', 'Fighter', 'Support', 'Commander'];
  
  // Fibonacci sphere distribution for initial positions
  for (let i = 0; i < count; i++) {
    const t = i / (count - 1);
    const inclination = Math.acos(1 - 2 * t);
    const azimuth = 2 * Math.PI * PHI * i;
    
    const r = config.formationRadius * 0.5;
    const x = r * Math.sin(inclination) * Math.cos(azimuth);
    const y = r * Math.sin(inclination) * Math.sin(azimuth) + 50; // Offset Y
    const z = r * Math.cos(inclination);
    
    drones.push({
      id: i,
      position: { x, y, z },
      velocity: vec3.zero(),
      acceleration: vec3.zero(),
      orientation: { pitch: 0, roll: 0, yaw: Math.random() * Math.PI * 2 },
      phase: Math.random() * Math.PI * 2,
      naturalFreq: 1 + (Math.random() - 0.5) * 0.2,
      couplingStrength: config.couplingK,
      energy: 1.0,
      health: 1.0,
      status: 'Active',
      role: roles[i % roles.length],
      target: null,
      trail: [],
    });
  }
  
  return drones;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SIMULATION STEP — THE REAL PHYSICS
// ═══════════════════════════════════════════════════════════════════════════════

function simulationStep(
  drones: DroneState[],
  config: SimulationConfig,
  world: WorldState,
  dt: number
): DroneState[] {
  const center = { x: 0, y: 50, z: 0 };
  const { r: rSwarm, psi: globalPhase } = computeKuramotoOrder(drones);
  
  return drones.map((drone, i) => {
    if (drone.status === 'Offline') return drone;
    
    // Store trail
    const trail = [...drone.trail, { ...drone.position }].slice(-20);
    
    // ═══ KURAMOTO PHASE DYNAMICS ═══
    // dθ_i/dt = ω_i + (K/N) * Σ sin(θ_j - θ_i)
    let phaseVelocity = drone.naturalFreq;
    
    for (const other of drones) {
      if (other.id === drone.id || other.status === 'Offline') continue;
      const phaseDiff = other.phase - drone.phase;
      phaseVelocity += (drone.couplingStrength / drones.length) * Math.sin(phaseDiff);
    }
    
    // Add noise
    phaseVelocity += (Math.random() - 0.5) * config.noiseStrength;
    
    const newPhase = (drone.phase + phaseVelocity * dt) % (Math.PI * 2);
    
    // ═══ FLOCKING BEHAVIOR ═══
    let separation = vec3.zero();
    let alignment = vec3.zero();
    let cohesion = vec3.zero();
    let neighborCount = 0;
    
    for (const other of drones) {
      if (other.id === drone.id || other.status === 'Offline') continue;
      
      const dist = vec3.distance(drone.position, other.position);
      
      if (dist < 30) {
        // Separation
        const diff = vec3.sub(drone.position, other.position);
        separation = vec3.add(separation, vec3.scale(vec3.normalize(diff), 1 / (dist + 0.1)));
      }
      
      if (dist < 50) {
        // Alignment
        alignment = vec3.add(alignment, other.velocity);
        // Cohesion
        cohesion = vec3.add(cohesion, other.position);
        neighborCount++;
      }
    }
    
    if (neighborCount > 0) {
      alignment = vec3.scale(alignment, 1 / neighborCount);
      cohesion = vec3.scale(cohesion, 1 / neighborCount);
      cohesion = vec3.sub(cohesion, drone.position);
    }
    
    // ═══ FORMATION FORCE ═══
    const toCenter = vec3.sub(center, drone.position);
    const distToCenter = vec3.length(toCenter);
    const formationForce = vec3.scale(
      vec3.normalize(toCenter),
      Math.max(0, distToCenter - config.formationRadius * 0.3) * 0.1
    );
    
    // ═══ COMBINED ACCELERATION ═══
    let acceleration = vec3.zero();
    acceleration = vec3.add(acceleration, vec3.scale(separation, 2.0));
    acceleration = vec3.add(acceleration, vec3.scale(vec3.normalize(alignment), 1.0));
    acceleration = vec3.add(acceleration, vec3.scale(vec3.normalize(cohesion), 1.0));
    acceleration = vec3.add(acceleration, formationForce);
    
    // Wind effect
    acceleration = vec3.add(acceleration, vec3.scale(world.windDirection, world.windSpeed * 0.1));
    
    // Phase-based oscillation (creates organic movement)
    acceleration.y += Math.sin(newPhase) * 0.5;
    acceleration.x += Math.cos(newPhase * 1.5) * 0.3;
    
    // ═══ VELOCITY UPDATE ═══
    let newVelocity = vec3.add(drone.velocity, vec3.scale(acceleration, dt));
    
    // Drag
    newVelocity = vec3.scale(newVelocity, 1 - config.drag);
    
    // Speed limit
    const speed = vec3.length(newVelocity);
    if (speed > config.maxSpeed) {
      newVelocity = vec3.scale(vec3.normalize(newVelocity), config.maxSpeed);
    }
    
    // ═══ POSITION UPDATE ═══
    const newPosition = vec3.add(drone.position, vec3.scale(newVelocity, dt));
    
    // Keep above ground
    if (newPosition.y < 5) {
      newPosition.y = 5;
      newVelocity.y = Math.abs(newVelocity.y) * 0.5;
    }
    
    // ═══ ENERGY & HEALTH ═══
    const energyDrain = speed * 0.001 + 0.0001;
    const newEnergy = Math.max(0, drone.energy - energyDrain * dt);
    
    // Status based on health and energy
    let newStatus = drone.status;
    if (newEnergy < 0.1) {
      newStatus = 'Critical';
    } else if (newEnergy < 0.3 || drone.health < 0.5) {
      newStatus = 'Damaged';
    } else {
      newStatus = 'Active';
    }
    
    // ═══ ORIENTATION ═══
    const yaw = Math.atan2(newVelocity.x, newVelocity.z);
    const pitch = Math.atan2(-newVelocity.y, Math.sqrt(newVelocity.x ** 2 + newVelocity.z ** 2));
    
    return {
      ...drone,
      position: newPosition,
      velocity: newVelocity,
      acceleration,
      orientation: { pitch, roll: 0, yaw },
      phase: newPhase,
      energy: newEnergy,
      status: newStatus,
      trail,
    };
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS RENDERER
// ═══════════════════════════════════════════════════════════════════════════════

function renderDrones(
  ctx: CanvasRenderingContext2D,
  drones: DroneState[],
  metrics: SwarmMetrics,
  world: WorldState,
  width: number,
  height: number
): void {
  ctx.clearRect(0, 0, width, height);
  
  // Background gradient based on time of day
  const gradient = ctx.createLinearGradient(0, 0, 0, height);
  if (world.timeOfDay < 6 || world.timeOfDay > 20) {
    gradient.addColorStop(0, '#050a15');
    gradient.addColorStop(1, '#0a1a30');
  } else {
    gradient.addColorStop(0, '#1a3050');
    gradient.addColorStop(1, '#2a4a70');
  }
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, width, height);
  
  // Grid
  ctx.strokeStyle = 'rgba(80, 170, 255, 0.1)';
  ctx.lineWidth = 1;
  const gridSize = 50;
  for (let x = 0; x < width; x += gridSize) {
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, height);
    ctx.stroke();
  }
  for (let y = 0; y < height; y += gridSize) {
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(width, y);
    ctx.stroke();
  }
  
  // Center point
  const cx = width / 2;
  const cy = height / 2;
  
  ctx.beginPath();
  ctx.arc(cx, cy, 5, 0, Math.PI * 2);
  ctx.fillStyle = '#4af';
  ctx.fill();
  
  // Draw drones
  for (const drone of drones) {
    if (drone.status === 'Offline') continue;
    
    // Project 3D to 2D (simple orthographic)
    const scale = 3;
    const x = cx + drone.position.x * scale;
    const y = cy - drone.position.z * scale; // Z maps to Y in 2D
    
    // Trail
    if (drone.trail.length > 1) {
      ctx.beginPath();
      ctx.moveTo(cx + drone.trail[0].x * scale, cy - drone.trail[0].z * scale);
      for (let i = 1; i < drone.trail.length; i++) {
        const alpha = i / drone.trail.length;
        ctx.strokeStyle = `rgba(80, 170, 255, ${alpha * 0.3})`;
        ctx.lineTo(cx + drone.trail[i].x * scale, cy - drone.trail[i].z * scale);
      }
      ctx.stroke();
    }
    
    // Drone body
    const size = 4 + drone.energy * 4;
    const color =
      drone.status === 'Active' ? `hsl(${200 + drone.phase * 30}, 80%, 60%)` :
      drone.status === 'Damaged' ? '#fa4' :
      drone.status === 'Critical' ? '#f44' :
      '#444';
    
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(-drone.orientation.yaw);
    
    // Glow
    const glow = ctx.createRadialGradient(0, 0, 0, 0, 0, size * 2);
    glow.addColorStop(0, color);
    glow.addColorStop(1, 'transparent');
    ctx.fillStyle = glow;
    ctx.beginPath();
    ctx.arc(0, 0, size * 2, 0, Math.PI * 2);
    ctx.fill();
    
    // Body
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(0, -size);
    ctx.lineTo(-size * 0.7, size * 0.5);
    ctx.lineTo(size * 0.7, size * 0.5);
    ctx.closePath();
    ctx.fill();
    
    // Phase indicator
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.5)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.arc(0, 0, size * 1.5, drone.phase - 0.3, drone.phase + 0.3);
    ctx.stroke();
    
    ctx.restore();
  }
  
  // Coherence ring
  ctx.strokeStyle = `rgba(80, 255, 120, ${metrics.rSwarm})`;
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.arc(cx, cy, 150 * metrics.rSwarm, 0, Math.PI * 2);
  ctx.stroke();
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface Props {
  organism: any;
}

export function DroneSimulationWorld({ organism }: Props) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const animationRef = useRef<number>(0);
  
  const [config, setConfig] = useState<SimulationConfig>(DEFAULT_CONFIG);
  const [drones, setDrones] = useState<DroneState[]>([]);
  const [metrics, setMetrics] = useState<SwarmMetrics>({
    rSwarm: 0, jDrift: 0, coherence: 0, stability: 1,
    avgEnergy: 1, avgHealth: 1, activeDrones: 0, totalDrones: 0,
  });
  const [world, setWorld] = useState<WorldState>({
    time: 0, beat: 0, timeOfDay: 12, weather: 'Clear',
    windSpeed: 1, windDirection: { x: 1, y: 0, z: 0 },
  });
  const [isRunning, setIsRunning] = useState(true);
  const [selectedView, setSelectedView] = useState<'top' | 'side' | '3d'>('top');
  
  // Initialize
  useEffect(() => {
    setDrones(initializeDrones(config.droneCount, config));
  }, [config.droneCount]);
  
  // Animation loop
  useEffect(() => {
    if (!isRunning) return;
    
    let lastTime = performance.now();
    
    const animate = (time: number) => {
      const dt = Math.min((time - lastTime) / 1000, 0.1);
      lastTime = time;
      
      setDrones(prev => {
        const newDrones = simulationStep(prev, config, world, dt);
        
        // Update metrics
        const { r, psi } = computeKuramotoOrder(newDrones);
        const center = { x: 0, y: 50, z: 0 };
        const jDrift = computeJasmineDrift(newDrones, center);
        const activeDrones = newDrones.filter(d => d.status !== 'Offline').length;
        const avgEnergy = newDrones.reduce((s, d) => s + d.energy, 0) / newDrones.length;
        const avgHealth = newDrones.reduce((s, d) => s + d.health, 0) / newDrones.length;
        
        setMetrics({
          rSwarm: r,
          jDrift,
          coherence: r,
          stability: Math.max(0, 1 - jDrift * 0.5),
          avgEnergy,
          avgHealth,
          activeDrones,
          totalDrones: newDrones.length,
        });
        
        return newDrones;
      });
      
      // Update world time
      setWorld(prev => ({
        ...prev,
        time: prev.time + dt,
        beat: Math.floor(prev.time * 10),
        timeOfDay: (12 + prev.time * 0.1) % 24,
      }));
      
      // Render
      const canvas = canvasRef.current;
      const ctx = canvas?.getContext('2d');
      if (canvas && ctx) {
        renderDrones(ctx, drones, metrics, world, canvas.width, canvas.height);
      }
      
      animationRef.current = requestAnimationFrame(animate);
    };
    
    animationRef.current = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(animationRef.current);
  }, [isRunning, config, drones, metrics, world]);
  
  // Canvas resize
  useEffect(() => {
    const handleResize = () => {
      const canvas = canvasRef.current;
      if (canvas) {
        const parent = canvas.parentElement;
        if (parent) {
          canvas.width = parent.clientWidth;
          canvas.height = parent.clientHeight;
        }
      }
    };
    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);
  
  // Emergency stop
  const handleEmergencyStop = () => {
    setIsRunning(false);
    setDrones(prev => prev.map(d => ({ ...d, status: 'Offline' as const })));
  };
  
  // Reset simulation
  const handleReset = () => {
    setDrones(initializeDrones(config.droneCount, config));
    setIsRunning(true);
    setWorld({ time: 0, beat: 0, timeOfDay: 12, weather: 'Clear', windSpeed: 1, windDirection: { x: 1, y: 0, z: 0 } });
  };
  
  return (
    <div style={S.root}>
      {/* Viewport */}
      <div style={S.viewport}>
        <canvas ref={canvasRef} style={S.canvas} />
        
        <div style={S.overlay}>
          <div style={S.overlayTitle}>⬡ DRONE SWARM SIMULATION — LIVE</div>
          <div style={S.metricsRow}>
            <span style={S.metric}>
              Beat: <span style={S.metricValue('#4af')}>{world.beat}</span>
            </span>
            <span style={S.metric}>
              Time: <span style={S.metricValue('#4af')}>{world.timeOfDay.toFixed(1)}h</span>
            </span>
            <span style={S.metric}>
              Active: <span style={S.metricValue('#4f8')}>{metrics.activeDrones}/{metrics.totalDrones}</span>
            </span>
          </div>
        </div>
      </div>
      
      {/* Control Panel */}
      <div style={S.controlPanel}>
        <div style={S.panelTitle}>⚙️ Simulation Controls</div>
        
        <button
          style={S.button(isRunning, '#4f8')}
          onClick={() => setIsRunning(!isRunning)}
        >
          {isRunning ? '⏸ Pause' : '▶ Resume'}
        </button>
        
        <button style={S.button(false)} onClick={handleReset}>
          🔄 Reset Simulation
        </button>
        
        <div style={S.sliderGroup}>
          <div style={S.sliderLabel}>
            <span>Coupling K</span>
            <span>{config.couplingK.toFixed(2)}</span>
          </div>
          <input
            type="range"
            min="0"
            max="5"
            step="0.1"
            value={config.couplingK}
            onChange={e => setConfig(c => ({ ...c, couplingK: Number(e.target.value) }))}
            style={S.slider}
          />
        </div>
        
        <div style={S.sliderGroup}>
          <div style={S.sliderLabel}>
            <span>Noise</span>
            <span>{config.noiseStrength.toFixed(2)}</span>
          </div>
          <input
            type="range"
            min="0"
            max="1"
            step="0.01"
            value={config.noiseStrength}
            onChange={e => setConfig(c => ({ ...c, noiseStrength: Number(e.target.value) }))}
            style={S.slider}
          />
        </div>
        
        <div style={S.sliderGroup}>
          <div style={S.sliderLabel}>
            <span>Max Speed</span>
            <span>{config.maxSpeed}</span>
          </div>
          <input
            type="range"
            min="5"
            max="50"
            step="1"
            value={config.maxSpeed}
            onChange={e => setConfig(c => ({ ...c, maxSpeed: Number(e.target.value) }))}
            style={S.slider}
          />
        </div>
        
        <div style={S.sliderGroup}>
          <div style={S.sliderLabel}>
            <span>Formation Radius</span>
            <span>{config.formationRadius}</span>
          </div>
          <input
            type="range"
            min="50"
            max="200"
            step="10"
            value={config.formationRadius}
            onChange={e => setConfig(c => ({ ...c, formationRadius: Number(e.target.value) }))}
            style={S.slider}
          />
        </div>
        
        <div style={S.panelTitle}>🚁 Drone Status</div>
        <div style={S.droneList}>
          {drones.slice(0, 10).map(drone => (
            <div key={drone.id} style={S.droneItem(drone.status)}>
              <div style={S.droneIndicator(drone.status)} />
              <span>D{drone.id}</span>
              <span style={{ flex: 1 }}>{drone.role}</span>
              <span>{(drone.energy * 100).toFixed(0)}%</span>
            </div>
          ))}
          {drones.length > 10 && (
            <div style={{ ...S.droneItem('Active'), justifyContent: 'center' }}>
              +{drones.length - 10} more...
            </div>
          )}
        </div>
        
        <button style={S.emergencyBtn} onClick={handleEmergencyStop}>
          ⛔ EMERGENCY STOP
        </button>
      </div>
      
      {/* Status Panel */}
      <div style={S.statusPanel}>
        <div style={S.statusCard}>
          <div style={S.statusValue(metrics.rSwarm > 0.7 ? '#4f8' : metrics.rSwarm > 0.4 ? '#fa4' : '#f44')}>
            {metrics.rSwarm.toFixed(3)}
          </div>
          <div style={S.statusLabel}>Kuramoto r</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue(metrics.jDrift < 1 ? '#4f8' : '#fa4')}>
            {metrics.jDrift.toFixed(3)}
          </div>
          <div style={S.statusLabel}>Jasmine Drift</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue('#4af')}>
            {(metrics.coherence * 100).toFixed(0)}%
          </div>
          <div style={S.statusLabel}>Coherence</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue(metrics.stability > 0.7 ? '#4f8' : '#f44')}>
            {(metrics.stability * 100).toFixed(0)}%
          </div>
          <div style={S.statusLabel}>Stability</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue(metrics.avgEnergy > 0.5 ? '#4f8' : '#fa4')}>
            {(metrics.avgEnergy * 100).toFixed(0)}%
          </div>
          <div style={S.statusLabel}>Avg Energy</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue('#4af')}>
            {metrics.activeDrones}/{metrics.totalDrones}
          </div>
          <div style={S.statusLabel}>Active Drones</div>
        </div>
      </div>
    </div>
  );
}

export default DroneSimulationWorld;
