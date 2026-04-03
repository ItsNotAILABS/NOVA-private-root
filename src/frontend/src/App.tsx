// ─── NOVA / PARALLAX — Living Enterprise Habitat Shell ───────────────────────
// Main application: enterprise habitat + simulation world + swarm mind.
// Architecture: law → state → gradients → morphogenesis → expression.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import React, { useState, Suspense, lazy } from 'react';
import { useOrganismState }   from './hooks/useOrganismState';

// ── Existing JSX components (display / tactical) ──────────────────────────────
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore -- JSX modules without type declarations
import TacticalMap    from './components/TacticalMap.jsx';
// @ts-ignore
import SwarmVitals    from './components/SwarmVitals.jsx';
// @ts-ignore
import CommandConsole from './components/CommandConsole.jsx';
// @ts-ignore
import OrganismPanel  from './components/OrganismPanel.jsx';

// ── New TypeScript habitat components ─────────────────────────────────────────
import { HomeNow }            from './components/habitat/HomeNow';
import { WorkerHub }          from './components/habitat/WorkerHub';
import { ArtifactStudio }     from './components/habitat/ArtifactStudio';
import { PresenceBoard }      from './components/habitat/PresenceBoard';
import { SimulationChamber }  from './components/simulation/SimulationChamber';

// ── ORO Command Center — The Real Multi-Agent Workspace ─────────────────────────
import { OroCommandCenter }     from './components/CommandCenter/OroCommandCenter';
import { DroneSimulationWorld } from './components/CommandCenter/DroneSimulationWorld';

// ── Emergence · Math/Physics · NeuroCog Labs ────────────────────────────────
import { EmergenceLab }   from './components/CommandCenter/EmergenceLab';
import { MathPhysicsLab } from './components/CommandCenter/MathPhysicsLab';
import { NeuroCogLab }    from './components/CommandCenter/NeuroCogLab';

// ── Navigation ────────────────────────────────────────────────────────────────
type NavView =
  | 'SWARM'          // original tactical swarm view
  | 'COMMAND'        // ORO Command Center — multi-agent workspace
  | 'DRONES'         // Drone simulation — the actual experiment
  | 'HOME'           // home/now enterprise view
  | 'WORKERS'        // worker society hub
  | 'ARTIFACTS'      // artifact studio
  | 'PRESENCE'       // presence board
  | 'SIMULATION'     // world simulation chamber
  | 'EMERGENCE'      // Emergence Lab — Kuramoto coherence dynamics
  | 'MATHPHYSICS'    // Math & Physics Lab — all governing equations live
  | 'NEUROCOG';      // Neuroscience & Cognitive Architecture Lab

const NAV_ITEMS: Array<{ id: NavView; label: string; icon: string }> = [
  { id: 'COMMAND',    label: 'Command',    icon: '◉' },
  { id: 'DRONES',     label: 'Drones',     icon: '⬡' },
  { id: 'SWARM',      label: 'Swarm',      icon: '⬢' },
  { id: 'HOME',       label: 'Home/Now',   icon: '⌂' },
  { id: 'WORKERS',    label: 'Workers',    icon: '⚙' },
  { id: 'ARTIFACTS',  label: 'Artifacts',  icon: '▣' },
  { id: 'PRESENCE',   label: 'Presence',   icon: '●' },
  { id: 'SIMULATION', label: 'World Sim',  icon: '✦' },
  { id: 'EMERGENCE',  label: 'Emergence',  icon: '◎' },
  { id: 'MATHPHYSICS',label: 'Math·Phys',  icon: '∿' },
  { id: 'NEUROCOG',   label: 'NeuroCog',   icon: '⌬' },
];

// ── Styles ────────────────────────────────────────────────────────────────────
const S = {
  root: {
    width: '100vw',
    height: '100vh',
    background: '#050a14',
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  },
  topBar: {
    height: 36,
    background: '#070e1e',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    padding: '0 12px',
    gap: 4,
    flexShrink: 0,
  },
  brand: {
    fontSize: 10,
    color: '#4af',
    letterSpacing: '0.18em',
    textTransform: 'uppercase' as const,
    marginRight: 16,
  },
  navBtn: (active: boolean) => ({
    padding: '3px 10px',
    fontSize: 9,
    background:  active ? '#1a3a5c' : 'transparent',
    color:       active ? '#4af'    : '#3a6080',
    border:      `1px solid ${active ? '#4af' : 'transparent'}`,
    borderRadius: 3,
    cursor: 'pointer',
    letterSpacing: '0.06em',
    textTransform: 'uppercase' as const,
    display: 'flex',
    alignItems: 'center',
    gap: 4,
  }),
  statusRow: {
    marginLeft: 'auto',
    display: 'flex',
    alignItems: 'center',
    gap: 12,
    fontSize: 8,
    color: '#3a6080',
  },
  statusItem: (warn: boolean, danger: boolean) => ({
    color: danger ? '#f44' : warn ? '#fa4' : '#4af',
  }),
  content: {
    flex: 1,
    overflow: 'hidden',
    display: 'flex',
  },
  // Legacy swarm layout
  swarmRoot: {
    display: 'grid',
    gridTemplateColumns: '1fr 320px 260px',
    gridTemplateRows: '1fr 280px',
    width: '100%',
    height: '100%',
    gap: 2,
  },
  mapArea: {
    gridColumn: '1',
    gridRow: '1 / 3',
    position: 'relative' as const,
    background: '#070e1e',
    border: '1px solid #1a3a5c',
  },
  vitalsPanel: {
    gridColumn: '2',
    gridRow: '1',
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    overflow: 'hidden',
  },
  consolePanel: {
    gridColumn: '2',
    gridRow: '2',
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    overflow: 'hidden',
  },
  organismPanel: {
    gridColumn: '3',
    gridRow: '1 / 3',
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    overflow: 'hidden',
  },
  // Habitat layout (sidebar + main)
  habitatRoot: {
    width: '100%',
    height: '100%',
    display: 'flex',
  },
  habitatSidebar: {
    width: 300,
    borderRight: '1px solid #1a3a5c',
    background: '#070e1e',
    overflowY: 'auto' as const,
  },
  habitatMain: {
    flex: 1,
    overflow: 'hidden',
  },
};

// ── Score indicator for top bar ───────────────────────────────────────────────
function TopScore({ label, value, warn = 0.6, danger = 0.4 }: { label: string; value: number; warn?: number; danger?: number }) {
  const isDanger = value < danger;
  const isWarn   = !isDanger && value < warn;
  return (
    <span style={S.statusItem(isWarn, isDanger)}>
      {label}: {(value * 100).toFixed(0)}%
    </span>
  );
}

// ── Compatibility shim: adapt useOrganismState → legacy useSwarmState shape ───
// The old JSX components expect the useSwarmState API.
function adaptToSwarmShape(organism: ReturnType<typeof useOrganismState>) {
  return {
    beat:           organism.beat,
    drones:         organism.drones,
    rSwarm:         organism.rSwarm,
    jDrift:         organism.jDrift,
    pendingActions: organism.pendingActions,
    auditLog:       organism.auditLog,
    missionStatus:  organism.missionStatus,
    missionName:    organism.missionName,
    emergencyActive: organism.emergencyActive,
    commsLost:      organism.commsLost,
    architectSignal: organism.architectSignal,
    setArchitectSignal: organism.setArchitectSignal,
    approve:        organism.approve,
    deny:           organism.deny,
    emergencyStop:  organism.emergencyStop,
    startMission:   organism.startMission,
    heartbeat:      organism.heartbeat,
    swarmQCoherence: organism.swarmQCoherence,
    swarmConvergence: organism.swarmConvergence,
  };
}

// ── Main App ──────────────────────────────────────────────────────────────────
export default function App() {
  const [view, setView] = useState<NavView>('COMMAND'); // Default to Command Center
  const organism = useOrganismState();
  const swarm = adaptToSwarmShape(organism);

  const { rSwarm, jDrift, continuityScore, trustScore, anomalyScore, simConfidence, beat, commsLost } = organism;

  return (
    <div style={S.root}>
      {/* ── Top navigation bar ─────────────────────────────────────────── */}
      <div style={S.topBar}>
        <div style={S.brand}>⬡ NOVA · PARALLAX</div>

        {NAV_ITEMS.map(nav => (
          <button
            key={nav.id}
            onClick={() => setView(nav.id)}
            style={S.navBtn(view === nav.id)}
          >
            <span>{nav.icon}</span> {nav.label}
          </button>
        ))}

        {/* Status scores */}
        <div style={S.statusRow}>
          <span style={{ color: commsLost ? '#f44' : '#3a6080' }}>
            BEAT {beat} {commsLost ? '⚠ COMMS LOST' : ''}
          </span>
          <TopScore label="K_c"  value={continuityScore} />
          <TopScore label="T_s"  value={trustScore} />
          <TopScore label="r"    value={rSwarm} warn={0.70} danger={0.55} />
          <TopScore label="SC"   value={simConfidence} />
          <span style={{ color: anomalyScore > 0.5 ? '#f44' : '#3a6080' }}>
            A_s: {(anomalyScore * 100).toFixed(0)}%
          </span>
          <span style={{ color: jDrift > 1.0 ? '#f44' : '#3a6080' }}>
            J(t): {jDrift.toFixed(3)}
          </span>
          <span style={{ color: '#246', fontSize: 7 }}>© 2026 Medina Tech · Alfredo Medina Hernandez</span>
        </div>
      </div>

      {/* ── Content area ─────────────────────────────────────────────────── */}
      <div style={S.content}>
        {/* ── ORO COMMAND CENTER — Multi-Agent Workspace ────────────────── */}
        {view === 'COMMAND' && (
          <OroCommandCenter organism={organism} />
        )}

        {/* ── DRONE SIMULATION — The Actual Experiment ────────────────────── */}
        {view === 'DRONES' && (
          <DroneSimulationWorld organism={organism} />
        )}

        {/* ── SWARM VIEW: original tactical simulation ────────────────── */}
        {view === 'SWARM' && (
          <div style={S.swarmRoot}>
            <div style={S.mapArea}>
              <div style={{ position: 'absolute', top: 12, left: 16, zIndex: 10, fontSize: 11, color: '#4af', letterSpacing: '0.12em', textTransform: 'uppercase', opacity: 0.8 }}>
                ⬡ PARALLAX SWARM SIM — MEDINA TECH — BEAT {beat}
              </div>
              <TacticalMap swarm={swarm} />
            </div>
            <div style={S.vitalsPanel}><SwarmVitals swarm={swarm} /></div>
            <div style={S.consolePanel}><CommandConsole swarm={swarm} /></div>
            <div style={S.organismPanel}><OrganismPanel swarm={swarm} /></div>
          </div>
        )}

        {/* ── ENTERPRISE HABITAT VIEWS ─────────────────────────────────── */}
        {view === 'HOME' && (
          <div style={S.habitatRoot}>
            <div style={S.habitatSidebar}><PresenceBoard organism={organism} /></div>
            <div style={S.habitatMain}><HomeNow organism={organism} /></div>
          </div>
        )}

        {view === 'WORKERS' && (
          <div style={{ width: '100%', height: '100%', overflowY: 'auto' }}>
            <WorkerHub organism={organism} />
          </div>
        )}

        {view === 'ARTIFACTS' && (
          <div style={{ width: '100%', height: '100%', overflowY: 'auto' }}>
            <ArtifactStudio organism={organism} />
          </div>
        )}

        {view === 'PRESENCE' && (
          <div style={{ width: '100%', height: '100%', overflowY: 'auto' }}>
            <PresenceBoard organism={organism} />
          </div>
        )}

        {view === 'SIMULATION' && (
          <div style={{ width: '100%', height: '100%' }}>
            <SimulationChamber organism={organism} />
          </div>
        )}

        {/* ── EMERGENCE LAB — Kuramoto Phase Sync Observatory ─────────── */}
        {view === 'EMERGENCE' && (
          <EmergenceLab organism={organism} />
        )}

        {/* ── MATH & PHYSICS LAB — All Governing Equations Live ────────── */}
        {view === 'MATHPHYSICS' && (
          <MathPhysicsLab organism={organism} />
        )}

        {/* ── NEUROSCIENCE & COGNITIVE LAB — Brain Architecture Observer ─ */}
        {view === 'NEUROCOG' && (
          <NeuroCogLab organism={organism} />
        )}
      </div>
    </div>
  );
}
