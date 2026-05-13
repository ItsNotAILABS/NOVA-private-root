// ═══════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// Module: skyhi_client/SkyHiLoginGate.tsx — Production Login Gate
// Language: TypeScript / CPL (sovereign protocol view)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// PRODUCTION AUTH GATE — Sovereign glassmorphism login for Skyhi Group.
// Uses real skyhi_group canister createSession via useSkyhiAuth hook.
// No bypass. No demo mode. Real client authentication.
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import type { ClientTier } from './useSkyhiAuth';

// ── Glassmorphism palette (matches SkyHiClientPortal.tsx) ─────────────────
const C = {
  void:       '#050a14',
  glass:      'rgba(5, 15, 35, 0.88)',
  glassHigh:  'rgba(8, 22, 50, 0.94)',
  sky:        '#38bdf8',
  skyDim:     '#0ea5e9',
  skyGlow:    'rgba(56, 189, 248, 0.12)',
  skyBorder:  'rgba(56, 189, 248, 0.22)',
  skyBorderHi:'rgba(56, 189, 248, 0.45)',
  gold:       '#f59e0b',
  goldDim:    '#d97706',
  goldGlow:   'rgba(245, 158, 11, 0.10)',
  goldBorder: 'rgba(245, 158, 11, 0.22)',
  green:      '#22c55e',
  red:        '#ef4444',
  redGlow:    'rgba(239, 68, 68, 0.12)',
  textPrimary:'#e2f3fd',
  textSecond: '#7db4d4',
  textDim:    '#3a6080',
};

// ── Props ────────────────────────────────────────────────────────────────
interface SkyHiLoginGateProps {
  onLogin: (clientId: string, accessKey: string, tier: ClientTier) => Promise<boolean>;
  loading: boolean;
  error: string | null;
}

// ═══════════════════════════════════════════════════════════════════════════
// LOGIN GATE
// ═══════════════════════════════════════════════════════════════════════════

export function SkyHiLoginGate({ onLogin, loading, error }: SkyHiLoginGateProps) {
  const [clientId,  setClientId]  = useState('');
  const [accessKey, setAccessKey] = useState('');
  const [tier,      setTier]      = useState<ClientTier>('sovereign');
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!clientId.trim() || !accessKey.trim() || submitting) return;
    setSubmitting(true);
    await onLogin(clientId.trim(), accessKey.trim(), tier);
    setSubmitting(false);
  };

  const isLoading = loading || submitting;

  const inputStyle: React.CSSProperties = {
    width:         '100%',
    padding:       '12px 16px',
    fontSize:      13,
    background:    'rgba(5, 15, 35, 0.7)',
    border:        `1px solid ${C.skyBorder}`,
    borderRadius:  8,
    color:         C.textPrimary,
    outline:       'none',
    letterSpacing: '0.04em',
    boxSizing:     'border-box',
  };

  const tierOptions: Array<{ value: ClientTier; label: string; sub: string }> = [
    { value: 'free',      label: 'FREE',      sub: 'Read-only access' },
    { value: 'basic',     label: 'BASIC',     sub: 'Kuramoto swarm' },
    { value: 'premium',   label: 'PREMIUM',   sub: 'Swarm + FORMA + VAEL' },
    { value: 'sovereign', label: 'SOVEREIGN',  sub: 'Full NOVA AGI access' },
  ];

  return (
    <div style={{
      width:          '100%',
      height:         '100%',
      background:     C.void,
      display:        'flex',
      alignItems:     'center',
      justifyContent: 'center',
      fontFamily:     'system-ui, -apple-system, monospace',
      color:          C.textPrimary,
      overflow:       'auto',
    }}>
      {/* Background glow */}
      <div style={{
        position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
        background: `radial-gradient(ellipse at 30% 20%, rgba(56, 189, 248, 0.06) 0%, transparent 60%),
                     radial-gradient(ellipse at 70% 80%, rgba(245, 158, 11, 0.04) 0%, transparent 60%)`,
        pointerEvents: 'none',
      }} />

      <div style={{
        position:      'relative',
        width:         '100%',
        maxWidth:      460,
        margin:        '0 24px',
      }}>
        {/* ── Header brand ─────────────────────────────────────────── */}
        <div style={{ textAlign: 'center', marginBottom: 32 }}>
          <div style={{
            width: 56, height: 56, borderRadius: 14, margin: '0 auto 16px',
            background: `linear-gradient(135deg, ${C.sky}, ${C.gold})`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 28, fontWeight: 900, color: C.void,
            boxShadow: `0 0 40px ${C.skyGlow}, 0 0 20px ${C.goldGlow}`,
          }}>S</div>
          <div style={{ fontSize: 20, fontWeight: 700, letterSpacing: '0.06em', marginBottom: 4 }}>
            SKYHI GROUP
          </div>
          <div style={{ fontSize: 10, color: C.gold, letterSpacing: '0.2em', textTransform: 'uppercase' }}>
            Enterprise Intelligence Portal
          </div>
          <div style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.14em', marginTop: 8 }}>
            Sovereign access to NOVA intelligence · Production environment
          </div>
        </div>

        {/* ── Login card ───────────────────────────────────────────── */}
        <div style={{
          background:    C.glassHigh,
          border:        `1px solid ${C.skyBorderHi}`,
          borderRadius:  16,
          backdropFilter:'blur(20px)',
          boxShadow:     `0 0 48px ${C.skyGlow}, 0 0 4px ${C.skyBorder}, inset 0 1px 0 rgba(255,255,255,0.06)`,
          padding:       '32px 28px',
        }}>
          <div style={{ fontSize: 11, color: C.textSecond, letterSpacing: '0.12em', textTransform: 'uppercase', marginBottom: 20 }}>
            ⬡ CLIENT AUTHENTICATION
          </div>

          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            {/* Client ID */}
            <div>
              <label style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.14em', textTransform: 'uppercase', display: 'block', marginBottom: 6 }}>
                CLIENT IDENTIFIER
              </label>
              <input
                type="text"
                value={clientId}
                onChange={e => setClientId(e.target.value)}
                placeholder="e.g. skyhi-group-dfw"
                disabled={isLoading}
                autoComplete="username"
                style={inputStyle}
              />
            </div>

            {/* Access Key */}
            <div>
              <label style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.14em', textTransform: 'uppercase', display: 'block', marginBottom: 6 }}>
                ACCESS KEY
              </label>
              <input
                type="password"
                value={accessKey}
                onChange={e => setAccessKey(e.target.value)}
                placeholder="Enter your enterprise access key"
                disabled={isLoading}
                autoComplete="current-password"
                style={{ ...inputStyle, letterSpacing: '0.12em' }}
              />
              <div style={{ fontSize: 8, color: C.textDim, marginTop: 4 }}>
                SHA-256 hashed before transmission · never stored in plaintext
              </div>
            </div>

            {/* Tier selector */}
            <div>
              <label style={{ fontSize: 9, color: C.textDim, letterSpacing: '0.14em', textTransform: 'uppercase', display: 'block', marginBottom: 8 }}>
                ACCESS TIER
              </label>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                {tierOptions.map(opt => (
                  <button
                    key={opt.value}
                    type="button"
                    onClick={() => setTier(opt.value)}
                    disabled={isLoading}
                    style={{
                      padding:       '8px 10px',
                      background:    tier === opt.value ? C.skyGlow : 'rgba(5, 15, 35, 0.5)',
                      border:        `1px solid ${tier === opt.value ? C.skyBorderHi : C.skyBorder}`,
                      borderRadius:  8,
                      color:         tier === opt.value ? C.sky : C.textDim,
                      cursor:        isLoading ? 'not-allowed' : 'pointer',
                      textAlign:     'left',
                    }}>
                    <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: '0.1em' }}>{opt.label}</div>
                    <div style={{ fontSize: 8, marginTop: 2, opacity: 0.7 }}>{opt.sub}</div>
                  </button>
                ))}
              </div>
            </div>

            {/* Error message */}
            {error && (
              <div style={{
                padding:     '10px 14px',
                background:  C.redGlow,
                border:      `1px solid ${C.red}`,
                borderRadius: 8,
                fontSize:     10,
                color:        C.red,
                letterSpacing: '0.04em',
                lineHeight:   1.5,
              }}>
                ⚠ {error}
              </div>
            )}

            {/* Submit */}
            <button
              type="submit"
              disabled={isLoading || !clientId.trim() || !accessKey.trim()}
              style={{
                padding:       '14px 20px',
                fontSize:      11,
                fontWeight:    700,
                letterSpacing: '0.14em',
                textTransform: 'uppercase',
                background:    isLoading
                  ? 'rgba(56, 189, 248, 0.15)'
                  : `linear-gradient(135deg, ${C.skyDim}, ${C.sky})`,
                color:         isLoading ? C.textDim : C.void,
                border:        `1px solid ${isLoading ? C.skyBorder : C.skyBorderHi}`,
                borderRadius:  10,
                cursor:        isLoading ? 'not-allowed' : 'pointer',
                boxShadow:     isLoading ? 'none' : `0 0 20px ${C.skyGlow}`,
                transition:    'all 0.3s ease',
              }}>
              {isLoading ? '⟳ AUTHENTICATING…' : '⬡ AUTHENTICATE & ENTER'}
            </button>
          </form>

          {/* Security note */}
          <div style={{ marginTop: 20, fontSize: 8, color: C.textDim, lineHeight: 1.7, letterSpacing: '0.06em' }}>
            ◈ Sessions are 15-minute time-bounded tokens created on the ICP canister<br />
            ◈ Access key is SHA-256 hashed client-side before any network call<br />
            ◈ Session validated against skyhi_group canister on every reconnect<br />
            ◈ All access is audit-logged on-chain with principal + timestamp
          </div>
        </div>

        {/* ── Footer ───────────────────────────────────────────────── */}
        <div style={{ textAlign: 'center', marginTop: 24, fontSize: 8, color: C.textDim, letterSpacing: '0.1em' }}>
          © 2026 MEDINA TECH · ALFREDO MEDINA HERNANDEZ · DALLAS, TX<br />
          NOVA SOVEREIGN AGI · SKYHI GROUP ENTERPRISE CLIENT PORTAL
        </div>
      </div>
    </div>
  );
}
