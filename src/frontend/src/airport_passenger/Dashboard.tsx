// ═══════════════════════════════════════════════════════════════════════════════
// AIRPORT PASSENGER — Dashboard
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect } from 'react';
import { FlightStatus } from './FlightStatus';
import { Concierge } from './Concierge';
import { LoyaltyRewards } from './LoyaltyRewards';

interface DashboardProps {
  passengerId: string;
  onLogout: () => void;
}

type TabView = 'flights' | 'concierge' | 'loyalty' | 'social';

export function Dashboard({ passengerId, onLogout }: DashboardProps) {
  const [activeTab, setActiveTab] = useState<TabView>('flights');
  const [tokenBalance, setTokenBalance] = useState(100); // Mock initial balance

  return (
    <div style={{
      width: '100%',
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column'
    }}>
      {/* Header */}
      <header style={{
        background: 'rgba(0, 0, 0, 0.3)',
        padding: '1rem 2rem',
        borderBottom: '1px solid rgba(255, 255, 255, 0.1)',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center'
      }}>
        <div>
          <h1 style={{ margin: 0, fontSize: '1.5rem' }}>✈ NOVA Airport</h1>
          <p style={{ margin: '0.25rem 0 0 0', fontSize: '0.9rem', color: '#95a5a6' }}>
            Passenger ID: {passengerId}
          </p>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          <div style={{
            background: 'rgba(243, 156, 18, 0.2)',
            padding: '0.5rem 1rem',
            borderRadius: '8px',
            border: '1px solid rgba(243, 156, 18, 0.4)'
          }}>
            <span style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>
              {tokenBalance} ⬡
            </span>
            <span style={{ fontSize: '0.8rem', marginLeft: '0.5rem', color: '#95a5a6' }}>
              AEROPORTO
            </span>
          </div>

          <button
            onClick={onLogout}
            style={{
              padding: '0.5rem 1rem',
              borderRadius: '6px',
              border: '1px solid rgba(255, 255, 255, 0.2)',
              background: 'rgba(255, 255, 255, 0.05)',
              color: '#e0e0e0',
              cursor: 'pointer'
            }}
          >
            Logout
          </button>
        </div>
      </header>

      {/* Navigation Tabs */}
      <nav style={{
        background: 'rgba(0, 0, 0, 0.2)',
        padding: '0 2rem',
        borderBottom: '1px solid rgba(255, 255, 255, 0.1)',
        display: 'flex',
        gap: '2rem'
      }}>
        {[
          { id: 'flights', label: 'My Flights', icon: '✈' },
          { id: 'concierge', label: 'AI Concierge', icon: '🤖' },
          { id: 'loyalty', label: 'Loyalty & Rewards', icon: '⬡' },
          { id: 'social', label: 'Lounge Social', icon: '👥' }
        ].map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id as TabView)}
            style={{
              padding: '1rem 0',
              border: 'none',
              background: 'none',
              color: activeTab === tab.id ? '#f39c12' : '#95a5a6',
              borderBottom: activeTab === tab.id ? '3px solid #f39c12' : '3px solid transparent',
              cursor: 'pointer',
              fontSize: '1rem',
              fontWeight: activeTab === tab.id ? 'bold' : 'normal',
              transition: 'all 0.3s'
            }}
          >
            {tab.icon} {tab.label}
          </button>
        ))}
      </nav>

      {/* Main Content */}
      <main style={{
        flex: 1,
        padding: '2rem',
        overflow: 'auto'
      }}>
        {activeTab === 'flights' && <FlightStatus passengerId={passengerId} />}
        {activeTab === 'concierge' && <Concierge passengerId={passengerId} />}
        {activeTab === 'loyalty' && <LoyaltyRewards passengerId={passengerId} tokenBalance={tokenBalance} />}
        {activeTab === 'social' && (
          <div style={{
            background: 'rgba(255, 255, 255, 0.05)',
            borderRadius: '12px',
            padding: '2rem',
            textAlign: 'center'
          }}>
            <h2>Lounge Social Matching</h2>
            <p style={{ color: '#95a5a6', marginTop: '1rem' }}>
              Feature coming soon: Connect with fellow travelers who share your interests!
            </p>
          </div>
        )}
      </main>

      {/* Footer */}
      <footer style={{
        background: 'rgba(0, 0, 0, 0.3)',
        padding: '1rem 2rem',
        borderTop: '1px solid rgba(255, 255, 255, 0.1)',
        textAlign: 'center',
        fontSize: '0.8rem',
        color: '#7f8c8d'
      }}>
        BUILD №49 • Heartbeat: 873ms • φ-Optimized • NOVA Layer Zero
      </footer>
    </div>
  );
}
