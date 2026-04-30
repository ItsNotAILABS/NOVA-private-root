// ═══════════════════════════════════════════════════════════════════════════
// PARALLAX APP SHELL — Routes landing ↔ dashboard
// Language: TypeScript + React (CPL: orchestration layer)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { ParallaxLanding }   from './ParallaxLanding';
import { ParallaxDashboard } from './ParallaxDashboard';

type ParallaxView = 'LANDING' | 'APP';

export function ParallaxApp() {
  const [view, setView] = useState<ParallaxView>('LANDING');

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative' }}>
      {/* Back to landing from dashboard */}
      {view === 'APP' && (
        <div style={{
          position: 'absolute',
          top: 0,
          right: 0,
          zIndex: 100,
          display: 'flex',
          alignItems: 'center',
        }}>
          {/* back btn is embedded in dashboard header gap */}
        </div>
      )}

      {view === 'LANDING' && (
        <ParallaxLanding onLaunch={() => setView('APP')} />
      )}

      {view === 'APP' && (
        <ParallaxDashboard />
      )}
    </div>
  );
}
