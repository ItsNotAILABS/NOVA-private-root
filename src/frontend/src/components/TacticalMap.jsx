// 3D Tactical Map — Three.js via @react-three/fiber
// PARALLAX Drone Swarm Simulation — Medina Tech 2026

import React, { useRef, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import * as THREE from 'three';

const CLASS_COLORS = {
  SCOUT:     new THREE.Color(0x00cfff),
  STRIKER:   new THREE.Color(0xff3322),
  GUARDIAN:  new THREE.Color(0x22ff88),
  RELAY:     new THREE.Color(0xffdd00),
  MEDIC:     new THREE.Color(0xff88ff),
  SOVEREIGN: new THREE.Color(0xffd700),
};

function droneColor(drone, rSwarm) {
  if (drone.sacrificed) return new THREE.Color(0x334466);
  if (rSwarm >= 0.98) return new THREE.Color(0xffd700); // OMNIS: gold
  const cort = Math.min(drone.cortisol / 2.0, 1.0);
  if (cort > 0.7) return new THREE.Color(0xff3322);     // high cortisol: red
  return CLASS_COLORS[drone.cls] || new THREE.Color(0x00cfff);
}

function DroneNode({ drone, rSwarm }) {
  const meshRef = useRef();
  const col = droneColor(drone, rSwarm);

  useFrame(() => {
    if (!meshRef.current) return;
    if (!drone.sacrificed) {
      const pulse = 0.8 + 0.2 * Math.sin(Date.now() * 0.003 + drone.phase);
      meshRef.current.scale.setScalar(pulse);
    }
    if (rSwarm >= 0.98 && !drone.sacrificed) {
      const t = Date.now() * 0.005;
      meshRef.current.scale.setScalar(1.0 + 0.3 * Math.abs(Math.sin(t + drone.id)));
    }
  });

  return (
    <group position={[drone.posX, drone.posY, drone.posZ]}>
      <mesh ref={meshRef}>
        <sphereGeometry args={[drone.id === 0 ? 1.5 : 1.0, 12, 12]} />
        <meshStandardMaterial
          color={col}
          emissive={col}
          emissiveIntensity={drone.sacrificed ? 0.05 : 0.4}
          opacity={drone.sacrificed ? 0.3 : 1.0}
          transparent={drone.sacrificed}
          roughness={0.3}
          metalness={0.6}
        />
      </mesh>
    </group>
  );
}

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
          pts.push(
            new THREE.Vector3(drones[i].posX, drones[i].posY, drones[i].posZ),
            new THREE.Vector3(drones[j].posX, drones[j].posY, drones[j].posZ)
          );
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
      <lineBasicMaterial
        color={rSwarm >= 0.98 ? 0xffd700 : 0x00aaff}
        opacity={opacity}
        transparent
      />
    </lineSegments>
  );
}

function JasmineRing({ jDrift }) {
  const meshRef = useRef();
  const stress = Math.min(jDrift / 2.0, 1.0);

  useFrame(() => {
    if (!meshRef.current) return;
    const t = Date.now() * 0.002;
    meshRef.current.material.opacity = stress > 0.3
      ? 0.2 + 0.3 * Math.abs(Math.sin(t))
      : 0.05;
    meshRef.current.rotation.y = t * 0.2;
  });

  return (
    <mesh ref={meshRef} rotation={[Math.PI / 2, 0, 0]}>
      <ringGeometry args={[58, 62, 64]} />
      <meshBasicMaterial
        color={stress > 0.5 ? 0xff2200 : 0x0066ff}
        transparent
        opacity={0.08}
        side={THREE.DoubleSide}
      />
    </mesh>
  );
}

function HexGrid() {
  const geo = useMemo(() => {
    const g = new THREE.PlaneGeometry(200, 200, 20, 20);
    return g;
  }, []);
  return (
    <mesh geometry={geo} rotation={[-Math.PI / 2, 0, 0]} position={[0, -2, 0]}>
      <meshBasicMaterial color={0x0a1a2e} wireframe opacity={0.3} transparent />
    </mesh>
  );
}

export default function TacticalMap({ swarm }) {
  const { drones, rSwarm, jDrift, swarmWeights } = swarm;

  return (
    <Canvas
      style={{ width: '100%', height: '100%' }}
      camera={{ position: [0, 80, 100], fov: 55 }}
      gl={{ antialias: true, alpha: true }}
    >
      <ambientLight intensity={0.3} />
      <directionalLight position={[50, 100, 50]} intensity={0.8} color={0x88aaff} />
      <pointLight position={[0, 20, 0]} intensity={0.5} color={0x0044ff} />

      <HexGrid />
      <FormationLines drones={drones} rSwarm={rSwarm} swarmWeights={swarmWeights} />
      <JasmineRing jDrift={jDrift} />

      {drones.map(drone => (
        <DroneNode key={drone.id} drone={drone} rSwarm={rSwarm} />
      ))}

      <OrbitControls
        enablePan
        enableZoom
        enableRotate
        minDistance={20}
        maxDistance={300}
        target={[0, 0, 0]}
      />
    </Canvas>
  );
}

