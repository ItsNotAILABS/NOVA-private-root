// ═══════════════════════════════════════════════════════════════════════════
// NOVA BUILDER — Sovereign CaffeineAI Replacement (Build №42)
// Language: CPL (TypeScript + JSX substrate)
// Non-Profit · Permissionless · On-Chain · Cannot Be Shut Down
// Powered by NOVA organism · Medina Tech · 2026
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { NovaBuilderLanding }   from './NovaBuilderLanding';
import { NovaBuilderDashboard } from './NovaBuilderDashboard';

type NovaBuilderView = 'LANDING' | 'BUILDER';

export function NovaBuilderApp() {
  const [view, setView] = useState<NovaBuilderView>('LANDING');

  return (
    <div style={{ width: '100%', height: '100%', overflow: 'hidden' }}>
      {view === 'LANDING' && (
        <NovaBuilderLanding onLaunch={() => setView('BUILDER')} />
      )}
      {view === 'BUILDER' && (
        <NovaBuilderDashboard />
      )}
    </div>
  );
}
