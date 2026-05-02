// ═══════════════════════════════════════════════════════════════════════════════
// FLIGHT STATUS — Real-time Flight Tracking Component
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect } from 'react';

interface FlightStatusProps {
  passengerId: string;
}

interface Flight {
  flightNumber: string;
  airline: string;
  from: string;
  to: string;
  departure: string;
  arrival: string;
  gate: string;
  status: 'On Time' | 'Boarding' | 'Delayed' | 'Departed';
  delay?: number;
}

export function FlightStatus({ passengerId }: FlightStatusProps) {
  // Mock flight data for pilot
  const [flights, setFlights] = useState<Flight[]>([
    {
      flightNumber: 'AA1234',
      airline: 'American Airlines',
      from: 'DFW',
      to: 'LAX',
      departure: '14:30',
      arrival: '16:45',
      gate: 'A7',
      status: 'Boarding'
    },
    {
      flightNumber: 'UA5678',
      airline: 'United Airlines',
      from: 'LAX',
      to: 'SFO',
      departure: '18:00',
      arrival: '19:20',
      gate: 'B12',
      status: 'On Time'
    }
  ]);

  return (
    <div>
      <h2 style={{ marginBottom: '2rem' }}>My Flights</h2>

      <div style={{
        display: 'grid',
        gap: '1.5rem',
        gridTemplateColumns: 'repeat(auto-fit, minmax(400px, 1fr))'
      }}>
        {flights.map(flight => (
          <div
            key={flight.flightNumber}
            style={{
              background: 'rgba(255, 255, 255, 0.05)',
              borderRadius: '12px',
              padding: '1.5rem',
              border: '1px solid rgba(255, 255, 255, 0.1)',
              position: 'relative',
              overflow: 'hidden'
            }}
          >
            {/* Status Badge */}
            <div style={{
              position: 'absolute',
              top: '1rem',
              right: '1rem',
              padding: '0.5rem 1rem',
              borderRadius: '6px',
              background: flight.status === 'On Time' ? 'rgba(46, 204, 113, 0.2)' :
                          flight.status === 'Boarding' ? 'rgba(52, 152, 219, 0.2)' :
                          flight.status === 'Delayed' ? 'rgba(231, 76, 60, 0.2)' :
                          'rgba(149, 165, 166, 0.2)',
              border: `1px solid ${flight.status === 'On Time' ? 'rgba(46, 204, 113, 0.4)' :
                                   flight.status === 'Boarding' ? 'rgba(52, 152, 219, 0.4)' :
                                   flight.status === 'Delayed' ? 'rgba(231, 76, 60, 0.4)' :
                                   'rgba(149, 165, 166, 0.4)'}`,
              fontSize: '0.9rem',
              fontWeight: 'bold'
            }}>
              {flight.status}
            </div>

            {/* Flight Info */}
            <div style={{ marginBottom: '1rem' }}>
              <h3 style={{ margin: 0, fontSize: '1.5rem' }}>
                {flight.flightNumber}
              </h3>
              <p style={{ margin: '0.25rem 0', color: '#95a5a6', fontSize: '0.9rem' }}>
                {flight.airline}
              </p>
            </div>

            {/* Route */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              marginBottom: '1rem'
            }}>
              <div style={{ textAlign: 'left' }}>
                <div style={{ fontSize: '2rem', fontWeight: 'bold' }}>
                  {flight.from}
                </div>
                <div style={{ fontSize: '0.9rem', color: '#95a5a6' }}>
                  {flight.departure}
                </div>
              </div>

              <div style={{ flex: 1, textAlign: 'center', padding: '0 1rem' }}>
                <div style={{
                  height: '2px',
                  background: 'linear-gradient(90deg, transparent, #f39c12, transparent)',
                  position: 'relative'
                }}>
                  <div style={{
                    position: 'absolute',
                    top: '-8px',
                    left: '50%',
                    transform: 'translateX(-50%)',
                    fontSize: '1.2rem'
                  }}>
                    ✈
                  </div>
                </div>
              </div>

              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: '2rem', fontWeight: 'bold' }}>
                  {flight.to}
                </div>
                <div style={{ fontSize: '0.9rem', color: '#95a5a6' }}>
                  {flight.arrival}
                </div>
              </div>
            </div>

            {/* Gate */}
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              padding: '1rem',
              background: 'rgba(243, 156, 18, 0.1)',
              borderRadius: '8px',
              marginTop: '1rem'
            }}>
              <span style={{ color: '#95a5a6' }}>Gate:</span>
              <span style={{ fontWeight: 'bold', fontSize: '1.2rem' }}>
                {flight.gate}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
