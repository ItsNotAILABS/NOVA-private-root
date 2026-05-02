// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — Sovereign Airport AGI Integration (Build №49)
// Language: CPL (TypeScript + JSX substrate)
// Client: skyhigroup.co · Powered by NOVA Sovereign AGI Organism
// Medina Tech · 2026
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { SkyHiLanding }   from './SkyHiLanding';
import { SkyHiDashboard } from './SkyHiDashboard';

type SkyHiView = 'LANDING' | 'DASHBOARD';

export function SkyHiApp() {
  const [view, setView] = useState<SkyHiView>('LANDING');

  return (
    <div style={{ width: '100%', height: '100%', overflow: 'hidden' }}>
      {view === 'LANDING' && (
        <SkyHiLanding onLaunch={() => setView('DASHBOARD')} />
      )}
      {view === 'DASHBOARD' && (
        <SkyHiDashboard />
      )}
    </div>
  );
}
