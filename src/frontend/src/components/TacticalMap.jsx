// 3D Tactical Map — Three.js via @react-three/fiber
// PARALLAX Drone Swarm Simulation — Medina Tech 2026

import React, { useRef, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import * as THREE from 'three';

// ─── NEUROCHEMICAL COLOR MAPPING ─────────────────────────────────────────────
// Color blends based on dominant excess neurochemical above sovereign floor.
// DOP=blue-cyan, COR=red, NOR=orange, OXY=magenta. At rest = class color.
const CLASS_COLORS = {
  SCOUT:     new THREE.Color(0x00cfff),
  STRIKER:   new THREE.Color(0xff3322),
  GUARDIAN:  new THREE.Color(0x22ff88),
  RELAY:     new THREE.Color(0xffdd00),
  MEDIC:     new THREE.Color(0xff88ff),
  SOVEREIGN: new THREE.Color(0xffd700),
};

const CHEM_COLS = {
  dopamine:       new THREE.Color(0x0088ff),
  cortisol:       new THREE.Color(0xff2200),
  norepinephrine: new THREE.Color(0xff8800),
  oxytocin:       new THREE.Color(0xff44ee),
};

function droneColor(drone, rSwarm) {
  if (drone.sacrificed) return new THREE.Color(0x223344);
  if (rSwarm >= 0.98) return new THREE.Color(0xffd700); // OMNIS: gold

  const excess = {
    dopamine:       drone.dopamine       - 1.0,
    cortisol:       drone.cortisol       - 1.0,
    norepinephrine: drone.norepinephrine - 1.0,
    oxytocin:       drone.oxytocin       - 1.0,
  };
  const maxExcess = Math.max(...Object.values(excess));
  if (maxExcess < 0.05) return CLASS_COLORS[drone.cls] || new THREE.Color(0x00cfff);

  const dominant = Object.keys(excess).find(k => excess[k] === maxExcess);
  const base  = CLASS_COLORS[drone.cls] || new THREE.Color(0x00cfff);
  const chemC = CHEM_COLS[dominant];
  const t = Math.min(1.0, maxExcess / 0.5); // blend factor up to 50% excess
  return new THREE.Color().lerpColors(base, chemC, t);
}

// ─── DRONE NODE ───────────────────────────────────────────────────────────────
function DroneNode({ drone, rSwarm }) {
  const meshRef  = useRef();
  const col      = droneColor(drone, rSwarm);
  // Glow ring shows energy level
  const ringRef  = useRef();

  useFrame(() => {
    if (!meshRef.current) return;
    const t = Date.now() * 0.003;
    if (!drone.sacrificed) {
      // Pulse driven by brain OUTPUT activation (node 5) and phase
      const brainOut = drone.brainActivation ? drone.brainActivation[5] : 0.5;
      const pulse = 0.75 + 0.25 * brainOut * Math.abs(Math.sin(t + drone.phase));
      meshRef.current.scale.setScalar(rSwarm >= 0.98
        ? 1.0 + 0.35 * Math.abs(Math.sin(t * 1.5 + drone.id))
        : pulse);
    }
    // Energy ring scale
    if (ringRef.current) {
      const e = drone.energy ?? 1.5;
      const energyScale = 0.6 + 0.5 * Math.min(e / 2.0, 1.0);
      ringRef.current.scale.setScalar(energyScale);
      ringRef.current.material.opacity = 0.1 + 0.15 * (e / 2.0);
    }
  });

  const energyColor = (drone.energy ?? 1.5) < 0.6 ? 0xff4400 : 0x00aaff;
  const radius = drone.id === 0 ? 1.5 : 1.0;

  return (
    <group position={[drone.posX, drone.posY, drone.posZ]}>
      <mesh ref={meshRef}>
        <sphereGeometry args={[radius, 12, 12]} />
        <meshStandardMaterial
          color={col}
          emissive={col}
          emissiveIntensity={drone.sacrificed ? 0.05 : 0.35}
          opacity={drone.sacrificed ? 0.25 : 1.0}
          transparent={drone.sacrificed}
          roughness={0.3}
          metalness={0.6}
        />
      </mesh>
      {/* Energy level ring */}
      {!drone.sacrificed && (
        <mesh ref={ringRef} rotation={[Math.PI / 2, 0, 0]}>
          <ringGeometry args={[radius + 0.3, radius + 0.6, 24]} />
          <meshBasicMaterial color={energyColor} transparent opacity={0.15} side={THREE.DoubleSide} />
        </mesh>
      )}
    </group>
  );
}

// ─── VELOCITY ARROWS ─────────────────────────────────────────────────────────
// Line segments from drone center in velocity direction, scaled by speed.
function VelocityArrows({ drones }) {
  const geo = useMemo(() => {
    const pts = [];
    for (const d of drones) {
      if (d.sacrificed) continue;
      const speed = Math.sqrt((d.velX || 0) ** 2 + (d.velZ || 0) ** 2);
      if (speed < 0.005) continue;
      const scale = 10.0;
      pts.push(new THREE.Vector3(d.posX, d.posY, d.posZ));
      pts.push(new THREE.Vector3(d.posX + d.velX * scale, d.posY, d.posZ + d.velZ * scale));
    }
    if (!pts.length) return null;
    return new THREE.BufferGeometry().setFromPoints(pts);
  }, [drones]);

  if (!geo) return null;
  return (
    <lineSegments geometry={geo}>
      <lineBasicMaterial color={0xffaa00} opacity={0.55} transparent />
    </lineSegments>
  );
}

// ─── FORMATION LINES (Hebbian weights) ───────────────────────────────────────
function FormationLines({ drones, rSwarm, swarmWeights }) {
  const lines = useMemo(() => {
    if (rSwarm < 0.90) return null;
    const pts = [];
    const n = drones.length;
    for (let i = 0; i < n; i++) {
      for (let j = i + 1; j < n; j++) {
        if (drones[i].sacrificed || drones[j].sacrificed) continue;
        const w = swarmWeights[i] ? swarmWeights[i][j] || 0 : 0;
        if (w > 0.3) {
          pts.push(new THREE.Vector3(drones[i].posX, drones[i].posY, drones[i].posZ));
          pts.push(new THREE.Vector3(drones[j].posX, drones[j].posY, drones[j].posZ));
        }
      }
    }
    if (!pts.length) return null;
    return new THREE.BufferGeometry().setFromPoints(pts);
  }, [drones, rSwarm, swarmWeights]);

  if (!lines) return null;
  const opacity = Math.max(0, (rSwarm - 0.90) / 0.1);
  return (
    <lineSegments geometry={lines}>
      <lineBasicMaterial color={rSwarm >= 0.98 ? 0xffd700 : 0x00aaff} opacity={opacity} transparent />
    </lineSegments>
  );
}

// ─── JASMINE STRESS RING ─────────────────────────────────────────────────────
function JasmineRing({ jDrift }) {
  const meshRef = useRef();
  const stress = Math.min(jDrift / 2.0, 1.0);
  useFrame(() => {
    if (!meshRef.current) return;
    const t = Date.now() * 0.002;
    meshRef.current.material.opacity = stress > 0.3 ? 0.15 + 0.25 * Math.abs(Math.sin(t)) : 0.04;
    meshRef.current.rotation.y = t * 0.2;
  });
  return (
    <mesh ref={meshRef} rotation={[Math.PI / 2, 0, 0]}>
      <ringGeometry args={[58, 63, 64]} />
      <meshBasicMaterial color={stress > 0.5 ? 0xff2200 : 0x0066ff} transparent opacity={0.06} side={THREE.DoubleSide} />
    </mesh>
  );
}

// ─── HEX GRID ─────────────────────────────────────────────────────────────────
function HexGrid() {
  const geo = useMemo(() => new THREE.PlaneGeometry(200, 200, 20, 20), []);
  return (
    <mesh geometry={geo} rotation={[-Math.PI / 2, 0, 0]} position={[0, -2, 0]}>
      <meshBasicMaterial color={0x0a1a2e} wireframe opacity={0.3} transparent />
    </mesh>
  );
}

// ─── MAIN CANVAS ──────────────────────────────────────────────────────────────
export default function TacticalMap({ swarm }) {
  const { drones, rSwarm, jDrift, swarmWeights } = swarm;
  return (
    <Canvas style={{ width: '100%', height: '100%' }} camera={{ position: [0, 80, 100], fov: 55 }} gl={{ antialias: true, alpha: true }}>
      <ambientLight intensity={0.3} />
      <directionalLight position={[50, 100, 50]} intensity={0.8} color={0x88aaff} />
      <pointLight position={[0, 20, 0]} intensity={0.5} color={0x0044ff} />

      <HexGrid />
      <VelocityArrows drones={drones} />
      <FormationLines drones={drones} rSwarm={rSwarm} swarmWeights={swarmWeights} />
      <JasmineRing jDrift={jDrift} />

      {drones.map(drone => (
        <DroneNode key={drone.id} drone={drone} rSwarm={rSwarm} />
      ))}

      <OrbitControls enablePan enableZoom enableRotate minDistance={20} maxDistance={300} target={[0, 0, 0]} />
    </Canvas>
  );
}
