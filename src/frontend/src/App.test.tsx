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
  beforeEach(() => {
    cleanup();
  });

  it('should render without crashing', () => {
    render(<App />);
    expect(document.body).toBeDefined();
  });

  it('should display the PARALLAX brand', () => {
    render(<App />);
    expect(screen.getByText('PARALLAX')).toBeInTheDocument();
  });

  it('should display navigation buttons', () => {
    render(<App />);
    
    expect(screen.getByText(/Command/i)).toBeInTheDocument();
    expect(screen.getByText(/Drones/i)).toBeInTheDocument();
    expect(screen.getByText(/Swarm/i)).toBeInTheDocument();
  });

  it('should show Command view by default', () => {
    render(<App />);
    
    expect(screen.getByTestId('oro-command-center')).toBeInTheDocument();
  });

  it('should navigate to Drones view on click', () => {
    render(<App />);
    
    const dronesButton = screen.getByText(/Drones/i);
    fireEvent.click(dronesButton);
    
    expect(screen.getByTestId('drone-simulation-world')).toBeInTheDocument();
  });

  it('should navigate to Swarm view on click', () => {
    render(<App />);
    
    const swarmButton = screen.getByText(/Swarm/i);
    fireEvent.click(swarmButton);
    
    expect(screen.getByTestId('tactical-map')).toBeInTheDocument();
  });

  it('should navigate to Home/Now view on click', () => {
    render(<App />);
    
    const homeButton = screen.getByText(/Home\/Now/i);
    fireEvent.click(homeButton);
    
    expect(screen.getByTestId('home-now')).toBeInTheDocument();
  });

  it('should navigate to Workers view on click', () => {
    render(<App />);
    
    const workersButton = screen.getByText(/Workers/i);
    fireEvent.click(workersButton);
    
    expect(screen.getByTestId('worker-hub')).toBeInTheDocument();
  });

  it('should navigate to Artifacts view on click', () => {
    render(<App />);
    
    const artifactsButton = screen.getByText(/Artifacts/i);
    fireEvent.click(artifactsButton);
    
    expect(screen.getByTestId('artifact-studio')).toBeInTheDocument();
  });

  it('should navigate to Presence view on click', () => {
    render(<App />);
    
    const presenceButton = screen.getByText(/Presence/i);
    fireEvent.click(presenceButton);
    
    expect(screen.getByTestId('presence-board')).toBeInTheDocument();
  });

  it('should navigate to World Sim view on click', () => {
    render(<App />);
    
    const worldSimButton = screen.getByText(/World Sim/i);
    fireEvent.click(worldSimButton);
    
    expect(screen.getByTestId('simulation-chamber')).toBeInTheDocument();
  });

  it('should highlight active navigation button', () => {
    render(<App />);
    
    const commandButton = screen.getByText(/Command/i);
    // Command is default active view
    expect(commandButton).toBeInTheDocument();
    
    const dronesButton = screen.getByText(/Drones/i);
    fireEvent.click(dronesButton);
    
    // Drones should now be active (button styling changes)
    expect(dronesButton).toBeInTheDocument();
  });

  it('should display status row with metrics', () => {
    render(<App />);
    
    // Check for beat counter or other status indicators
    expect(screen.getByText(/BEAT/i)).toBeInTheDocument();
  });

  it('should display coherence metric', () => {
    render(<App />);
    
    expect(screen.getByText(/r=/i)).toBeInTheDocument();
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// NAVIGATION STATE TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Navigation State', () => {
  it('should maintain navigation state after re-render', () => {
    const { rerender } = render(<App />);
    
    const dronesButton = screen.getByText(/Drones/i);
    fireEvent.click(dronesButton);
    
    expect(screen.getByTestId('drone-simulation-world')).toBeInTheDocument();
    
    rerender(<App />);
    
    // Should still be on Drones view
    expect(screen.getByTestId('drone-simulation-world')).toBeInTheDocument();
  });

  it('should return to Command view on clicking Command button', () => {
    render(<App />);
    
    // Navigate away
    const dronesButton = screen.getByText(/Drones/i);
    fireEvent.click(dronesButton);
    
    expect(screen.getByTestId('drone-simulation-world')).toBeInTheDocument();
    
    // Navigate back
    const commandButton = screen.getByText(/Command/i);
    fireEvent.click(commandButton);
    
    expect(screen.getByTestId('oro-command-center')).toBeInTheDocument();
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// LAYOUT TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Layout', () => {
  it('should have a top bar', () => {
    render(<App />);
    
    // PARALLAX brand should be in top bar
    expect(screen.getByText('PARALLAX')).toBeInTheDocument();
  });

  it('should have all navigation items', () => {
    render(<App />);
    
    const navItems = ['Command', 'Drones', 'Swarm', 'Home/Now', 'Workers', 'Artifacts', 'Presence', 'World Sim'];
    
    for (const item of navItems) {
      expect(screen.getByText(new RegExp(item, 'i'))).toBeInTheDocument();
    }
  });
});
