// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Component: AirstripWorld — Full 3D Virtual Airstrip with 500 Parked Drones
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║      NOVA AIRSTRIP WORLD — 3D REACT/THREE.JS COMPONENT                        ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  Full 3D world containing:                                                     ║
// ║    • 500m × 30m runway with full markings and lighting                         ║
// ║    • 500 parked drones (25 cols × 20 rows) on apron                            ║
// ║    • Taxiway A with blue edge lights and yellow centerline                     ║
// ║    • Control tower (45m), hangars, maintenance building, charging stations     ║
// ║    • PAPI glidepath indicator (4 lights: 3° approach angle)                    ║
// ║    • Windsock and aerodrome beacon (AGL rotating green/white)                  ║
// ║    • Procedural terrain around the airstrip                                    ║
// ║    • Sky/stars with day/night cycle                                             ║
// ║    • Dynamic weather effects (wind, rain, fog)                                 ║
// ║    • Real-time telemetry overlays for selected drones                          ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useMemo, useState, useCallback, useEffect } from 'react';
import { Canvas, useFrame, useThree } from '@react-three/fiber';
import { OrbitControls, Sky, Stars, Text } from '@react-three/drei';
import * as THREE from 'three';

import {
  buildAirstripWorld,
  AIRSTRIP,
  type ParkingSpot,
  type AirstripStructure,
  type AirstripLight,
  type RunwaySegment,
} from '../../world/VirtualAirstrip';

import {
  type RuntimeDroneState,
  type FleetState,
  droneClassColor as getClassColor,
  droneStatusColor as getStatusColor,
} from '../../world/DroneFleet500';

import { droneClassColor } from '../../world/DroneFleetSpecs';

const π = Math.PI;
const φ = 1.6180339887498948482;

// Pre-build the static airstrip world
const AIRSTRIP_WORLD = buildAirstripWorld();

// ═══════════════════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

function hexToRgb(hex: string): THREE.Color {
  return new THREE.Color(hex);
}

function statusToEmissive(status: string): string {
  switch (status) {
    case 'Parked':         return '#001122';
    case 'Charging':       return '#001144';
    case 'PreflightCheck': return '#002244';
    case 'Cruising':       return '#002244';
    case 'Emergency':      return '#440011';
    default:               return '#001122';
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// RUNWAY SURFACE
// ═══════════════════════════════════════════════════════════════════════════════

function RunwaySurface() {
  return (
    <group>
      {/* Main runway pavement */}
      <mesh
        position={[AIRSTRIP.RUNWAY_CENTER_X, AIRSTRIP.RUNWAY_ELEVATION, AIRSTRIP.RUNWAY_CENTER_Z]}
        rotation={[-π / 2, 0, 0]}
        receiveShadow
      >
        <planeGeometry args={[AIRSTRIP.RUNWAY_LENGTH, AIRSTRIP.RUNWAY_WIDTH]} />
        <meshStandardMaterial color="#1c1c1e" roughness={0.95} metalness={0.02} />
      </mesh>

      {/* Runway centerline markings */}
      {Array.from({ length: 20 }, (_, i) => {
        const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
        const x = -halfLen + 15 + i * ((AIRSTRIP.RUNWAY_LENGTH - 30) / 20);
        return (
          <mesh
            key={`cl-${i}`}
            position={[x, AIRSTRIP.RUNWAY_ELEVATION + 0.01, 0]}
            rotation={[-π / 2, 0, 0]}
          >
            <planeGeometry args={[15, 0.9]} />
            <meshBasicMaterial color="#e8e8e8" />
          </mesh>
        );
      })}

      {/* Threshold markings — 09 west end */}
      {Array.from({ length: 8 }, (_, s) => {
        const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
        const halfW = AIRSTRIP.RUNWAY_WIDTH / 2;
        const zOff = (-4 + s + 0.5) * (AIRSTRIP.RUNWAY_WIDTH / 8);
        return (
          <mesh
            key={`thr-09-${s}`}
            position={[-halfLen + 20, AIRSTRIP.RUNWAY_ELEVATION + 0.01, zOff]}
            rotation={[-π / 2, 0, 0]}
          >
            <planeGeometry args={[30, 1.8]} />
            <meshBasicMaterial color="#e8e8e8" />
          </mesh>
        );
      })}

      {/* Threshold markings — 27 east end */}
      {Array.from({ length: 8 }, (_, s) => {
        const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
        const zOff = (-4 + s + 0.5) * (AIRSTRIP.RUNWAY_WIDTH / 8);
        return (
          <mesh
            key={`thr-27-${s}`}
            position={[halfLen - 20, AIRSTRIP.RUNWAY_ELEVATION + 0.01, zOff]}
            rotation={[-π / 2, 0, 0]}
          >
            <planeGeometry args={[30, 1.8]} />
            <meshBasicMaterial color="#e8e8e8" />
          </mesh>
        );
      })}

      {/* Aiming point markings */}
      {[[-0.6, 1], [0.6, 1], [-0.6, -1], [0.6, -1]].map(([zFrac, side], i) => {
        const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
        const halfW = AIRSTRIP.RUNWAY_WIDTH / 2;
        const x = (halfLen - 200) * (side as number);
        return (
          <mesh
            key={`aim-${i}`}
            position={[x, AIRSTRIP.RUNWAY_ELEVATION + 0.01, (zFrac as number) * halfW]}
            rotation={[-π / 2, 0, 0]}
          >
            <planeGeometry args={[45, 3]} />
            <meshBasicMaterial color="#e8e8e8" />
          </mesh>
        );
      })}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAXIWAY
// ═══════════════════════════════════════════════════════════════════════════════

function TaxiwayA() {
  return (
    <group>
      {/* Taxiway A main surface */}
      <mesh
        position={[AIRSTRIP.RUNWAY_CENTER_X, AIRSTRIP.TAXIWAY_ELEVATION, AIRSTRIP.TAXIWAY_A_Z]}
        rotation={[-π / 2, 0, 0]}
        receiveShadow
      >
        <planeGeometry args={[AIRSTRIP.TAXIWAY_A_LENGTH, AIRSTRIP.TAXIWAY_A_WIDTH]} />
        <meshStandardMaterial color="#222228" roughness={0.9} metalness={0.02} />
      </mesh>

      {/* Taxiway centerline (yellow) */}
      <mesh
        position={[AIRSTRIP.RUNWAY_CENTER_X, AIRSTRIP.TAXIWAY_ELEVATION + 0.01, AIRSTRIP.TAXIWAY_A_Z]}
        rotation={[-π / 2, 0, 0]}
      >
        <planeGeometry args={[AIRSTRIP.TAXIWAY_A_LENGTH, 0.15]} />
        <meshBasicMaterial color="#ffcc00" />
      </mesh>

      {/* Cross-taxiways (connecting runway ends to taxiway A) */}
      {[-AIRSTRIP.RUNWAY_LENGTH / 2, AIRSTRIP.RUNWAY_LENGTH / 2].map((x, i) => (
        <mesh
          key={`cross-${i}`}
          position={[x, AIRSTRIP.TAXIWAY_ELEVATION, -AIRSTRIP.RUNWAY_WIDTH / 2 - 11]}
          rotation={[-π / 2, 0, 0]}
          receiveShadow
        >
          <planeGeometry args={[AIRSTRIP.CROSS_TAXI_WIDTH, 22]} />
          <meshStandardMaterial color="#222228" roughness={0.9} metalness={0.02} />
        </mesh>
      ))}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// APRON SURFACE
// ═══════════════════════════════════════════════════════════════════════════════

function ApronSurface() {
  const apronW = AIRSTRIP.APRON_X_EAST - AIRSTRIP.APRON_X_WEST;
  const apronD = Math.abs(AIRSTRIP.APRON_Z_SOUTH - AIRSTRIP.APRON_Z_NORTH);
  const apronCenterX = (AIRSTRIP.APRON_X_EAST + AIRSTRIP.APRON_X_WEST) / 2;
  const apronCenterZ = (AIRSTRIP.APRON_Z_NORTH + AIRSTRIP.APRON_Z_SOUTH) / 2;

  return (
    <group>
      {/* Main apron */}
      <mesh
        position={[apronCenterX, AIRSTRIP.APRON_ELEVATION, apronCenterZ]}
        rotation={[-π / 2, 0, 0]}
        receiveShadow
      >
        <planeGeometry args={[apronW, apronD]} />
        <meshStandardMaterial color="#282830" roughness={0.88} metalness={0.03} />
      </mesh>

      {/* Parking spot outlines (rendered as a grid of thin rectangles) */}
      {AIRSTRIP_WORLD.parkingGrid.map(spot => (
        <mesh
          key={spot.id}
          position={[spot.position.x, AIRSTRIP.APRON_ELEVATION + 0.01, spot.position.z]}
          rotation={[-π / 2, 0, 0]}
        >
          {/* Just the outline: use a wireframe-like ring */}
          <planeGeometry args={[spot.padWidth, spot.padDepth]} />
          <meshBasicMaterial color="#1a3a5c" transparent opacity={0.6} />
        </mesh>
      ))}

      {/* Parking row aisle lanes */}
      {Array.from({ length: AIRSTRIP.PARKING_ROWS + 1 }, (_, row) => {
        const z = AIRSTRIP.PARKING_ORIGIN_Z - row * AIRSTRIP.PARKING_SPACING_Z + AIRSTRIP.PARKING_SPACING_Z / 2;
        return (
          <mesh
            key={`aisle-${row}`}
            position={[apronCenterX, AIRSTRIP.APRON_ELEVATION + 0.005, z]}
            rotation={[-π / 2, 0, 0]}
          >
            <planeGeometry args={[apronW, 0.2]} />
            <meshBasicMaterial color="#2244aa" transparent opacity={0.3} />
          </mesh>
        );
      })}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// GROUND TERRAIN — Procedural landscape outside the airstrip
// ═══════════════════════════════════════════════════════════════════════════════

function GroundTerrain() {
  const geometry = useMemo(() => {
    const size = 2000;
    const segments = 80;
    const geo = new THREE.PlaneGeometry(size, size, segments, segments);
    const positions = geo.attributes.position.array as Float32Array;

    for (let i = 0; i < positions.length; i += 3) {
      const x = positions[i];
      const z = positions[i + 1];

      // Skip airstrip area (flat)
      const inRunway = Math.abs(x) < 320 && Math.abs(z) < 200;
      if (inRunway) {
        positions[i + 2] = 0;
        continue;
      }

      // Procedural terrain
      let h = 0;
      h += Math.sin(x * 0.008 * φ) * Math.cos(z * 0.006 / φ) * 8;
      h += Math.sin(x * 0.02) * Math.cos(z * 0.015) * 3;
      h += Math.sin(x * 0.05) * Math.cos(z * 0.04) * 1;
      positions[i + 2] = h;
    }

    geo.computeVertexNormals();
    return geo;
  }, []);

  return (
    <mesh geometry={geometry} rotation={[-π / 2, 0, 0]} receiveShadow position={[0, -0.1, 0]}>
      <meshStandardMaterial
        color="#2a4a2a"
        roughness={0.95}
        metalness={0.0}
      />
    </mesh>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONTROL TOWER
// ═══════════════════════════════════════════════════════════════════════════════

function ControlTower() {
  const beaconRef = useRef<THREE.PointLight>(null);

  useFrame(({ clock }) => {
    if (!beaconRef.current) return;
    const t = clock.getElapsedTime();
    // Rotating beacon: 2 flashes per revolution (green + white)
    const phase = (t % 3) / 3; // 3-second cycle
    beaconRef.current.intensity = phase < 0.15 ? 20 : phase < 0.45 ? 0 : phase < 0.6 ? 15 : 0;
    beaconRef.current.color.set(phase < 0.15 ? '#00ff44' : '#ffffff');
  });

  return (
    <group position={[AIRSTRIP.TOWER_X, 0, AIRSTRIP.TOWER_Z]}>
      {/* Tower base */}
      <mesh
        position={[0, AIRSTRIP.TOWER_HEIGHT / 2, 0]}
        castShadow
      >
        <boxGeometry args={[AIRSTRIP.TOWER_WIDTH, AIRSTRIP.TOWER_HEIGHT, AIRSTRIP.TOWER_DEPTH]} />
        <meshStandardMaterial color="#b8bcc2" roughness={0.5} metalness={0.3} />
      </mesh>

      {/* Tower cab (glass top) */}
      <mesh
        position={[0, AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT / 2, 0]}
        castShadow
      >
        <boxGeometry args={[AIRSTRIP.TOWER_CAB_WIDTH, AIRSTRIP.TOWER_CAB_HEIGHT, AIRSTRIP.TOWER_CAB_WIDTH]} />
        <meshStandardMaterial
          color="#88aabb"
          roughness={0.1}
          metalness={0.5}
          transparent
          opacity={0.75}
          emissive="#112233"
          emissiveIntensity={0.5}
        />
      </mesh>

      {/* Roof */}
      <mesh position={[0, AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT + 0.3, 0]}>
        <boxGeometry args={[AIRSTRIP.TOWER_CAB_WIDTH + 2, 0.6, AIRSTRIP.TOWER_CAB_WIDTH + 2]} />
        <meshStandardMaterial color="#445566" roughness={0.7} metalness={0.2} />
      </mesh>

      {/* Beacon antenna */}
      <mesh position={[0, AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT + 3, 0]}>
        <cylinderGeometry args={[0.08, 0.12, 4, 8]} />
        <meshStandardMaterial color="#888888" metalness={0.8} roughness={0.2} />
      </mesh>

      {/* Aerodrome rotating beacon */}
      <pointLight
        ref={beaconRef}
        position={[0, AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT + 5, 0]}
        color="#00ff44"
        intensity={15}
        distance={8000}
      />

      {/* Obstruction light (red, solid) */}
      <pointLight
        position={[0, AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT + 2, 0]}
        color="#ff2200"
        intensity={4}
        distance={3000}
      />

      {/* Interior lighting glow */}
      <pointLight
        position={[0, AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT / 2, 0]}
        color="#aaccff"
        intensity={1.5}
        distance={40}
      />
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// HANGARS
// ═══════════════════════════════════════════════════════════════════════════════

function Hangars() {
  const hangarPositions = [-150, 0, 150];
  const apronSouth = AIRSTRIP.APRON_Z_SOUTH;

  return (
    <group>
      {hangarPositions.map((xOff, i) => (
        <group key={`hangar-${i}`} position={[xOff, 0, apronSouth + 40]}>
          {/* Hangar walls */}
          <mesh position={[0, 12, 0]} castShadow receiveShadow>
            <boxGeometry args={[80, 24, 60]} />
            <meshStandardMaterial color="#5a6e80" roughness={0.7} metalness={0.3} />
          </mesh>
          {/* Hangar roof (slightly darker) */}
          <mesh position={[0, 24.4, 0]}>
            <boxGeometry args={[82, 0.8, 62]} />
            <meshStandardMaterial color="#3a4a56" roughness={0.8} metalness={0.2} />
          </mesh>
          {/* Interior light */}
          <pointLight position={[0, 10, 0]} color="#ffffcc" intensity={2} distance={50} />
        </group>
      ))}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAINTENANCE BUILDING
// ═══════════════════════════════════════════════════════════════════════════════

function MaintenanceBuilding() {
  return (
    <group position={[180, 0, AIRSTRIP.APRON_Z_SOUTH + 60]}>
      <mesh position={[0, 8, 0]} castShadow receiveShadow>
        <boxGeometry args={[60, 16, 40]} />
        <meshStandardMaterial color="#6a7888" roughness={0.7} metalness={0.25} />
      </mesh>
      <mesh position={[0, 16.4, 0]}>
        <boxGeometry args={[62, 0.8, 42]} />
        <meshStandardMaterial color="#4a5562" roughness={0.8} metalness={0.2} />
      </mesh>
      <pointLight position={[0, 14, 0]} color="#ffeecc" intensity={1.5} distance={40} />
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CHARGING STATIONS — Row of 10 charging kiosks
// ═══════════════════════════════════════════════════════════════════════════════

function ChargingStations() {
  return (
    <group>
      {Array.from({ length: 10 }, (_, c) => {
        const x = AIRSTRIP.PARKING_ORIGIN_X + c * 48;
        const z = AIRSTRIP.APRON_Z_NORTH - 10;
        return (
          <group key={`chg-${c}`} position={[x, 0, z]}>
            {/* Kiosk body */}
            <mesh position={[0, 1.5, 0]} castShadow>
              <boxGeometry args={[4, 3, 2]} />
              <meshStandardMaterial color="#1a3a66" roughness={0.4} metalness={0.5} />
            </mesh>
            {/* Status LED glow */}
            <pointLight position={[0, 2.5, 0]} color="#0066ff" intensity={0.8} distance={15} />
            {/* Charging pad on ground */}
            <mesh position={[0, 0.02, 4]} rotation={[-π / 2, 0, 0]}>
              <circleGeometry args={[2.5, 16]} />
              <meshStandardMaterial
                color="#112244"
                emissive="#0033aa"
                emissiveIntensity={0.4}
                roughness={0.3}
              />
            </mesh>
          </group>
        );
      })}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// RUNWAY LIGHTS
// ═══════════════════════════════════════════════════════════════════════════════

function RunwayLights({ isNight }: { isNight: boolean }) {
  if (!isNight) return null;

  const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
  const halfWidth = AIRSTRIP.RUNWAY_WIDTH / 2;
  const spacing = AIRSTRIP.RUNWAY_LIGHT_SPACING;
  const count = Math.ceil(AIRSTRIP.RUNWAY_LENGTH / spacing) + 1;

  return (
    <group>
      {/* Edge lights — white */}
      {Array.from({ length: count }, (_, i) => {
        const x = -halfLen + i * spacing;
        return (
          <React.Fragment key={`rwy-edge-${i}`}>
            <pointLight
              position={[x, AIRSTRIP.RUNWAY_ELEVATION + 0.2, -halfWidth - 1.5]}
              color="#ffffff"
              intensity={1.5}
              distance={80}
            />
            <pointLight
              position={[x, AIRSTRIP.RUNWAY_ELEVATION + 0.2, halfWidth + 1.5]}
              color="#ffffff"
              intensity={1.5}
              distance={80}
            />
          </React.Fragment>
        );
      })}

      {/* Threshold lights — green (09) and red (27) */}
      {Array.from({ length: 6 }, (_, i) => {
        const z = -halfWidth + i * (AIRSTRIP.RUNWAY_WIDTH / 5);
        return (
          <React.Fragment key={`rwy-thr-${i}`}>
            <pointLight
              position={[-halfLen - 2, AIRSTRIP.RUNWAY_ELEVATION + 0.3, z]}
              color="#00ff44"
              intensity={2.5}
              distance={150}
            />
            <pointLight
              position={[halfLen + 2, AIRSTRIP.RUNWAY_ELEVATION + 0.3, z]}
              color="#ff2200"
              intensity={2.5}
              distance={150}
            />
          </React.Fragment>
        );
      })}

      {/* PAPI lights (09 approach) */}
      {Array.from({ length: 4 }, (_, p) => (
        <pointLight
          key={`papi-${p}`}
          position={[
            -halfLen + AIRSTRIP.PAPI_OFFSET_X + p * 2.5,
            AIRSTRIP.RUNWAY_ELEVATION + 0.8,
            -AIRSTRIP.PAPI_OFFSET_Z,
          ]}
          color={p < 2 ? '#ff2200' : '#ffffff'}
          intensity={8}
          distance={4000}
        />
      ))}

      {/* Taxiway A edge lights — blue */}
      {Array.from({ length: 18 }, (_, i) => {
        const x = -AIRSTRIP.TAXIWAY_A_LENGTH / 2 + i * 30;
        return (
          <React.Fragment key={`twy-edge-${i}`}>
            <pointLight
              position={[x, AIRSTRIP.TAXIWAY_ELEVATION + 0.1, AIRSTRIP.TAXIWAY_A_Z - 8]}
              color="#0055ff"
              intensity={0.8}
              distance={40}
            />
            <pointLight
              position={[x, AIRSTRIP.TAXIWAY_ELEVATION + 0.1, AIRSTRIP.TAXIWAY_A_Z + 8]}
              color="#0055ff"
              intensity={0.8}
              distance={40}
            />
          </React.Fragment>
        );
      })}

      {/* Apron flood lights */}
      {Array.from({ length: 6 }, (_, i) => {
        const x = AIRSTRIP.APRON_X_WEST + (i + 0.5) * (AIRSTRIP.APRON_X_EAST - AIRSTRIP.APRON_X_WEST) / 6;
        return (
          <React.Fragment key={`apron-flood-${i}`}>
            <pointLight
              position={[x, 22, AIRSTRIP.APRON_Z_NORTH - 50]}
              color="#ffffcc"
              intensity={6}
              distance={120}
            />
            <pointLight
              position={[x, 22, AIRSTRIP.APRON_Z_SOUTH + 100]}
              color="#ffffcc"
              intensity={6}
              distance={120}
            />
          </React.Fragment>
        );
      })}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// WINDSOCK
// ═══════════════════════════════════════════════════════════════════════════════

function WindSock({ windDirection }: { windDirection: { x: number; z: number } }) {
  const sockRef = useRef<THREE.Group>(null);

  useFrame(({ clock }) => {
    if (!sockRef.current) return;
    const t = clock.getElapsedTime();
    const angle = Math.atan2(windDirection.x, windDirection.z);
    sockRef.current.rotation.y = angle + Math.sin(t * 3) * 0.1;
  });

  return (
    <group position={[AIRSTRIP.WINDSOCK_X, 0, AIRSTRIP.WINDSOCK_Z]}>
      {/* Pole */}
      <mesh position={[0, AIRSTRIP.WINDSOCK_POLE_HEIGHT / 2, 0]}>
        <cylinderGeometry args={[0.08, 0.12, AIRSTRIP.WINDSOCK_POLE_HEIGHT, 8]} />
        <meshStandardMaterial color="#888888" metalness={0.8} roughness={0.2} />
      </mesh>
      {/* Sock */}
      <group ref={sockRef} position={[0, AIRSTRIP.WINDSOCK_POLE_HEIGHT, 0]}>
        <mesh position={[2, 0, 0]} rotation={[0, 0, -π / 2]}>
          <coneGeometry args={[0.6, 4, 12, 1, true]} />
          <meshStandardMaterial
            color="#ff6600"
            side={THREE.DoubleSide}
            transparent
            opacity={0.85}
          />
        </mesh>
      </group>
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// PARKED DRONE — Single drone unit at parking spot
// ═══════════════════════════════════════════════════════════════════════════════

interface ParkedDroneProps {
  spot: ParkingSpot;
  drone: RuntimeDroneState;
  isSelected: boolean;
  onClick: () => void;
}

function ParkedDrone({ spot, drone, isSelected, onClick }: ParkedDroneProps) {
  const meshRef = useRef<THREE.Mesh>(null);
  const glowRef = useRef<THREE.PointLight>(null);

  const classColor = droneClassColor(drone.spec.droneClass);
  const statusColor = getStatusColor(drone.status);

  useFrame(({ clock }) => {
    if (!glowRef.current) return;
    const t = clock.getElapsedTime();

    // Pulse glow based on status
    if (drone.status === 'Charging') {
      glowRef.current.intensity = 0.3 + 0.2 * Math.sin(t * 2 + drone.id * 0.1);
      glowRef.current.color.set('#0044ff');
    } else if (drone.status === 'PreflightCheck') {
      glowRef.current.intensity = 0.5 + 0.4 * Math.sin(t * 5);
      glowRef.current.color.set('#44ff88');
    } else if (isSelected) {
      glowRef.current.intensity = 0.6 + 0.3 * Math.sin(t * 3);
      glowRef.current.color.set('#ffffff');
    } else {
      glowRef.current.intensity = 0.15;
      glowRef.current.color.set(classColor);
    }
  });

  // Drone body size depends on class
  const droneScale = drone.spec.droneClass === 'Commander' ? 1.4
    : drone.spec.droneClass === 'Heavy' ? 2.2
    : drone.spec.droneClass === 'Support' ? 1.0
    : 0.8;

  const bodyColor = isSelected ? '#ffffff' : classColor;

  return (
    <group
      position={[spot.position.x, spot.position.y + 0.1, spot.position.z]}
      onClick={onClick}
    >
      {/* Drone body — octahedron (stylized multirotor) */}
      <mesh ref={meshRef} scale={droneScale} castShadow>
        <octahedronGeometry args={[0.6, 0]} />
        <meshStandardMaterial
          color={bodyColor}
          emissive={statusToEmissive(drone.status)}
          emissiveIntensity={0.6}
          metalness={0.7}
          roughness={0.3}
        />
      </mesh>

      {/* Propeller arms (small boxes) */}
      {[0, 1, 2, 3].map(arm => {
        const angle = (arm / 4) * Math.PI * 2;
        const armLen = droneScale * 0.8;
        return (
          <mesh
            key={arm}
            position={[
              Math.cos(angle) * armLen * 0.6,
              0,
              Math.sin(angle) * armLen * 0.6,
            ]}
            scale={droneScale}
          >
            <sphereGeometry args={[0.18, 6, 6]} />
            <meshStandardMaterial
              color={classColor}
              emissive={classColor}
              emissiveIntensity={0.3}
              metalness={0.6}
              roughness={0.4}
            />
          </mesh>
        );
      })}

      {/* Status glow */}
      <pointLight
        ref={glowRef}
        position={[0, 0.8, 0]}
        color={classColor}
        intensity={0.15}
        distance={6}
      />

      {/* Charging pad indicator */}
      {(drone.status === 'Charging' || drone.status === 'Parked') && (
        <mesh position={[0, -0.08, 0]} rotation={[-π / 2, 0, 0]}>
          <circleGeometry args={[spot.padWidth / 2, 12]} />
          <meshBasicMaterial
            color={drone.status === 'Charging' ? '#0033aa' : '#112244'}
            transparent
            opacity={0.5}
          />
        </mesh>
      )}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// AIRBORNE DRONE — Flying drone with trail
// ═══════════════════════════════════════════════════════════════════════════════

interface AirborneDroneProps {
  drone: RuntimeDroneState;
  isSelected: boolean;
  onClick: () => void;
}

function AirborneDrone({ drone, isSelected, onClick }: AirborneDroneProps) {
  const meshRef = useRef<THREE.Group>(null);
  const classColor = droneClassColor(drone.spec.droneClass);

  useFrame(() => {
    if (!meshRef.current) return;
    meshRef.current.position.set(drone.position.x, drone.position.y, drone.position.z);
    meshRef.current.rotation.set(drone.orientation.pitch, drone.orientation.yaw, drone.orientation.roll);
  });

  const trailPoints = useMemo(() => {
    if (drone.trail.length < 2) return null;
    const points = drone.trail.map(p => new THREE.Vector3(p.x, p.y, p.z));
    const curve = new THREE.CatmullRomCurve3(points);
    return curve.getPoints(Math.min(drone.trail.length * 2, 80));
  }, [drone.trail]);

  const trailGeometry = useMemo(() => {
    if (!trailPoints || trailPoints.length < 2) return null;
    const geo = new THREE.BufferGeometry().setFromPoints(trailPoints);
    return geo;
  }, [trailPoints]);

  return (
    <group>
      {/* Trail line */}
      {trailGeometry && (
        <line geometry={trailGeometry}>
          <lineBasicMaterial
            color={classColor}
            transparent
            opacity={0.25}
            linewidth={1}
          />
        </line>
      )}

      {/* Drone mesh */}
      <group ref={meshRef} onClick={onClick}>
        <mesh castShadow>
          <octahedronGeometry args={[0.4, 0]} />
          <meshStandardMaterial
            color={isSelected ? '#ffffff' : classColor}
            emissive={classColor}
            emissiveIntensity={isSelected ? 0.8 : 0.4}
            metalness={0.6}
            roughness={0.3}
          />
        </mesh>

        {/* Thrust glow */}
        <pointLight
          color={classColor}
          intensity={drone.throttle * 1.5}
          distance={8}
        />
      </group>
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// PERIMETER FENCE
// ═══════════════════════════════════════════════════════════════════════════════

function PerimeterFence() {
  const fenceSegments = useMemo(() => {
    const segs = [];
    const corners = [
      [-310, -320], [310, -320],
      [310, 170], [-310, 170],
    ];
    for (let i = 0; i < corners.length; i++) {
      const [x1, z1] = corners[i];
      const [x2, z2] = corners[(i + 1) % corners.length];
      const midX = (x1 + x2) / 2;
      const midZ = (z1 + z2) / 2;
      const len = Math.sqrt((x2 - x1) ** 2 + (z2 - z1) ** 2);
      const angle = Math.atan2(z2 - z1, x2 - x1);
      segs.push({ midX, midZ, len, angle });
    }
    return segs;
  }, []);

  return (
    <group>
      {fenceSegments.map((seg, i) => (
        <mesh
          key={i}
          position={[seg.midX, 1.5, seg.midZ]}
          rotation={[0, -seg.angle, 0]}
        >
          <boxGeometry args={[seg.len, 3, 0.2]} />
          <meshStandardMaterial
            color="#334455"
            roughness={0.8}
            metalness={0.3}
            transparent
            opacity={0.7}
          />
        </mesh>
      ))}
    </group>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// WORLD SCENE — Assembles all elements
// ═══════════════════════════════════════════════════════════════════════════════

interface WorldSceneProps {
  fleetState: FleetState;
  selectedDroneId: number | null;
  onDroneClick: (id: number) => void;
  showParked: boolean;
  showAirborne: boolean;
  isNight: boolean;
}

function WorldScene({
  fleetState,
  selectedDroneId,
  onDroneClick,
  showParked,
  showAirborne,
  isNight,
}: WorldSceneProps) {
  const timeOfDay = fleetState.timeOfDay;
  const sunAngle = (timeOfDay / 24) * Math.PI * 2 - Math.PI / 2;
  const sunPosition: [number, number, number] = [
    Math.cos(sunAngle) * 800,
    Math.sin(sunAngle) * 800,
    -200,
  ];

  const sunIntensity = Math.max(0, Math.sin(sunAngle + Math.PI / 2)) * 1.8;
  const ambientIntensity = Math.max(0.05, sunIntensity * 0.25);

  const parkedDrones = fleetState.drones.filter(d =>
    d.status === 'Parked' || d.status === 'Charging' || d.status === 'PreflightCheck'
  );
  const airborneDrones = fleetState.drones.filter(d =>
    !['Parked', 'Charging', 'PreflightCheck', 'Maintenance', 'Offline'].includes(d.status)
  );

  return (
    <>
      {/* Lighting */}
      <ambientLight intensity={ambientIntensity} color="#c0d8ff" />
      <directionalLight
        position={sunPosition}
        intensity={sunIntensity}
        castShadow
        shadow-mapSize={[2048, 2048]}
        shadow-camera-far={1500}
        shadow-camera-left={-600}
        shadow-camera-right={600}
        shadow-camera-top={600}
        shadow-camera-bottom={-600}
        color="#fffaee"
      />

      {/* Sky */}
      {isNight ? (
        <Stars radius={1000} depth={80} count={8000} factor={5} saturation={0} fade />
      ) : (
        <Sky
          sunPosition={sunPosition}
          turbidity={6}
          rayleigh={1.5}
          mieCoefficient={0.004}
          mieDirectionalG={0.85}
        />
      )}

      {/* Ground terrain */}
      <GroundTerrain />

      {/* Runway */}
      <RunwaySurface />

      {/* Taxiway */}
      <TaxiwayA />

      {/* Apron */}
      <ApronSurface />

      {/* Control tower */}
      <ControlTower />

      {/* Hangars */}
      <Hangars />

      {/* Maintenance building */}
      <MaintenanceBuilding />

      {/* Charging stations */}
      <ChargingStations />

      {/* Windsock */}
      <WindSock windDirection={fleetState.windDirection} />

      {/* Perimeter fence */}
      <PerimeterFence />

      {/* Runway and apron lighting */}
      <RunwayLights isNight={isNight} />

      {/* 500 parked drones */}
      {showParked && parkedDrones.map(drone => (
        <ParkedDrone
          key={drone.id}
          spot={AIRSTRIP_WORLD.parkingGrid[drone.id]}
          drone={drone}
          isSelected={selectedDroneId === drone.id}
          onClick={() => onDroneClick(drone.id)}
        />
      ))}

      {/* Airborne drones */}
      {showAirborne && airborneDrones.map(drone => (
        <AirborneDrone
          key={drone.id}
          drone={drone}
          isSelected={selectedDroneId === drone.id}
          onClick={() => onDroneClick(drone.id)}
        />
      ))}

      {/* Camera controls */}
      <OrbitControls
        enablePan
        enableZoom
        enableRotate
        minDistance={10}
        maxDistance={2000}
        maxPolarAngle={Math.PI / 2 - 0.01}
        target={[0, 0, -100]}
      />
    </>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// DRONE DETAIL PANEL — Overlay showing selected drone telemetry
// ═══════════════════════════════════════════════════════════════════════════════

interface DroneDetailPanelProps {
  drone: RuntimeDroneState | null;
  onClose: () => void;
}

const S = {
  detailPanel: {
    position: 'absolute' as const,
    top: 60,
    right: 16,
    width: 280,
    background: 'rgba(5, 12, 25, 0.95)',
    border: '1px solid #1a4a8a',
    borderRadius: 8,
    padding: '12px',
    zIndex: 20,
    fontFamily: 'monospace',
  },
  panelHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
    paddingBottom: 8,
    borderBottom: '1px solid #1a4a8a',
  },
  callSign: {
    fontSize: 13,
    color: '#00d4ff',
    fontWeight: 'bold',
    letterSpacing: '0.08em',
  },
  closeBtn: {
    background: 'none',
    border: '1px solid #4a6a8a',
    color: '#8aaacc',
    borderRadius: 4,
    padding: '2px 6px',
    cursor: 'pointer',
    fontSize: 10,
  },
  row: {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: 5,
    fontSize: 10,
  },
  label: {
    color: '#6a9aca',
  },
  value: (color: string) => ({
    color,
    fontWeight: 'bold' as const,
  }),
  batteryBar: (pct: number) => ({
    height: 6,
    borderRadius: 3,
    background: `linear-gradient(to right, ${pct > 0.5 ? '#00ff88' : pct > 0.2 ? '#ffaa00' : '#ff2244'} ${pct * 100}%, #1a2a3a ${pct * 100}%)`,
    marginTop: 4,
    marginBottom: 8,
  }),
  healthBar: (pct: number) => ({
    height: 6,
    borderRadius: 3,
    background: `linear-gradient(to right, ${pct > 0.7 ? '#00d4ff' : '#ff6600'} ${pct * 100}%, #1a2a3a ${pct * 100}%)`,
    marginTop: 4,
    marginBottom: 8,
  }),
};

function DroneDetailPanel({ drone, onClose }: DroneDetailPanelProps) {
  if (!drone) return null;

  const classColor = droneClassColor(drone.spec.droneClass);
  const speed = Math.sqrt(drone.velocity.x ** 2 + drone.velocity.y ** 2 + drone.velocity.z ** 2);
  const headingDeg = ((drone.orientation.yaw * 180) / Math.PI + 360) % 360;

  return (
    <div style={S.detailPanel}>
      <div style={S.panelHeader}>
        <span style={{ ...S.callSign, color: classColor }}>{drone.spec.callSign}</span>
        <button style={S.closeBtn} onClick={onClose}>✕</button>
      </div>

      <div style={S.row}>
        <span style={S.label}>Class</span>
        <span style={S.value(classColor)}>{drone.spec.droneClass}</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Model</span>
        <span style={S.value('#aaaaaa')}>{drone.spec.airframe.model}</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Status</span>
        <span style={S.value(getStatusColor(drone.status))}>{drone.status}</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Mission</span>
        <span style={S.value('#dddddd')}>{drone.mission}</span>
      </div>

      <div style={{ marginTop: 8, marginBottom: 4, fontSize: 9, color: '#4a8aca' }}>
        NAVIGATION
      </div>
      <div style={S.row}>
        <span style={S.label}>Position</span>
        <span style={S.value('#dddddd')}>
          {drone.position.x.toFixed(0)}, {drone.position.y.toFixed(0)}, {drone.position.z.toFixed(0)}
        </span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Speed</span>
        <span style={S.value('#00d4ff')}>{(speed * 3.6).toFixed(1)} km/h</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Heading</span>
        <span style={S.value('#dddddd')}>{headingDeg.toFixed(0)}°</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Alt AGL</span>
        <span style={S.value('#dddddd')}>{drone.altitudeAGL.toFixed(1)} m</span>
      </div>

      <div style={{ marginTop: 8, marginBottom: 4, fontSize: 9, color: '#4a8aca' }}>
        POWER & HEALTH
      </div>
      <div style={S.row}>
        <span style={S.label}>Battery</span>
        <span style={S.value(drone.batterySoC > 0.5 ? '#00ff88' : drone.batterySoC > 0.2 ? '#ffaa00' : '#ff2244')}>
          {(drone.batterySoC * 100).toFixed(0)}%
        </span>
      </div>
      <div style={S.batteryBar(drone.batterySoC)} />

      <div style={S.row}>
        <span style={S.label}>Health</span>
        <span style={S.value(drone.health > 0.7 ? '#00d4ff' : '#ff6600')}>
          {(drone.health * 100).toFixed(0)}%
        </span>
      </div>
      <div style={S.healthBar(drone.health)} />

      <div style={S.row}>
        <span style={S.label}>Power Draw</span>
        <span style={S.value('#dddddd')}>{drone.powerDrawW.toFixed(0)} W</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Batt Temp</span>
        <span style={S.value(drone.batteryTempC > 50 ? '#ff6600' : '#dddddd')}>{drone.batteryTempC.toFixed(1)}°C</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Motor Temp</span>
        <span style={S.value(drone.motorTempC > 75 ? '#ff6600' : '#dddddd')}>{drone.motorTempC.toFixed(1)}°C</span>
      </div>

      <div style={{ marginTop: 8, marginBottom: 4, fontSize: 9, color: '#4a8aca' }}>
        COMMS & SENSORS
      </div>
      <div style={S.row}>
        <span style={S.label}>Signal</span>
        <span style={S.value(drone.signalQuality > 0.6 ? '#00ff88' : '#ff6600')}>
          {(drone.signalQuality * 100).toFixed(0)}%
        </span>
      </div>
      <div style={S.row}>
        <span style={S.label}>GPS Fix</span>
        <span style={S.value('#dddddd')}>
          {['None', '2D Fix', '3D Fix', 'RTK'][drone.gpsFixQuality] || 'Unknown'}
        </span>
      </div>
      <div style={S.row}>
        <span style={S.label}>CPU</span>
        <span style={S.value('#dddddd')}>{drone.cpuUtilPct.toFixed(0)}%</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Sortie</span>
        <span style={S.value('#dddddd')}>#{drone.sortieCount} — {(drone.sortieTimeS / 60).toFixed(1)} min</span>
      </div>
      <div style={S.row}>
        <span style={S.label}>Serial</span>
        <span style={{ color: '#445566', fontSize: 9 }}>{drone.spec.serialNumber}</span>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLEET STATS BAR — Top status bar
// ═══════════════════════════════════════════════════════════════════════════════

function FleetStatsBar({ fleetState }: { fleetState: FleetState }) {
  const { stats } = fleetState;
  const timeStr = `${String(Math.floor(fleetState.timeOfDay)).padStart(2, '0')}:${String(Math.floor((fleetState.timeOfDay % 1) * 60)).padStart(2, '0')}`;

  return (
    <div style={{
      position: 'absolute',
      top: 0,
      left: 0,
      right: 0,
      padding: '6px 16px',
      background: 'rgba(3, 8, 16, 0.9)',
      borderBottom: '1px solid #1a4a8a',
      display: 'flex',
      gap: 20,
      alignItems: 'center',
      fontSize: 10,
      fontFamily: 'monospace',
      zIndex: 15,
    }}>
      <span style={{ color: '#00d4ff', fontWeight: 'bold', letterSpacing: '0.12em', marginRight: 8 }}>
        ⬡ NOVA AIRSTRIP — {timeStr}
      </span>
      <span style={{ color: '#6a9aca' }}>
        TOTAL: <strong style={{ color: '#ffffff' }}>{stats.totalDrones}</strong>
      </span>
      <span style={{ color: '#6a9aca' }}>
        PARKED: <strong style={{ color: '#445566' }}>{stats.parked + stats.charging}</strong>
      </span>
      <span style={{ color: '#6a9aca' }}>
        AIRBORNE: <strong style={{ color: '#00ff88' }}>{stats.airborne}</strong>
      </span>
      <span style={{ color: '#6a9aca' }}>
        PREFLIGHT: <strong style={{ color: '#44ff88' }}>{stats.preflight}</strong>
      </span>
      <span style={{ color: '#6a9aca' }}>
        TAXI: <strong style={{ color: '#88aaff' }}>{stats.taxiing}</strong>
      </span>
      {stats.emergency > 0 && (
        <span style={{ color: '#ff2244', fontWeight: 'bold', animation: 'pulse 1s infinite' }}>
          ⚠ EMERGENCY: {stats.emergency}
        </span>
      )}
      <span style={{ color: '#6a9aca', marginLeft: 'auto' }}>
        Coherence: <strong style={{ color: fleetState.rSwarm > 0.7 ? '#00ff88' : '#ffaa00' }}>
          {(fleetState.rSwarm * 100).toFixed(0)}%
        </strong>
      </span>
      <span style={{ color: '#6a9aca' }}>
        Batt: <strong style={{ color: '#dddddd' }}>{(stats.avgBatterySoC * 100).toFixed(0)}%</strong>
      </span>
      <span style={{ color: '#6a9aca' }}>
        Wind: <strong style={{ color: '#aaddff' }}>{fleetState.windSpeedMs.toFixed(1)} m/s</strong>
      </span>
      <span style={{ color: '#6a9aca' }}>
        {fleetState.weather}
      </span>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT — AirstripWorld
// ═══════════════════════════════════════════════════════════════════════════════

interface AirstripWorldProps {
  fleetState: FleetState;
  onDroneSelect?: (droneId: number) => void;
}

export default function AirstripWorld({ fleetState, onDroneSelect }: AirstripWorldProps) {
  const [selectedDroneId, setSelectedDroneId] = useState<number | null>(null);
  const [showParked, setShowParked] = useState(true);
  const [showAirborne, setShowAirborne] = useState(true);
  const [cameraPreset, setCameraPreset] = useState<'overview' | 'runway' | 'apron' | 'tower'>('overview');

  const isNight = fleetState.timeOfDay < 6 || fleetState.timeOfDay > 20;

  const handleDroneClick = useCallback((id: number) => {
    setSelectedDroneId(id);
    onDroneSelect?.(id);
  }, [onDroneSelect]);

  const selectedDrone = selectedDroneId !== null
    ? fleetState.drones[selectedDroneId] ?? null
    : null;

  const cameraPositions: Record<string, { position: [number, number, number]; target: [number, number, number] }> = {
    overview: { position: [0, 400, 300], target: [0, 0, -80] },
    runway:   { position: [0, 80, 200], target: [0, 5, 0] },
    apron:    { position: [0, 150, -50], target: [0, 5, -150] },
    tower:    { position: [AIRSTRIP.TOWER_X + 60, AIRSTRIP.TOWER_HEIGHT + 20, AIRSTRIP.TOWER_Z], target: [0, 5, 0] },
  };

  const cam = cameraPositions[cameraPreset];

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', background: '#030810' }}>
      {/* Stats bar */}
      <FleetStatsBar fleetState={fleetState} />

      {/* Camera preset buttons */}
      <div style={{
        position: 'absolute',
        top: 36,
        left: 16,
        display: 'flex',
        gap: 6,
        zIndex: 15,
      }}>
        {(['overview', 'runway', 'apron', 'tower'] as const).map(preset => (
          <button
            key={preset}
            onClick={() => setCameraPreset(preset)}
            style={{
              padding: '4px 10px',
              fontSize: 9,
              background: cameraPreset === preset ? 'rgba(0, 212, 255, 0.2)' : 'rgba(5, 12, 25, 0.8)',
              border: `1px solid ${cameraPreset === preset ? '#00d4ff' : '#2a4a6a'}`,
              borderRadius: 4,
              color: cameraPreset === preset ? '#00d4ff' : '#6a9aca',
              cursor: 'pointer',
              textTransform: 'uppercase' as const,
              letterSpacing: '0.08em',
            }}
          >
            {preset}
          </button>
        ))}
        <button
          onClick={() => setShowParked(v => !v)}
          style={{
            padding: '4px 10px',
            fontSize: 9,
            background: showParked ? 'rgba(68, 85, 102, 0.3)' : 'rgba(5, 12, 25, 0.8)',
            border: `1px solid ${showParked ? '#445566' : '#2a4a6a'}`,
            borderRadius: 4,
            color: showParked ? '#aabbcc' : '#6a9aca',
            cursor: 'pointer',
            letterSpacing: '0.08em',
          }}
        >
          PARKED
        </button>
        <button
          onClick={() => setShowAirborne(v => !v)}
          style={{
            padding: '4px 10px',
            fontSize: 9,
            background: showAirborne ? 'rgba(0, 255, 136, 0.2)' : 'rgba(5, 12, 25, 0.8)',
            border: `1px solid ${showAirborne ? '#00ff88' : '#2a4a6a'}`,
            borderRadius: 4,
            color: showAirborne ? '#00ff88' : '#6a9aca',
            cursor: 'pointer',
            letterSpacing: '0.08em',
          }}
        >
          AIRBORNE
        </button>
      </div>

      {/* Selected drone detail panel */}
      <DroneDetailPanel
        drone={selectedDrone}
        onClose={() => setSelectedDroneId(null)}
      />

      {/* 3D Canvas */}
      <Canvas
        style={{ width: '100%', height: '100%' }}
        camera={{ position: cam.position, fov: 55, near: 0.5, far: 5000 }}
        shadows
        gl={{ antialias: true }}
      >
        <WorldScene
          fleetState={fleetState}
          selectedDroneId={selectedDroneId}
          onDroneClick={handleDroneClick}
          showParked={showParked}
          showAirborne={showAirborne}
          isNight={isNight}
        />
      </Canvas>

      {/* Legend */}
      <div style={{
        position: 'absolute',
        bottom: 16,
        left: 16,
        background: 'rgba(3, 8, 16, 0.85)',
        border: '1px solid #1a4a8a',
        borderRadius: 6,
        padding: '8px 12px',
        fontSize: 9,
        fontFamily: 'monospace',
        zIndex: 15,
      }}>
        <div style={{ color: '#4a8aca', marginBottom: 6 }}>DRONE CLASSES</div>
        {[
          { cls: 'Commander', color: '#00d4ff', count: 50 },
          { cls: 'Scout',     color: '#00ff88', count: 150 },
          { cls: 'Support',   color: '#ffaa00', count: 200 },
          { cls: 'Heavy',     color: '#ff2244', count: 100 },
        ].map(({ cls, color, count }) => (
          <div key={cls} style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 3 }}>
            <div style={{ width: 10, height: 10, borderRadius: '50%', background: color }} />
            <span style={{ color: '#aaaaaa' }}>{cls}</span>
            <span style={{ color, marginLeft: 'auto', paddingLeft: 16 }}>{count}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
