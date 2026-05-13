// ═══════════════════════════════════════════════════════════════════════════════
// AIRPORT PASSENGER — Landing Page
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';

interface LandingProps {
  onLogin: (passengerId: string) => void;
}

export function Landing({ onLogin }: LandingProps) {
  const [passengerId, setPassengerId] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (passengerId.trim()) {
      onLogin(passengerId.trim());
    }
  };

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '100vh',
      padding: '2rem'
    }}>
      <div style={{
        maxWidth: '600px',
        textAlign: 'center'
      }}>
        <h1 style={{
          fontSize: '3rem',
          marginBottom: '1rem',
          background: 'linear-gradient(135deg, #f39c12, #e74c3c)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          fontWeight: 'bold'
        }}>
          ✈ NOVA Airport
        </h1>

        <h2 style={{
          fontSize: '1.5rem',
          marginBottom: '2rem',
          color: '#bdc3c7'
        }}>
          BUILD №49 — Sovereign Airport Intelligence
        </h2>

        <div style={{
          background: 'rgba(255, 255, 255, 0.05)',
          borderRadius: '12px',
          padding: '2rem',
          marginBottom: '2rem',
          border: '1px solid rgba(255, 255, 255, 0.1)'
        }}>
          <p style={{ marginBottom: '1rem', fontSize: '1.1rem' }}>
            Welcome to NOVA V5 Airport Application
          </p>
          <p style={{ marginBottom: '1rem', color: '#95a5a6' }}>
            • Real-time flight tracking & gate updates<br />
            • AI-powered travel concierge<br />
            • Social matching in lounges<br />
            • AEROPORTO loyalty tokens<br />
            • Last-minute booking engine
          </p>
        </div>

        <form onSubmit={handleSubmit} style={{
          display: 'flex',
          flexDirection: 'column',
          gap: '1rem'
        }}>
          <input
            type="text"
            placeholder="Enter Passenger ID or Email"
            value={passengerId}
            onChange={(e) => setPassengerId(e.target.value)}
            style={{
              padding: '1rem',
              borderRadius: '8px',
              border: '1px solid rgba(255, 255, 255, 0.2)',
              background: 'rgba(255, 255, 255, 0.05)',
              color: '#e0e0e0',
              fontSize: '1rem'
            }}
          />

          <button
            type="submit"
            style={{
              padding: '1rem 2rem',
              borderRadius: '8px',
              border: 'none',
              background: 'linear-gradient(135deg, #f39c12, #e74c3c)',
              color: 'white',
              fontSize: '1.1rem',
              fontWeight: 'bold',
              cursor: 'pointer',
              transition: 'transform 0.2s'
            }}
            onMouseOver={(e) => e.currentTarget.style.transform = 'scale(1.05)'}
            onMouseOut={(e) => e.currentTarget.style.transform = 'scale(1)'}
          >
            Check In
          </button>
        </form>

        <p style={{
          marginTop: '2rem',
          fontSize: '0.9rem',
          color: '#7f8c8d'
        }}>
          Powered by NOVA Layer Zero • φ-Optimized • 873ms Heartbeat
        </p>

        <p style={{
          marginTop: '1rem',
          fontSize: '0.8rem',
          color: '#555'
        }}>
          © 2024-2026 Alfredo Medina Hernandez • Medina Tech • Dallas, Texas
        </p>
      </div>
    </div>
  );
}
