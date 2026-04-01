// PARALLAX DRONE SWARM SIMULATION — Frontend
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import React, { useEffect, useRef, useState, useCallback } from 'react';
import TacticalMap from './components/TacticalMap.jsx';
import SwarmVitals from './components/SwarmVitals.jsx';
import CommandConsole from './components/CommandConsole.jsx';
import { useSwarmState } from './hooks/useSwarmState.js';

const styles = {
  root: {
    display: 'grid',
    gridTemplateColumns: '1fr 320px',
    gridTemplateRows: '1fr 280px',
    width: '100vw',
    height: '100vh',
    background: '#050a14',
    gap: '2px',
    overflow: 'hidden',
  },
  mapArea: {
    gridColumn: '1',
    gridRow: '1 / 3',
    position: 'relative',
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
  header: {
    position: 'absolute',
    top: 12,
    left: 16,
    zIndex: 10,
    fontSize: '11px',
    color: '#4af',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
    opacity: 0.8,
  },
  attribution: {
    position: 'absolute',
    bottom: 8,
    left: 16,
    zIndex: 10,
    fontSize: '9px',
    color: '#246',
    letterSpacing: '0.08em',
  },
};

export default function App() {
  const swarm = useSwarmState();

  return (
    <div style={styles.root}>
      <div style={styles.mapArea}>
        <div style={styles.header}>
          ⬡ PARALLAX SWARM SIM — MEDINA TECH — BEAT {swarm.beat}
        </div>
        <TacticalMap swarm={swarm} />
        <div style={styles.attribution}>
          © 2026 Medina Tech | Alfredo Medina Hernandez | Dallas, TX
        </div>
      </div>
      <div style={styles.vitalsPanel}>
        <SwarmVitals swarm={swarm} />
      </div>
      <div style={styles.consolePanel}>
        <CommandConsole swarm={swarm} />
      </div>
    </div>
  );
}
