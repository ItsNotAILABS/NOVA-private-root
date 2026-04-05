// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  APP COMPONENT TEST SUITE                                                                                 ║
// ║  Tests for the main App component and navigation                                                          ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, cleanup } from '@testing-library/react';
import React from 'react';
import App from './App';

// Mock heavy dependencies
vi.mock('./hooks/useOrganismState', () => ({
  useOrganismState: () => ({
    beat: 100,
    drones: [],
    rSwarm: 0.85,
    psi: 0.5,
    jDrift: 0.1,
    swarmQCoherence: 0.75,
    swarmConvergence: 0.7,
    swarmNowAttention: 0.8,
    continuityScore: 0.85,
    trustScore: 0.80,
    anomalyScore: 0.05,
    loadPulseScore: 0.20,
    simConfidence: 0.75,
    world: null,
    macroState: null,
    enterprise: null,
    missionStatus: 'IDLE',
    missionName: '',
    emergencyActive: false,
    commsLost: false,
    architectSignal: 0.5,
    pendingActions: [],
    auditLog: [],
    setArchitectSignal: vi.fn(),
    approve: vi.fn(),
    deny: vi.fn(),
    emergencyStop: vi.fn(),
    startMission: vi.fn(),
    heartbeat: vi.fn(),
  }),
}));

// Mock child components to isolate App tests
vi.mock('./components/TacticalMap.jsx', () => ({
  default: () => <div data-testid="tactical-map">TacticalMap</div>,
}));

vi.mock('./components/SwarmVitals.jsx', () => ({
  default: () => <div data-testid="swarm-vitals">SwarmVitals</div>,
}));

vi.mock('./components/CommandConsole.jsx', () => ({
  default: () => <div data-testid="command-console">CommandConsole</div>,
}));

vi.mock('./components/OrganismPanel.jsx', () => ({
  default: () => <div data-testid="organism-panel">OrganismPanel</div>,
}));

vi.mock('./components/habitat/HomeNow', () => ({
  HomeNow: () => <div data-testid="home-now">HomeNow</div>,
}));

vi.mock('./components/habitat/WorkerHub', () => ({
  WorkerHub: () => <div data-testid="worker-hub">WorkerHub</div>,
}));

vi.mock('./components/habitat/ArtifactStudio', () => ({
  ArtifactStudio: () => <div data-testid="artifact-studio">ArtifactStudio</div>,
}));

vi.mock('./components/habitat/PresenceBoard', () => ({
  PresenceBoard: () => <div data-testid="presence-board">PresenceBoard</div>,
}));

vi.mock('./components/simulation/SimulationChamber', () => ({
  SimulationChamber: () => <div data-testid="simulation-chamber">SimulationChamber</div>,
}));

vi.mock('./components/CommandCenter/OroCommandCenter', () => ({
  OroCommandCenter: () => <div data-testid="oro-command-center">OroCommandCenter</div>,
}));

vi.mock('./components/CommandCenter/DroneSimulationWorld', () => ({
  DroneSimulationWorld: () => <div data-testid="drone-simulation-world">DroneSimulationWorld</div>,
}));

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('App Component', () => {
  afterEach(() => {
    cleanup();
  });

  it('should render without crashing', () => {
    const { container } = render(<App />);
    expect(container).toBeDefined();
  });

  it('should display beat counter in status row', () => {
    render(<App />);
    expect(screen.getByText(/BEAT/i)).toBeInTheDocument();
  });

  it('should display copyright text', () => {
    render(<App />);
    // Use getAllByText since there might be multiple occurrences
    const copyrightElements = screen.getAllByText(/Medina Tech/i);
    expect(copyrightElements.length).toBeGreaterThan(0);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// LAYOUT TESTS  
// ═══════════════════════════════════════════════════════════════════════════════

describe('Layout', () => {
  afterEach(() => {
    cleanup();
  });

  it('should render the main container', () => {
    const { container } = render(<App />);
    expect(container.firstChild).toBeDefined();
  });
});
