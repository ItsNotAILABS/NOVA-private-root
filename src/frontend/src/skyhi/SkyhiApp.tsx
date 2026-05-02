// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — Enterprise Client Portal App Shell
// Route: /skyhi-client  |  Build №49
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { SkyhiLanding } from './SkyhiLanding';
import { SkyhiPortal }  from './SkyhiPortal';

type SkyhiView = 'LANDING' | 'PORTAL';

export function SkyhiApp() {
  const [view,     setView]     = useState<SkyhiView>('LANDING');
  const [clientId, setClientId] = useState('');

  const handleAccess  = (id: string) => { setClientId(id); setView('PORTAL'); };
  const handleSignOut = ()            => { setClientId(''); setView('LANDING'); };

  return (
    <div style={{ width: '100%', height: '100%', overflow: 'hidden' }}>
      {view === 'LANDING' && (
        <SkyhiLanding onAccess={handleAccess} />
      )}
      {view === 'PORTAL' && (
        <SkyhiPortal clientId={clientId} onSignOut={handleSignOut} />
      )}
    </div>
  );
}
