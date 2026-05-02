// ═══════════════════════════════════════════════════════════════════════════════
// AIRPORT PASSENGER APP — Main Entry Point
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// MEDINA TECH — SOVEREIGN ORGANISM ARCHITECTURE
//
// Airport Passenger Experience Application
// Sovereign CPL frontend for real-time passenger services, flight tracking,
// booking, concierge, social matching, and AEROPORTO loyalty tokens.
//
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { Landing } from './Landing';
import { Dashboard } from './Dashboard';

export type AirportView = 'landing' | 'dashboard';

export function AirportPassengerApp() {
  const [currentView, setCurrentView] = useState<AirportView>('landing');
  const [passengerId, setPassengerId] = useState<string | null>(null);

  const handleLogin = (pid: string) => {
    setPassengerId(pid);
    setCurrentView('dashboard');
  };

  const handleLogout = () => {
    setPassengerId(null);
    setCurrentView('landing');
  };

  return (
    <div className="airport-passenger-app" style={{
      width: '100%',
      height: '100vh',
      background: 'linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)',
      color: '#e0e0e0',
      overflow: 'auto'
    }}>
      {currentView === 'landing' && (
        <Landing onLogin={handleLogin} />
      )}

      {currentView === 'dashboard' && passengerId && (
        <Dashboard passengerId={passengerId} onLogout={handleLogout} />
      )}
    </div>
  );
}
