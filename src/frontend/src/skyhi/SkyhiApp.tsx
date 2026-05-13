// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — Enterprise Client Portal App Shell
// Flow: Landing → NDA Gate → Website Demo / Portal (tabbed)
// Route: /skyhi-client  |  Build №50
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// CONFIDENTIAL — NDA-Protected
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { SkyhiLanding }     from './SkyhiLanding';
import { SkyhiNDA }         from './SkyhiNDA';
import { SkyhiWebsiteDemo } from './SkyhiWebsiteDemo';
import { SkyhiPortal }      from './SkyhiPortal';

type SkyhiView = 'LANDING' | 'NDA' | 'DEMO' | 'PORTAL';

export function SkyhiApp() {
  const [view,     setView]     = useState<SkyhiView>('LANDING');
  const [clientId, setClientId] = useState('');
  const [ndaSeal,  setNdaSeal]  = useState('');

  const handleAccess  = (id: string)   => { setClientId(id); setView('NDA'); };
  const handleNdaAccept = (seal: string) => { setNdaSeal(seal); setView('DEMO'); };
  const handleNdaDecline = ()           => { setView('LANDING'); };
  const handleSignOut = ()              => { setClientId(''); setNdaSeal(''); setView('LANDING'); };

  // Palette for the tab bar
  const SKY  = '#44aaff';
  const GOLD = '#d4af37';
  const DIM  = 'rgba(200,220,255,0.45)';

  return (
    <div style={{ width: '100%', height: '100%', overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>

      {/* LANDING */}
      {view === 'LANDING' && (
        <SkyhiLanding onAccess={handleAccess} />
      )}

      {/* NDA GATE */}
      {view === 'NDA' && (
        <SkyhiNDA
          clientId={clientId}
          onAccept={handleNdaAccept}
          onDecline={handleNdaDecline}
        />
      )}

      {/* DEMO + PORTAL — shared tab bar */}
      {(view === 'DEMO' || view === 'PORTAL') && (
        <>
          {/* Tab bar */}
          <div style={{
            height: 32, flexShrink: 0,
            background: 'rgba(5,10,25,0.95)',
            borderBottom: '1px solid rgba(68,170,255,0.2)',
            display: 'flex', alignItems: 'center',
            padding: '0 16px', gap: 6,
          }}>
            <span style={{ fontSize: 8, color: GOLD, letterSpacing: '0.2em', textTransform: 'uppercase', marginRight: 12 }}>
              🔒 NDA Active · Skyhi Group
            </span>

            {[
              { id: 'DEMO' as SkyhiView,   label: '⬡ Website Integration Demo' },
              { id: 'PORTAL' as SkyhiView,  label: '◈ Intelligence Portal' },
            ].map(tab => (
              <button
                key={tab.id}
                onClick={() => setView(tab.id)}
                style={{
                  padding: '3px 12px',
                  fontSize: 8,
                  background: view === tab.id ? 'rgba(68,170,255,0.12)' : 'transparent',
                  color: view === tab.id ? SKY : 'rgba(100,140,180,0.6)',
                  border: `1px solid ${view === tab.id ? SKY : 'transparent'}`,
                  borderRadius: 2,
                  cursor: 'pointer',
                  letterSpacing: '0.1em',
                  textTransform: 'uppercase',
                  fontFamily: "'Courier New', monospace",
                  display: 'flex', alignItems: 'center', gap: 5,
                }}
              >
                {tab.label}
              </button>
            ))}

            <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 10 }}>
              <span style={{ fontSize: 7, color: DIM }}>
                Seal: {ndaSeal.slice(0, 16)}…
              </span>
              <button
                onClick={handleSignOut}
                style={{
                  padding: '2px 8px',
                  background: 'transparent',
                  border: '1px solid rgba(255,68,68,0.2)',
                  borderRadius: 2,
                  color: 'rgba(255,100,100,0.6)',
                  fontSize: 7, cursor: 'pointer',
                  letterSpacing: '0.1em', textTransform: 'uppercase',
                  fontFamily: "'Courier New', monospace",
                }}
              >
                Sign Out
              </button>
            </div>
          </div>

          {/* Content */}
          <div style={{ flex: 1, overflow: 'hidden' }}>
            {view === 'DEMO' && (
              <SkyhiWebsiteDemo ndaSeal={ndaSeal} clientId={clientId} />
            )}
            {view === 'PORTAL' && (
              <SkyhiPortal clientId={clientId} onSignOut={handleSignOut} />
            )}
          </div>
        </>
      )}
    </div>
  );
}
