// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — Sovereign Client Portal Landing
// IRONCLAD glassmorphism: dark void · sky-blue · gold
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';

interface Props {
  onAccess: (clientId: string) => void;
}

// ── Glassmorphism palette ─────────────────────────────────────────────────
const SKY  = '#44aaff';
const GOLD = '#d4af37';
const VOID = '#050a14';

const S = {
  root: {
    width: '100%',
    height: '100%',
    background: VOID,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontFamily: "'Courier New', monospace",
    position: 'relative' as const,
    overflow: 'hidden',
  },
  // ambient grid
  grid: {
    position: 'absolute' as const,
    inset: 0,
    backgroundImage: `
      linear-gradient(rgba(68,170,255,0.04) 1px, transparent 1px),
      linear-gradient(90deg, rgba(68,170,255,0.04) 1px, transparent 1px)
    `,
    backgroundSize: '48px 48px',
    pointerEvents: 'none' as const,
  },
  // vignette
  vignette: {
    position: 'absolute' as const,
    inset: 0,
    background: `radial-gradient(ellipse at center, transparent 40%, ${VOID} 100%)`,
    pointerEvents: 'none' as const,
  },
  card: {
    position: 'relative' as const,
    width: 480,
    background: 'rgba(5,10,20,0.88)',
    backdropFilter: 'blur(18px)',
    border: `1px solid rgba(68,170,255,0.35)`,
    borderRadius: 4,
    boxShadow: `0 0 60px rgba(68,170,255,0.08), 0 0 0 1px rgba(68,170,255,0.1) inset`,
    padding: '40px 44px 36px',
  },
  topAccent: {
    height: 2,
    background: `linear-gradient(90deg, transparent, ${SKY}, ${GOLD}, ${SKY}, transparent)`,
    marginBottom: 36,
    borderRadius: 1,
  },
  logoRow: {
    display: 'flex',
    alignItems: 'center',
    gap: 14,
    marginBottom: 8,
  },
  logoHex: {
    fontSize: 28,
    color: SKY,
    lineHeight: 1,
  },
  logoText: {
    flex: 1,
  },
  logoTitle: {
    fontSize: 16,
    fontWeight: 700,
    color: '#e8f4ff',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
  },
  logoSub: {
    fontSize: 9,
    color: SKY,
    letterSpacing: '0.22em',
    textTransform: 'uppercase' as const,
    opacity: 0.7,
  },
  divider: {
    borderTop: `1px solid rgba(68,170,255,0.15)`,
    margin: '24px 0',
  },
  eyebrow: {
    fontSize: 8,
    color: GOLD,
    letterSpacing: '0.28em',
    textTransform: 'uppercase' as const,
    marginBottom: 6,
  },
  headline: {
    fontSize: 22,
    fontWeight: 700,
    color: '#e8f4ff',
    lineHeight: 1.3,
    marginBottom: 6,
  },
  subline: {
    fontSize: 10,
    color: 'rgba(200,220,255,0.5)',
    letterSpacing: '0.08em',
    marginBottom: 32,
  },
  label: {
    fontSize: 9,
    color: SKY,
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    marginBottom: 6,
    display: 'block',
  },
  input: {
    width: '100%',
    background: 'rgba(10,20,40,0.6)',
    border: `1px solid rgba(68,170,255,0.3)`,
    borderRadius: 3,
    padding: '10px 14px',
    fontSize: 13,
    color: '#e8f4ff',
    fontFamily: "'Courier New', monospace",
    outline: 'none',
    boxSizing: 'border-box' as const,
    marginBottom: 16,
    letterSpacing: '0.04em',
  },
  btnRow: {
    marginTop: 8,
  },
  btn: (active: boolean) => ({
    width: '100%',
    padding: '13px 0',
    background: active
      ? `linear-gradient(135deg, rgba(68,170,255,0.18), rgba(212,175,55,0.12))`
      : 'rgba(68,170,255,0.06)',
    border: `1px solid ${active ? SKY : 'rgba(68,170,255,0.25)'}`,
    borderRadius: 3,
    color: active ? '#e8f4ff' : 'rgba(200,220,255,0.4)',
    fontSize: 11,
    letterSpacing: '0.22em',
    textTransform: 'uppercase' as const,
    cursor: active ? 'pointer' : 'not-allowed',
    fontFamily: "'Courier New', monospace",
    fontWeight: 700,
    transition: 'all 0.15s',
  }),
  errorMsg: {
    fontSize: 10,
    color: '#ff6060',
    letterSpacing: '0.06em',
    marginTop: 10,
  },
  tierRow: {
    display: 'flex',
    gap: 6,
    marginTop: 28,
    flexWrap: 'wrap' as const,
  },
  tierTag: (gold: boolean) => ({
    padding: '3px 9px',
    border: `1px solid ${gold ? GOLD : 'rgba(68,170,255,0.25)'}`,
    borderRadius: 2,
    fontSize: 8,
    color: gold ? GOLD : SKY,
    letterSpacing: '0.14em',
    textTransform: 'uppercase' as const,
    opacity: 0.8,
  }),
  footer: {
    marginTop: 28,
    fontSize: 8,
    color: 'rgba(100,130,160,0.5)',
    letterSpacing: '0.08em',
    textAlign: 'center' as const,
  },
};

// ── Hard-coded access credential for demo
// In production this would be ICP Internet Identity or a signed challenge
const SKYHI_ACCESS_CODE = 'SKYHI-2026';

export function SkyhiLanding({ onAccess }: Props) {
  const [code, setCode]     = useState('');
  const [error, setError]   = useState('');
  const [loading, setLoading] = useState(false);

  const canSubmit = code.trim().length >= 4;

  const handleSubmit = () => {
    if (!canSubmit) return;
    setLoading(true);
    setError('');
    // Validate access code (in production: Internet Identity + canister ACL check)
    setTimeout(() => {
      if (code.trim().toUpperCase() === SKYHI_ACCESS_CODE) {
        onAccess('SKYHI-GROUP-001');
      } else {
        setError('Invalid access credential. Contact your NOVA account executive.');
        setLoading(false);
      }
    }, 600);
  };

  return (
    <div style={S.root}>
      <div style={S.grid} />
      <div style={S.vignette} />

      <div style={S.card}>
        <div style={S.topAccent} />

        {/* Logo row */}
        <div style={S.logoRow}>
          <span style={S.logoHex}>⬡</span>
          <div style={S.logoText}>
            <div style={S.logoTitle}>NOVA · PARALLAX</div>
            <div style={S.logoSub}>Sovereign Enterprise Intelligence</div>
          </div>
          {/* Skyhi badge */}
          <div style={{
            padding: '4px 10px',
            border: `1px solid ${GOLD}`,
            borderRadius: 2,
            fontSize: 8,
            color: GOLD,
            letterSpacing: '0.18em',
            textTransform: 'uppercase' as const,
          }}>
            Skyhi Group
          </div>
        </div>

        <div style={S.divider} />

        {/* Headline */}
        <div style={S.eyebrow}>Enterprise Client Access Portal</div>
        <div style={S.headline}>Skyhi Group<br />Intelligence Gateway</div>
        <div style={S.subline}>
          Licensed access to NOVA's sovereign intelligence substrate.
          Live agent deployment · FORMA economy · VAEL defense coverage.
        </div>

        {/* Auth form */}
        <label style={S.label}>Client Access Credential</label>
        <input
          style={S.input}
          type="password"
          placeholder="Enter your access code…"
          value={code}
          onChange={e => setCode(e.target.value)}
          onKeyDown={e => e.key === 'Enter' && canSubmit && handleSubmit()}
          disabled={loading}
        />

        <div style={S.btnRow}>
          <button
            style={S.btn(canSubmit && !loading)}
            onClick={handleSubmit}
            disabled={!canSubmit || loading}
          >
            {loading ? 'Authenticating…' : '⬡ Access Portal'}
          </button>
        </div>

        {error && <div style={S.errorMsg}>⚠ {error}</div>}

        {/* Licensed layers */}
        <div style={S.tierRow}>
          <span style={S.tierTag(false)}>Kuramoto Swarm</span>
          <span style={S.tierTag(true)}>FORMA Economy</span>
          <span style={S.tierTag(false)}>VAEL Defense</span>
          <span style={S.tierTag(false)}>ARES Archive</span>
        </div>

        <div style={S.footer}>
          © 2026 Alfredo Medina Hernandez · Medina Tech · Dallas, TX · All rights reserved
        </div>
      </div>
    </div>
  );
}
