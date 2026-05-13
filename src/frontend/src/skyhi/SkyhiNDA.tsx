// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — NDA + Encryption Gate
// Requires explicit NDA acceptance before any NOVA intelligence is shown.
// Acceptance is sealed with SHA-256 hash of timestamp + client ID.
// IRONCLAD glassmorphism: dark void · sky-blue · gold
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// CONFIDENTIAL — TRADE SECRET
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState, useCallback } from 'react';

// ── Palette ───────────────────────────────────────────────────────────────
const SKY  = '#44aaff';
const GOLD = '#d4af37';
const VOID = '#050a14';
const RED  = '#ff4444';
const DIM  = 'rgba(200,220,255,0.45)';

// ── NDA FULL TEXT ─────────────────────────────────────────────────────────
const NDA_TEXT = `
NON-DISCLOSURE AGREEMENT (NDA)
NOVA SOVEREIGN INTELLIGENCE — CONFIDENTIAL DEMONSTRATION

This Non-Disclosure Agreement ("Agreement") is entered into between:

DISCLOSING PARTY:
  Medina Tech / Alfredo Medina Hernandez ("NOVA")
  Dallas, Texas, USA

RECEIVING PARTY:
  Skyhi Group ("Client")

EFFECTIVE DATE: Upon digital acceptance below.

1. DEFINITION OF CONFIDENTIAL INFORMATION
   "Confidential Information" includes all NOVA proprietary technology,
   algorithms, mathematical engines, source code, inference methods,
   virtual chip architecture, Kuramoto oscillator implementations,
   Lyapunov stability engines, quantum coherence substrates,
   φ-geometry constants, behavioral economics models, antifragility
   engines, FORMA token economics, VAEL defense systems, ARES archive
   architecture, and any outputs produced by the NOVA Virtual Inference
   Chip (NOVA-VCHIP-SKYHI-001).

2. OBLIGATIONS OF RECEIVING PARTY
   a. Client shall not disclose, publish, or disseminate any
      Confidential Information to any third party.
   b. Client shall not reverse-engineer, decompile, or attempt to
      derive the mathematical or algorithmic basis of any NOVA output.
   c. Client shall use Confidential Information solely for the purpose
      of evaluating NOVA's integration with Client's operations.
   d. Client shall restrict access to Confidential Information to
      authorized personnel who have agreed to similar confidentiality
      obligations.

3. INTELLECTUAL PROPERTY
   All intellectual property rights in NOVA's technology, including but
   not limited to the mathematical engines, virtual chip design, and
   sovereign protocol architecture, remain the exclusive property of
   Alfredo Medina Hernandez / Medina Tech.

4. DURATION
   This Agreement shall remain in effect for a period of five (5) years
   from the Effective Date, or until terminated in writing by either party.

5. TRADE SECRET PROTECTION
   The Confidential Information constitutes trade secrets under the
   Defend Trade Secrets Act (DTSA, 18 U.S.C. §1836) and the Texas
   Uniform Trade Secrets Act (TUTSA, Tex. Civ. Prac. & Rem. Code §134A).
   Unauthorized disclosure may result in injunctive relief and damages.

6. ENCRYPTION & SEALED OUTPUTS
   All demonstration outputs are sealed with SHA-256 cryptographic hashes.
   Tampering with, intercepting, or replicating sealed outputs constitutes
   a material breach of this Agreement.

7. GOVERNING LAW
   This Agreement shall be governed by the laws of the State of Texas,
   United States of America.

8. ACCEPTANCE
   By clicking "I ACCEPT" below, Client acknowledges having read,
   understood, and agreed to all terms of this Agreement. Acceptance
   is timestamped and sealed with a SHA-256 cryptographic hash.

© 2024-2026 Alfredo Medina Hernandez · Medina Tech · Dallas, TX
All rights reserved. NOVA is a sovereign intelligence organism.
`.trim();

// ── SHA-256 seal generation (Web Crypto) ──────────────────────────────────
async function generateNdaSeal(clientId: string): Promise<string> {
  const payload = `NDA-ACCEPTED:${clientId}:${Date.now()}:NOVA-SOVEREIGN`;
  const buffer = new TextEncoder().encode(payload);
  const hashBuffer = await crypto.subtle.digest('SHA-256', buffer);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

// ═══════════════════════════════════════════════════════════════════════════
// NDA COMPONENT
// ═══════════════════════════════════════════════════════════════════════════

interface Props {
  clientId: string;
  onAccept: (seal: string) => void;
  onDecline: () => void;
}

export function SkyhiNDA({ clientId, onAccept, onDecline }: Props) {
  const [scrolled, setScrolled]   = useState(false);
  const [checked, setChecked]     = useState(false);
  const [sealing, setSealing]     = useState(false);
  const [seal, setSeal]           = useState<string | null>(null);

  const handleScroll = useCallback((e: React.UIEvent<HTMLDivElement>) => {
    const el = e.currentTarget;
    // Must scroll to within 40px of bottom to count as "read"
    if (el.scrollTop + el.clientHeight >= el.scrollHeight - 40) {
      setScrolled(true);
    }
  }, []);

  const handleAccept = useCallback(async () => {
    if (!checked || !scrolled) return;
    setSealing(true);
    const hash = await generateNdaSeal(clientId);
    setSeal(hash);
    // Small delay for visual feedback
    setTimeout(() => onAccept(hash), 400);
  }, [checked, scrolled, clientId, onAccept]);

  const canAccept = scrolled && checked && !sealing;

  return (
    <div style={{
      width: '100%', height: '100%',
      background: VOID,
      fontFamily: "'Courier New', monospace",
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      position: 'relative',
      overflow: 'hidden',
    }}>
      {/* Grid background */}
      <div style={{
        position: 'absolute', inset: 0,
        backgroundImage: `
          linear-gradient(rgba(68,170,255,0.03) 1px, transparent 1px),
          linear-gradient(90deg, rgba(68,170,255,0.03) 1px, transparent 1px)
        `,
        backgroundSize: '40px 40px',
        pointerEvents: 'none',
      }} />

      <div style={{
        position: 'relative',
        width: 620,
        maxHeight: '90vh',
        background: 'rgba(5,10,20,0.92)',
        backdropFilter: 'blur(18px)',
        border: `1px solid rgba(212,175,55,0.4)`,
        borderRadius: 4,
        boxShadow: `0 0 60px rgba(212,175,55,0.08), 0 0 0 1px rgba(212,175,55,0.15) inset`,
        display: 'flex',
        flexDirection: 'column',
        overflow: 'hidden',
      }}>

        {/* Header */}
        <div style={{
          padding: '20px 28px 16px',
          borderBottom: `1px solid rgba(212,175,55,0.2)`,
          flexShrink: 0,
        }}>
          <div style={{
            height: 2,
            background: `linear-gradient(90deg, transparent, ${RED}, ${GOLD}, ${RED}, transparent)`,
            marginBottom: 16,
            borderRadius: 1,
          }} />
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <span style={{ fontSize: 20, color: RED }}>🔒</span>
            <div>
              <div style={{
                fontSize: 14, fontWeight: 700, color: '#e8f4ff',
                letterSpacing: '0.12em',
              }}>
                CONFIDENTIAL — NDA REQUIRED
              </div>
              <div style={{
                fontSize: 8, color: GOLD,
                letterSpacing: '0.24em',
                textTransform: 'uppercase',
                marginTop: 3,
              }}>
                NOVA Sovereign Intelligence · Encrypted Demonstration
              </div>
            </div>
          </div>
          <div style={{
            fontSize: 9, color: DIM, marginTop: 12,
            lineHeight: 1.5, letterSpacing: '0.04em',
          }}>
            Before accessing the NOVA integration demo, Skyhi Group must review
            and accept the following Non-Disclosure Agreement. All demonstration
            outputs are encrypted and sealed with SHA-256 cryptographic hashes.
            Scroll to bottom to enable acceptance.
          </div>
        </div>

        {/* NDA body — scrollable */}
        <div
          onScroll={handleScroll}
          style={{
            flex: 1,
            overflow: 'auto',
            padding: '16px 28px',
            maxHeight: 380,
          }}
        >
          <pre style={{
            fontSize: 10,
            color: 'rgba(200,220,255,0.7)',
            lineHeight: 1.6,
            whiteSpace: 'pre-wrap',
            wordBreak: 'break-word',
            fontFamily: "'Courier New', monospace",
            margin: 0,
          }}>
            {NDA_TEXT}
          </pre>

          {!scrolled && (
            <div style={{
              fontSize: 8, color: 'rgba(255,100,100,0.6)',
              letterSpacing: '0.14em', textTransform: 'uppercase',
              textAlign: 'center', marginTop: 16,
            }}>
              ↓ Scroll to bottom to enable acceptance ↓
            </div>
          )}
        </div>

        {/* Acceptance controls */}
        <div style={{
          padding: '16px 28px 20px',
          borderTop: `1px solid rgba(212,175,55,0.2)`,
          flexShrink: 0,
        }}>
          {/* Checkbox */}
          <label style={{
            display: 'flex', alignItems: 'flex-start', gap: 10,
            cursor: scrolled ? 'pointer' : 'not-allowed',
            opacity: scrolled ? 1 : 0.4,
            marginBottom: 16,
          }}>
            <input
              type="checkbox"
              checked={checked}
              onChange={e => scrolled && setChecked(e.target.checked)}
              disabled={!scrolled}
              style={{ marginTop: 2, accentColor: GOLD }}
            />
            <span style={{
              fontSize: 10, color: '#e8f4ff',
              lineHeight: 1.5, letterSpacing: '0.04em',
            }}>
              I, on behalf of <strong style={{ color: GOLD }}>Skyhi Group</strong>,
              have read, understood, and agree to all terms of this Non-Disclosure
              Agreement. I understand that all NOVA technology demonstrated herein
              constitutes trade secrets protected under federal and state law.
            </span>
          </label>

          {/* Buttons */}
          <div style={{ display: 'flex', gap: 12 }}>
            <button
              onClick={onDecline}
              style={{
                flex: 1,
                padding: '11px 0',
                background: 'transparent',
                border: `1px solid rgba(255,68,68,0.3)`,
                borderRadius: 3,
                color: 'rgba(255,100,100,0.7)',
                fontSize: 10,
                letterSpacing: '0.18em',
                textTransform: 'uppercase',
                cursor: 'pointer',
                fontFamily: "'Courier New', monospace",
              }}
            >
              Decline
            </button>
            <button
              onClick={handleAccept}
              disabled={!canAccept}
              style={{
                flex: 2,
                padding: '11px 0',
                background: canAccept
                  ? `linear-gradient(135deg, rgba(212,175,55,0.2), rgba(68,170,255,0.15))`
                  : 'rgba(68,170,255,0.04)',
                border: `1px solid ${canAccept ? GOLD : 'rgba(68,170,255,0.15)'}`,
                borderRadius: 3,
                color: canAccept ? '#e8f4ff' : 'rgba(200,220,255,0.3)',
                fontSize: 11,
                letterSpacing: '0.22em',
                textTransform: 'uppercase',
                cursor: canAccept ? 'pointer' : 'not-allowed',
                fontFamily: "'Courier New', monospace",
                fontWeight: 700,
                transition: 'all 0.15s',
              }}
            >
              {sealing ? '🔐 Sealing…' : seal ? '✓ Sealed' : '🔒 I Accept — Seal with SHA-256'}
            </button>
          </div>

          {/* Seal display */}
          {seal && (
            <div style={{
              marginTop: 12,
              padding: '8px 12px',
              background: 'rgba(68,170,255,0.06)',
              border: `1px solid rgba(68,170,255,0.2)`,
              borderRadius: 3,
            }}>
              <div style={{ fontSize: 7, color: SKY, letterSpacing: '0.2em', textTransform: 'uppercase', marginBottom: 4 }}>
                NDA Acceptance Seal (SHA-256)
              </div>
              <div style={{
                fontSize: 8, color: 'rgba(200,220,255,0.6)',
                fontFamily: 'monospace',
                wordBreak: 'break-all',
                lineHeight: 1.4,
              }}>
                {seal}
              </div>
            </div>
          )}

          {/* Client ID */}
          <div style={{
            marginTop: 10,
            fontSize: 7, color: 'rgba(100,130,160,0.4)',
            letterSpacing: '0.08em',
            textAlign: 'center',
          }}>
            Client: {clientId} · Protected under DTSA (18 U.S.C. §1836) + TUTSA ·
            © 2026 Alfredo Medina Hernandez · Medina Tech
          </div>
        </div>
      </div>
    </div>
  );
}
