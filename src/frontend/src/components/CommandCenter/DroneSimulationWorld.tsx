// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: DroneSimulationWorld — The Organism's Sensory Cortex (500-Drone Edition)
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║       DRONE SIMULATION WORLD — 500-DRONE SENSORY CORTEX OF THE ORGANISM        ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  THIS IS NOT A GAME — IT IS LIVING TISSUE                                      ║
// ║                                                                                ║
// ║  500 real-spec drones parked in a virtual airstrip holding area:               ║
// ║    CLASS I — COMMAND   (50 units):  DJI Matrice 350 RTK                        ║
// ║    CLASS II — SCOUT    (150 units): DJI Mavic 3E / Autel EVO MAX 4T            ║
// ║    CLASS III — SUPPORT (200 units): Skydio X10 / Autel EVO MAX 4T              ║
// ║    CLASS IV — HEAVY    (100 units): DJI Agras T40                              ║
// ║                                                                                ║
// ║  Airstrip layout:                                                              ║
// ║    • 500m × 30m runway (RWY 09/27) with full markings and PAPI                 ║
// ║    • 500-spot parking grid (25 cols × 20 rows) with charging pads              ║
// ║    • Taxiway A with hold-short lines                                           ║
// ║    • Control tower, hangars, maintenance building                              ║
// ║                                                                                ║
// ║  Kuramoto r flows BIDIRECTIONALLY with organism state.                         ║
// ║  THE EXPERIMENT IS THE ORGANISM. THE ORGANISM IS THE EXPERIMENT.               ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import {
  type FleetState,
  type RuntimeDroneState,
  type SwarmConfig,
  DEFAULT_SWARM_CONFIG,
  initializeFleetState,
  stepFleet,
  batchDispatch,
  rtbAll,
  emergencyStopAll,
  computeKuramotoOrder,
  computeJasmineDrift,
  computeFormationTargets,
  type FormationPattern,
} from '../../world/DroneFleet500';
import { droneClassColor, FLEET_ALLOCATION } from '../../world/DroneFleetSpecs';
import { AIRSTRIP } from '../../world/VirtualAirstrip';

// ═══════════════════════════════════════════════════════════════════════════════
// STYLES
// ═══════════════════════════════════════════════════════════════════════════════

const S = {
  root: {
    width: '100%',
    height: '100%',
    background: '#030810',
    display: 'grid',
    gridTemplateColumns: '1fr 320px',
    gridTemplateRows: '36px 1fr 200px',
    gap: 2,
    overflow: 'hidden',
  },
  topBar: {
    gridColumn: '1 / -1',
    background: 'rgba(5, 12, 25, 0.95)',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    gap: 20,
    padding: '0 16px',
    fontSize: 10,
    fontFamily: 'monospace',
  },
  topBarTitle: {
    color: '#00d4ff',
    fontWeight: 'bold',
    letterSpacing: '0.12em',
    fontSize: 11,
    marginRight: 8,
  },
  stat: {
    color: '#6a9aca',
    whiteSpace: 'nowrap' as const,
  },
  statValue: (color: string) => ({
    color,
    fontWeight: 'bold' as const,
  }),
  viewport: {
    position: 'relative' as const,
    background: 'linear-gradient(180deg, #050f20 0%, #0d1e3a 50%, #050f1a 100%)',
    overflow: 'hidden',
  },
  canvas: {
    width: '100%',
    height: '100%',
    display: 'block',
  },
  overlay: {
    position: 'absolute' as const,
    top: 12,
    left: 12,
    zIndex: 10,
    pointerEvents: 'none' as const,
  },
  overlayTitle: {
    fontSize: 11,
    color: '#00d4ff',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    marginBottom: 6,
    textShadow: '0 0 10px rgba(0, 212, 255, 0.5)',
  },
  metricsRow: {
    display: 'flex',
    gap: 14,
    marginBottom: 3,
    fontSize: 9,
  },
  metric: {
    color: '#6a9aca',
  },
  metricValue: (color: string) => ({
    color,
    fontWeight: 'bold' as const,
  }),
  controlPanel: {
    background: 'rgba(5, 12, 25, 0.95)',
    borderLeft: '1px solid #1a3a5c',
    padding: '10px',
    overflow: 'auto',
    fontSize: 10,
    fontFamily: 'monospace',
  },
  panelSection: {
    marginBottom: 14,
    paddingBottom: 10,
    borderBottom: '1px solid #152a45',
  },
  panelTitle: {
    fontSize: 9,
    color: '#4a8aca',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    marginBottom: 8,
  },
  sliderGroup: {
    marginBottom: 10,
  },
  sliderLabel: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: 9,
    color: '#6a9aca',
    marginBottom: 3,
  },
  slider: {
    width: '100%',
    accentColor: '#00d4ff',
    height: 4,
  },
  button: (active: boolean, color = '#00d4ff') => ({
    width: '100%',
    padding: '7px',
    marginBottom: 6,
    background: active ? `rgba(0, 212, 255, 0.15)` : 'rgba(8, 20, 40, 0.8)',
    border: `1px solid ${active ? color : '#2a4a6a'}`,
    borderRadius: 5,
    color: active ? color : '#6a9aca',
    fontSize: 9,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.08em',
    cursor: 'pointer',
  }),
  selectInput: {
    width: '100%',
    background: 'rgba(8, 20, 40, 0.8)',
    border: '1px solid #2a4a6a',
    borderRadius: 5,
    color: '#6a9aca',
    fontSize: 9,
    padding: '5px',
    marginBottom: 6,
  },
  emergencyBtn: {
    width: '100%',
    padding: '10px',
    background: '#2a0808',
    border: '2px solid #ff2244',
    borderRadius: 5,
    color: '#ff2244',
    fontSize: 10,
    fontWeight: 'bold' as const,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    cursor: 'pointer',
    marginTop: 10,
  },
  statusPanel: {
    gridColumn: '1 / -1',
    background: 'rgba(5, 12, 25, 0.95)',
    borderTop: '1px solid #1a3a5c',
    display: 'grid',
    gridTemplateColumns: 'repeat(8, 1fr)',
    gap: 8,
    padding: '10px 14px',
    fontFamily: 'monospace',
  },
  statusCard: {
    background: 'rgba(8, 20, 40, 0.6)',
    border: '1px solid #1a3a5c',
    borderRadius: 6,
    padding: '8px',
    textAlign: 'center' as const,
  },
  statusValue: (color: string) => ({
    fontSize: 18,
    fontWeight: 'bold' as const,
    color,
    marginBottom: 2,
  }),
  statusLabel: {
    fontSize: 8,
    color: '#4a7aaa',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.08em',
  },
  classRow: {
    display: 'flex',
    alignItems: 'center',
    gap: 6,
    padding: '4px 0',
    fontSize: 9,
  },
  classDot: (color: string) => ({
    width: 8,
    height: 8,
    borderRadius: '50%',
    background: color,
    flexShrink: 0,
  }),
  alertItem: (severity: string) => ({
    padding: '4px 6px',
    background: severity === 'Critical' ? 'rgba(255,34,68,0.1)' : 'rgba(255,170,0,0.1)',
    border: `1px solid ${severity === 'Critical' ? '#ff2244' : '#ffaa00'}`,
    borderRadius: 4,
    marginBottom: 4,
    fontSize: 8,
    color: severity === 'Critical' ? '#ff7788' : '#ffcc44',
  }),
};

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS RENDERER — 2D top-down view of 500 drones + airstrip
// ═══════════════════════════════════════════════════════════════════════════════

function renderFleet500(
  ctx: CanvasRenderingContext2D,
  fleetState: FleetState,
  width: number,
  height: number,
  viewMode: '2d-top' | '2d-side',
  scale: number,
  offsetX: number,
  offsetZ: number
): void {
  ctx.clearRect(0, 0, width, height);

  // Sky gradient based on time of day
  const tod = fleetState.timeOfDay;
  const isNight = tod < 6 || tod > 20;
  const gradient = ctx.createLinearGradient(0, 0, 0, height);
  if (isNight) {
    gradient.addColorStop(0, '#020508');
    gradient.addColorStop(1, '#060d18');
  } else {
    gradient.addColorStop(0, '#0a1a30');
    gradient.addColorStop(1, '#152540');
  }
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, width, height);

  const cx = width / 2 + offsetX;
  const cz = height / 2 + offsetZ;

  // Helper: world → canvas
  const wx = (x: number) => cx + x * scale;
  const wz = (z: number) => cz + z * scale;
  const wlen = (l: number) => l * scale;

  // ─── GRID ───────────────────────────────────────────────────────────────────
  ctx.strokeStyle = 'rgba(0, 80, 150, 0.1)';
  ctx.lineWidth = 1;
  const gridWorld = 50;
  const gridStart = -400;
  const gridEnd = 400;
  for (let gx = gridStart; gx <= gridEnd; gx += gridWorld) {
    ctx.beginPath();
    ctx.moveTo(wx(gx), wz(gridStart));
    ctx.lineTo(wx(gx), wz(gridEnd));
    ctx.stroke();
  }
  for (let gz = -300; gz <= 200; gz += gridWorld) {
    ctx.beginPath();
    ctx.moveTo(wx(gridStart), wz(gz));
    ctx.lineTo(wx(gridEnd), wz(gz));
    ctx.stroke();
  }

  // ─── RUNWAY ─────────────────────────────────────────────────────────────────
  const halfRwyLen = AIRSTRIP.RUNWAY_LENGTH / 2;
  const halfRwyW = AIRSTRIP.RUNWAY_WIDTH / 2;

  ctx.fillStyle = '#1a1a20';
  ctx.fillRect(
    wx(-halfRwyLen),
    wz(-halfRwyW),
    wlen(AIRSTRIP.RUNWAY_LENGTH),
    wlen(AIRSTRIP.RUNWAY_WIDTH)
  );

  // Centerline
  ctx.strokeStyle = '#e0e0e0';
  ctx.lineWidth = Math.max(1, wlen(0.9));
  ctx.setLineDash([wlen(15), wlen(10)]);
  ctx.beginPath();
  ctx.moveTo(wx(-halfRwyLen), wz(0));
  ctx.lineTo(wx(halfRwyLen), wz(0));
  ctx.stroke();
  ctx.setLineDash([]);

  // Runway designation text
  ctx.fillStyle = '#ffffff';
  ctx.font = `bold ${Math.max(7, wlen(4))}px monospace`;
  ctx.textAlign = 'center';
  ctx.fillText('09', wx(-halfRwyLen + 12), wz(-2));
  ctx.fillText('27', wx(halfRwyLen - 12), wz(-2));
  ctx.textAlign = 'left';

  // ─── TAXIWAY A ───────────────────────────────────────────────────────────────
  ctx.fillStyle = '#191924';
  ctx.fillRect(
    wx(-halfRwyLen - 10),
    wz(AIRSTRIP.TAXIWAY_A_Z - AIRSTRIP.TAXIWAY_A_WIDTH / 2),
    wlen(AIRSTRIP.TAXIWAY_A_LENGTH + 20),
    wlen(AIRSTRIP.TAXIWAY_A_WIDTH)
  );

  // Taxiway centerline (yellow dashed)
  ctx.strokeStyle = '#cc9900';
  ctx.lineWidth = Math.max(1, wlen(0.15));
  ctx.setLineDash([wlen(7), wlen(5)]);
  ctx.beginPath();
  ctx.moveTo(wx(-halfRwyLen), wz(AIRSTRIP.TAXIWAY_A_Z));
  ctx.lineTo(wx(halfRwyLen), wz(AIRSTRIP.TAXIWAY_A_Z));
  ctx.stroke();
  ctx.setLineDash([]);

  // ─── APRON ───────────────────────────────────────────────────────────────────
  ctx.fillStyle = '#1e1e28';
  ctx.fillRect(
    wx(AIRSTRIP.APRON_X_WEST),
    wz(AIRSTRIP.APRON_Z_NORTH),
    wlen(AIRSTRIP.APRON_X_EAST - AIRSTRIP.APRON_X_WEST),
    wlen(AIRSTRIP.APRON_Z_SOUTH - AIRSTRIP.APRON_Z_NORTH)
  );

  // ─── PARKING SPOT OUTLINES ───────────────────────────────────────────────────
  ctx.strokeStyle = 'rgba(30, 80, 150, 0.4)';
  ctx.lineWidth = Math.max(0.5, wlen(0.15));
  for (let row = 0; row < AIRSTRIP.PARKING_ROWS; row++) {
    for (let col = 0; col < AIRSTRIP.PARKING_COLS; col++) {
      const sx = AIRSTRIP.PARKING_ORIGIN_X + col * AIRSTRIP.PARKING_SPACING_X;
      const sz = AIRSTRIP.PARKING_ORIGIN_Z - row * AIRSTRIP.PARKING_SPACING_Z;
      ctx.strokeRect(
        wx(sx - AIRSTRIP.SPOT_PAD_SIZE / 2),
        wz(sz - AIRSTRIP.SPOT_PAD_SIZE / 2),
        wlen(AIRSTRIP.SPOT_PAD_SIZE),
        wlen(AIRSTRIP.SPOT_PAD_SIZE)
      );
    }
  }

  // ─── CONTROL TOWER ───────────────────────────────────────────────────────────
  ctx.fillStyle = '#8899aa';
  ctx.fillRect(
    wx(AIRSTRIP.TOWER_X - AIRSTRIP.TOWER_WIDTH / 2),
    wz(AIRSTRIP.TOWER_Z - AIRSTRIP.TOWER_DEPTH / 2),
    wlen(AIRSTRIP.TOWER_WIDTH),
    wlen(AIRSTRIP.TOWER_DEPTH)
  );
  ctx.fillStyle = '#00ff44';
  const beaconSize = Math.max(3, wlen(4));
  ctx.beginPath();
  ctx.arc(wx(AIRSTRIP.TOWER_X), wz(AIRSTRIP.TOWER_Z), beaconSize, 0, Math.PI * 2);
  ctx.fill();

  // ─── DRONES ──────────────────────────────────────────────────────────────────
  const drones = fleetState.drones;

  for (const drone of drones) {
    if (drone.status === 'Offline') continue;

    const classColor = droneClassColor(drone.spec.droneClass);
    const dx = wx(drone.position.x);
    const dz = wz(drone.position.z);

    // Draw trail for airborne drones
    if (drone.trail.length > 1 && drone.status !== 'Parked' && drone.status !== 'Charging') {
      ctx.beginPath();
      ctx.moveTo(wx(drone.trail[0].x), wz(drone.trail[0].z));
      for (let t = 1; t < drone.trail.length; t++) {
        const alpha = t / drone.trail.length;
        ctx.strokeStyle = `${classColor}${Math.floor(alpha * 40).toString(16).padStart(2, '0')}`;
        ctx.lineWidth = Math.max(0.5, wlen(0.3));
        ctx.lineTo(wx(drone.trail[t].x), wz(drone.trail[t].z));
      }
      ctx.stroke();
    }

    // Drone dot size
    const dotSize = drone.status === 'Parked' || drone.status === 'Charging'
      ? Math.max(2, wlen(1.5))
      : Math.max(3, wlen(2.5));

    // Color by status / class
    let fillColor = classColor;
    if (drone.status === 'Charging') fillColor = '#0044bb';
    else if (drone.status === 'PreflightCheck') fillColor = '#44bb88';
    else if (drone.status === 'Emergency') fillColor = '#ff2244';
    else if (drone.status === 'Offline') fillColor = '#333344';

    // Draw glow for airborne drones
    if (!['Parked', 'Charging', 'Maintenance', 'Offline'].includes(drone.status)) {
      const glowGrad = ctx.createRadialGradient(dx, dz, 0, dx, dz, dotSize * 3);
      glowGrad.addColorStop(0, `${classColor}44`);
      glowGrad.addColorStop(1, 'transparent');
      ctx.fillStyle = glowGrad;
      ctx.beginPath();
      ctx.arc(dx, dz, dotSize * 3, 0, Math.PI * 2);
      ctx.fill();
    }

    // Drone body
    ctx.fillStyle = fillColor;
    ctx.beginPath();
    ctx.arc(dx, dz, dotSize, 0, Math.PI * 2);
    ctx.fill();

    // Heading indicator for airborne drones
    if (drone.status !== 'Parked' && drone.status !== 'Charging') {
      const hdLen = dotSize * 2.5;
      ctx.strokeStyle = fillColor;
      ctx.lineWidth = Math.max(0.5, wlen(0.4));
      ctx.beginPath();
      ctx.moveTo(dx, dz);
      ctx.lineTo(
        dx + Math.sin(drone.orientation.yaw) * hdLen,
        dz + Math.cos(drone.orientation.yaw) * hdLen
      );
      ctx.stroke();
    }
  }

  // ─── KURAMOTO COHERENCE RING ─────────────────────────────────────────────────
  const r = fleetState.rSwarm;
  ctx.strokeStyle = `rgba(0, 255, 136, ${r * 0.6})`;
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.arc(wx(0), wz(0), wlen(200 * r), 0, Math.PI * 2);
  ctx.stroke();

  // ─── TIME / WEATHER LABEL ────────────────────────────────────────────────────
  const tod = fleetState.timeOfDay;
  const timeStr = `${String(Math.floor(tod)).padStart(2, '0')}:${String(Math.floor((tod % 1) * 60)).padStart(2, '0')}`;
  ctx.fillStyle = '#4a8aca';
  ctx.font = '10px monospace';
  ctx.fillText(`${timeStr} · ${fleetState.weather} · Wind ${fleetState.windSpeedMs.toFixed(1)} m/s`, 8, height - 8);
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT — DroneSimulationWorld (500-drone edition)
// ═══════════════════════════════════════════════════════════════════════════════

interface Props {
  organism: any;
}

export function DroneSimulationWorld({ organism }: Props) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const animRef = useRef<number>(0);
  const tickRef = useRef<number>(0);

  // ─── ORGANISM SYNC ──────────────────────────────────────────────────────────
  const {
    rSwarm: organismR = 0.85,
    jDrift: organismDrift = 0,
    beat: organismBeat = 0,
    emergencyActive = false,
    architectSignal = 0.5,
  } = organism || {};

  // ─── SIMULATION STATE ───────────────────────────────────────────────────────
  const [fleetState, setFleetState] = useState<FleetState>(() => initializeFleetState());
  const [isRunning, setIsRunning] = useState(true);
  const [swarmConfig, setSwarmConfig] = useState<SwarmConfig>(() => ({
    ...DEFAULT_SWARM_CONFIG,
    couplingK: 2.0 + architectSignal,
  }));
  const [selectedFormation, setSelectedFormation] = useState<FormationPattern>('Parked' as any);
  const [viewMode] = useState<'2d-top'>('2d-top');
  const [scale, setScale] = useState(1.0);
  const [dispatchClass, setDispatchClass] = useState<'Commander' | 'Scout' | 'Support' | 'Heavy' | 'All'>('Scout');
  const [dispatchCount, setDispatchCount] = useState(10);

  // Sync emergency stop from organism
  useEffect(() => {
    if (emergencyActive) {
      setIsRunning(false);
      setFleetState(prev => emergencyStopAll(prev));
    }
  }, [emergencyActive]);

  // Sync coupling from architect signal
  useEffect(() => {
    setSwarmConfig(prev => ({ ...prev, couplingK: 2.0 + architectSignal }));
  }, [architectSignal]);

  // ─── ANIMATION LOOP ─────────────────────────────────────────────────────────
  const fleetStateRef = useRef(fleetState);
  fleetStateRef.current = fleetState;
  const swarmConfigRef = useRef(swarmConfig);
  swarmConfigRef.current = swarmConfig;

  useEffect(() => {
    if (!isRunning) return;

    let lastTime = performance.now();

    const loop = (now: number) => {
      const dtMs = Math.min(now - lastTime, 100);
      lastTime = now;
      const dt = dtMs / 1000;

      tickRef.current++;

      const newState = stepFleet(
        fleetStateRef.current,
        swarmConfigRef.current,
        dt,
        tickRef.current
      );

      // Blend Kuramoto r with organism
      const blendedR = newState.rSwarm * 0.7 + (organismR || 0.85) * 0.3;
      setFleetState({ ...newState, rSwarm: blendedR });

      // Render to canvas
      const canvas = canvasRef.current;
      const ctx = canvas?.getContext('2d');
      if (canvas && ctx) {
        renderFleet500(ctx, newState, canvas.width, canvas.height, viewMode, scale, 0, 0);
      }

      animRef.current = requestAnimationFrame(loop);
    };

    animRef.current = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(animRef.current);
  }, [isRunning, viewMode, scale, organismR]);

  // ─── CANVAS RESIZE ──────────────────────────────────────────────────────────
  useEffect(() => {
    const resize = () => {
      const canvas = canvasRef.current;
      if (!canvas) return;
      const parent = canvas.parentElement;
      if (parent) {
        canvas.width = parent.clientWidth;
        canvas.height = parent.clientHeight;
      }
    };
    resize();
    window.addEventListener('resize', resize);
    return () => window.removeEventListener('resize', resize);
  }, []);

  // ─── DISPATCH HANDLER ───────────────────────────────────────────────────────
  const handleDispatch = useCallback(() => {
    setFleetState(prev => batchDispatch(
      prev,
      dispatchClass,
      'Patrol',
      { x: (Math.random() - 0.5) * 400, y: 80, z: (Math.random() - 0.5) * 400 },
      dispatchCount,
      5
    ));
  }, [dispatchClass, dispatchCount]);

  // ─── RTB ALL ────────────────────────────────────────────────────────────────
  const handleRTB = useCallback(() => {
    setFleetState(prev => rtbAll(prev));
  }, []);

  // ─── EMERGENCY STOP ─────────────────────────────────────────────────────────
  const handleEmergencyStop = useCallback(() => {
    setIsRunning(false);
    setFleetState(prev => emergencyStopAll(prev));
  }, []);

  // ─── RESET ──────────────────────────────────────────────────────────────────
  const handleReset = useCallback(() => {
    tickRef.current = 0;
    setFleetState(initializeFleetState());
    setIsRunning(true);
  }, []);

  const { stats, maintenanceAlerts } = fleetState;

  // ─── RENDER ─────────────────────────────────────────────────────────────────
  return (
    <div style={S.root}>
      {/* Top status bar */}
      <div style={S.topBar}>
        <span style={S.topBarTitle}>⬡ NOVA AIRSTRIP — 500 DRONES</span>
        <span style={S.stat}>
          PARKED: <strong style={S.statValue('#445566')}>{stats.parked + stats.charging}</strong>
        </span>
        <span style={S.stat}>
          AIRBORNE: <strong style={S.statValue('#00ff88')}>{stats.airborne}</strong>
        </span>
        <span style={S.stat}>
          TAXI: <strong style={S.statValue('#88aaff')}>{stats.taxiing}</strong>
        </span>
        <span style={S.stat}>
          PREFLIGHT: <strong style={S.statValue('#44ff88')}>{stats.preflight}</strong>
        </span>
        {stats.emergency > 0 && (
          <span style={{ color: '#ff2244', fontWeight: 'bold' }}>
            ⚠ EMERGENCY: {stats.emergency}
          </span>
        )}
        <span style={{ ...S.stat, marginLeft: 'auto' }}>
          Coherence r: <strong style={S.statValue(fleetState.rSwarm > 0.7 ? '#00ff88' : '#ffaa00')}>
            {(fleetState.rSwarm * 100).toFixed(0)}%
          </strong>
        </span>
        <span style={S.stat}>
          Batt: <strong style={S.statValue('#dddddd')}>{(stats.avgBatterySoC * 100).toFixed(0)}%</strong>
        </span>
        <span style={S.stat}>
          {fleetState.weather} · Wind {fleetState.windSpeedMs.toFixed(1)} m/s
        </span>
      </div>

      {/* Canvas viewport */}
      <div style={S.viewport}>
        <canvas ref={canvasRef} style={S.canvas} />

        {/* Overlay HUD */}
        <div style={S.overlay}>
          <div style={S.overlayTitle}>⬡ DRONE SWARM — LIVE</div>
          <div style={S.metricsRow}>
            <span style={S.metric}>
              r: <strong style={S.metricValue('#00ff88')}>{fleetState.rSwarm.toFixed(3)}</strong>
            </span>
            <span style={S.metric}>
              ψ: <strong style={S.metricValue('#00d4ff')}>{fleetState.psiSwarm.toFixed(2)}</strong>
            </span>
            <span style={S.metric}>
              Drift: <strong style={S.metricValue('#ffaa00')}>{fleetState.jasmineDrift.toFixed(3)}</strong>
            </span>
          </div>
          <div style={S.metricsRow}>
            <span style={S.metric}>
              CMD: <strong style={S.metricValue('#00d4ff')}>{stats.byClass.Commander.airborne}/{stats.byClass.Commander.total}</strong>
            </span>
            <span style={S.metric}>
              SCT: <strong style={S.metricValue('#00ff88')}>{stats.byClass.Scout.airborne}/{stats.byClass.Scout.total}</strong>
            </span>
            <span style={S.metric}>
              SUP: <strong style={S.metricValue('#ffaa00')}>{stats.byClass.Support.airborne}/{stats.byClass.Support.total}</strong>
            </span>
            <span style={S.metric}>
              HVY: <strong style={S.metricValue('#ff2244')}>{stats.byClass.Heavy.airborne}/{stats.byClass.Heavy.total}</strong>
            </span>
          </div>
        </div>
      </div>

      {/* Control panel */}
      <div style={S.controlPanel}>
        {/* Simulation Controls */}
        <div style={S.panelSection}>
          <div style={S.panelTitle}>⚙ Simulation</div>
          <button style={S.button(isRunning, '#00ff88')} onClick={() => setIsRunning(v => !v)}>
            {isRunning ? '⏸ Pause' : '▶ Resume'}
          </button>
          <button style={S.button(false)} onClick={handleReset}>
            🔄 Reset Fleet
          </button>
        </div>

        {/* Swarm Physics */}
        <div style={S.panelSection}>
          <div style={S.panelTitle}>🌀 Swarm Physics</div>
          <div style={S.sliderGroup}>
            <div style={S.sliderLabel}>
              <span>Coupling K</span>
              <span>{swarmConfig.couplingK.toFixed(2)}</span>
            </div>
            <input
              type="range" min="0" max="8" step="0.1"
              value={swarmConfig.couplingK}
              onChange={e => setSwarmConfig(c => ({ ...c, couplingK: +e.target.value }))}
              style={S.slider}
            />
          </div>
          <div style={S.sliderGroup}>
            <div style={S.sliderLabel}>
              <span>Noise σ</span>
              <span>{swarmConfig.noiseStrength.toFixed(2)}</span>
            </div>
            <input
              type="range" min="0" max="0.5" step="0.01"
              value={swarmConfig.noiseStrength}
              onChange={e => setSwarmConfig(c => ({ ...c, noiseStrength: +e.target.value }))}
              style={S.slider}
            />
          </div>
          <div style={S.sliderGroup}>
            <div style={S.sliderLabel}>
              <span>Separation</span>
              <span>{swarmConfig.separationRadiusM}m</span>
            </div>
            <input
              type="range" min="5" max="60" step="1"
              value={swarmConfig.separationRadiusM}
              onChange={e => setSwarmConfig(c => ({ ...c, separationRadiusM: +e.target.value }))}
              style={S.slider}
            />
          </div>
          <div style={S.sliderGroup}>
            <div style={S.sliderLabel}>
              <span>View Scale</span>
              <span>{scale.toFixed(1)}×</span>
            </div>
            <input
              type="range" min="0.3" max="4" step="0.1"
              value={scale}
              onChange={e => setScale(+e.target.value)}
              style={S.slider}
            />
          </div>
        </div>

        {/* Dispatch */}
        <div style={S.panelSection}>
          <div style={S.panelTitle}>🚀 Dispatch</div>
          <select
            value={dispatchClass}
            onChange={e => setDispatchClass(e.target.value as any)}
            style={S.selectInput}
          >
            <option value="All">All Classes</option>
            <option value="Commander">Commander (50)</option>
            <option value="Scout">Scout (150)</option>
            <option value="Support">Support (200)</option>
            <option value="Heavy">Heavy (100)</option>
          </select>
          <div style={S.sliderGroup}>
            <div style={S.sliderLabel}>
              <span>Count</span>
              <span>{dispatchCount}</span>
            </div>
            <input
              type="range" min="1" max="50" step="1"
              value={dispatchCount}
              onChange={e => setDispatchCount(+e.target.value)}
              style={S.slider}
            />
          </div>
          <button style={S.button(false, '#00ff88')} onClick={handleDispatch}>
            🛫 Launch {dispatchCount} {dispatchClass}
          </button>
          <button style={S.button(false, '#ffaa00')} onClick={handleRTB}>
            🛬 RTB All
          </button>
        </div>

        {/* Fleet Class Summary */}
        <div style={S.panelSection}>
          <div style={S.panelTitle}>🚁 Fleet Classes</div>
          {(Object.entries(stats.byClass) as Array<[string, { total: number; airborne: number; parked: number }]>).map(([cls, data]) => (
            <div key={cls} style={S.classRow}>
              <div style={S.classDot(droneClassColor(cls as any))} />
              <span style={{ color: '#6a9aca', flex: 1 }}>{cls}</span>
              <span style={{ color: droneClassColor(cls as any) }}>{data.airborne}↑</span>
              <span style={{ color: '#445566', marginLeft: 4 }}>{data.parked}P</span>
            </div>
          ))}
        </div>

        {/* Alerts */}
        {maintenanceAlerts.length > 0 && (
          <div style={S.panelSection}>
            <div style={S.panelTitle}>⚠ Alerts ({maintenanceAlerts.length})</div>
            {maintenanceAlerts.slice(0, 6).map((alert, i) => (
              <div key={i} style={S.alertItem(alert.severity)}>
                <strong>{alert.callSign}</strong>: {alert.message}
              </div>
            ))}
          </div>
        )}

        {/* Emergency */}
        <button style={S.emergencyBtn} onClick={handleEmergencyStop}>
          ⛔ EMERGENCY STOP ALL
        </button>
      </div>

      {/* Status panel */}
      <div style={S.statusPanel}>
        <div style={S.statusCard}>
          <div style={S.statusValue(fleetState.rSwarm > 0.7 ? '#00ff88' : fleetState.rSwarm > 0.4 ? '#ffaa00' : '#ff2244')}>
            {fleetState.rSwarm.toFixed(3)}
          </div>
          <div style={S.statusLabel}>Kuramoto r</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue(fleetState.jasmineDrift < 1 ? '#00ff88' : '#ffaa00')}>
            {fleetState.jasmineDrift.toFixed(3)}
          </div>
          <div style={S.statusLabel}>Jasmine Drift</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue('#00ff88')}>{stats.airborne}</div>
          <div style={S.statusLabel}>Airborne</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue('#445566')}>{stats.parked + stats.charging}</div>
          <div style={S.statusLabel}>Parked</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue(stats.avgBatterySoC > 0.5 ? '#00ff88' : '#ffaa00')}>
            {(stats.avgBatterySoC * 100).toFixed(0)}%
          </div>
          <div style={S.statusLabel}>Avg Battery</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue(stats.avgHealth > 0.8 ? '#00d4ff' : '#ff6600')}>
            {(stats.avgHealth * 100).toFixed(0)}%
          </div>
          <div style={S.statusLabel}>Avg Health</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue(stats.emergency > 0 ? '#ff2244' : '#aaaaaa')}>
            {stats.emergency}
          </div>
          <div style={S.statusLabel}>Emergency</div>
        </div>
        <div style={S.statusCard}>
          <div style={S.statusValue('#dddddd')}>
            {stats.totalDrones}
          </div>
          <div style={S.statusLabel}>Total Fleet</div>
        </div>
      </div>
    </div>
  );
}

export default DroneSimulationWorld;
