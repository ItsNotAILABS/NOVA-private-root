// ═══════════════════════════════════════════════════════════════════════════
// PHANTOM WALLET — App Shell
// Language: TypeScript + React (CPL: orchestration layer)
// Routes: Landing → Wallet dashboard
// Powered by PARALLAX · Medina Tech · 2026
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import { PhantomWalletLanding }   from './PhantomWalletLanding';
import { PhantomWalletDashboard } from './PhantomWalletDashboard';

type PhantomWalletView = 'LANDING' | 'WALLET';

export function PhantomWalletApp() {
  const [view, setView] = useState<PhantomWalletView>('LANDING');

  return (
    <div style={{ width: '100%', height: '100%', overflow: 'hidden' }}>
      {view === 'LANDING' && (
        <PhantomWalletLanding onLaunch={() => setView('WALLET')} />
      )}
      {view === 'WALLET' && (
        <PhantomWalletDashboard />
      )}
    </div>
  );
}
