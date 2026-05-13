// ═══════════════════════════════════════════════════════════════════════════
// PARALLAX LANDING PAGE — NOVA Sovereign Clearinghouse
// Language: TypeScript + React (CPL: typed JSX layer)
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// ═══════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState } from 'react';

// ── Types ────────────────────────────────────────────────────────────────
interface ParallaxLandingProps {
  onLaunch: () => void;
}

// ── Tier definition ───────────────────────────────────────────────────────
const TIERS = [
  {
    num: 1,
    label: 'Fiat-Only',
    icon: '🏦',
    person: 'María in Monterrey',
    send: '5,000 MXN from her Banorte card',
    receive: 'Sister in Chicago gets $250 USD via ACH',
    note: 'No crypto. No account at another bank. Done.',
    color: '#44aaff',
  },
  {
    num: 2,
    label: 'Crypto Multi-Chain',
    icon: '⛓',
    person: 'Carlos in Dallas',
    send: '0.5 ETH from his BTC holdings',
    receive: 'Supplier gets real ETH on Ethereum mainnet',
    note: 'No bridge. No ckBTC. No wETH. NOVA sovereign key signs the exit.',
    color: '#f90',
  },
  {
    num: 3,
    label: 'Multi-Bank Aggregator',
    icon: '🏛',
    person: 'Sarah in Chicago',
    send: '$2,000 from Chase to Wells Fargo',
    receive: 'Or $500 from Chime to her MXN account',
    note: 'Not read-only like Mint. PARALLAX has settlement authority.',
    color: '#4f4',
  },
  {
    num: 4,
    label: 'International Wire',
    icon: '🌐',
    person: 'John in London',
    send: '£3,000 from Barclays UK',
    receive: 'Partner in Tokyo gets JPY via Zengin — same day',
    note: 'SWIFT charges $25-50 + 3-5 days. PARALLAX: 0.146% + same hour.',
    color: '#a9f',
  },
  {
    num: 5,
    label: 'Card-Only / No Account',
    icon: '💳',
    person: 'Alex on Chime',
    send: '$50 from Chime debit card',
    receive: 'Friend in Mexico gets claim link — 900 MXN ready to redeem',
    note: '40M Mexicans in US send $60B/year. WU takes 4-8%. PARALLAX: 0.146%.',
    color: '#f4a',
  },
];

const COMPARE = [
  { service: 'Western Union', fee: '4 – 8%', speed: '1-3 days', notes: 'Partner location pickup' },
  { service: 'Remitly / Wise', fee: '0.5 – 3%', speed: '1-2 days', notes: 'App lock-in' },
  { service: 'SWIFT Wire', fee: '$25-50 + FX spread', speed: '3-5 days', notes: 'Correspondent banks' },
  { service: 'PARALLAX', fee: '0.146% (φ⁻⁴)', speed: 'Same day / same hour', notes: 'Any rail. Any currency.' },
];

// ── Styles ────────────────────────────────────────────────────────────────
const S = {
  root: {
    width: '100%',
    height: '100%',
    overflowY: 'auto' as const,
    background: '#050a14',
    color: '#e0f0ff',
    fontFamily: "'Courier New', monospace",
  },
  hero: {
    minHeight: '80vh',
    display: 'flex',
    flexDirection: 'column' as const,
    alignItems: 'center',
    justifyContent: 'center',
    padding: '40px 20px',
    textAlign: 'center' as const,
    background: 'radial-gradient(ellipse at 50% 40%, #071830 0%, #050a14 70%)',
    borderBottom: '1px solid #1a3a5c',
    position: 'relative' as const,
  },
  badge: {
    fontSize: 9,
    letterSpacing: '0.35em',
    color: '#44aaff',
    textTransform: 'uppercase' as const,
    marginBottom: 24,
    opacity: 0.8,
  },
  heroTitle: {
    fontSize: 'clamp(40px, 8vw, 88px)',
    fontWeight: 700,
    letterSpacing: '-0.02em',
    color: '#fff',
    textShadow: '0 0 60px rgba(68,170,255,0.4)',
    lineHeight: 1.05,
    marginBottom: 12,
  },
  heroAccent: {
    color: '#44aaff',
  },
  heroSub: {
    fontSize: 'clamp(14px, 2vw, 20px)',
    color: '#89c4f4',
    maxWidth: 600,
    lineHeight: 1.6,
    marginBottom: 8,
  },
  heroCaption: {
    fontSize: 11,
    color: '#3a6080',
    marginBottom: 40,
    letterSpacing: '0.06em',
  },
  heroCTA: {
    display: 'flex',
    gap: 16,
    flexWrap: 'wrap' as const,
    justifyContent: 'center',
  },
  btnPrimary: {
    padding: '14px 40px',
    fontSize: 14,
    fontFamily: "'Courier New', monospace",
    letterSpacing: '0.1em',
    background: '#44aaff',
    color: '#050a14',
    border: 'none',
    borderRadius: 4,
    cursor: 'pointer',
    fontWeight: 700,
    textTransform: 'uppercase' as const,
    transition: 'all 0.15s',
  },
  btnSecondary: {
    padding: '14px 40px',
    fontSize: 14,
    fontFamily: "'Courier New', monospace",
    letterSpacing: '0.1em',
    background: 'transparent',
    color: '#44aaff',
    border: '1px solid #44aaff',
    borderRadius: 4,
    cursor: 'pointer',
    textTransform: 'uppercase' as const,
    transition: 'all 0.15s',
  },
  section: {
    padding: '60px 24px',
    maxWidth: 1100,
    margin: '0 auto',
  },
  sectionTitle: {
    fontSize: 'clamp(18px, 3vw, 28px)',
    color: '#44aaff',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    marginBottom: 8,
  },
  sectionSub: {
    fontSize: 13,
    color: '#3a6080',
    marginBottom: 36,
    letterSpacing: '0.06em',
  },
  tiersGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
    gap: 16,
    marginBottom: 24,
  },
  tierCard: (color: string) => ({
    background: '#070e1e',
    border: `1px solid ${color}33`,
    borderRadius: 6,
    padding: 20,
    position: 'relative' as const,
  }),
  tierNum: (color: string) => ({
    fontSize: 32,
    fontWeight: 700,
    color,
    opacity: 0.18,
    position: 'absolute' as const,
    top: 12,
    right: 16,
    fontFamily: 'monospace',
  }),
  tierLabel: (color: string) => ({
    fontSize: 9,
    letterSpacing: '0.25em',
    color,
    textTransform: 'uppercase' as const,
    marginBottom: 8,
  }),
  tierPerson: {
    fontSize: 13,
    color: '#89c4f4',
    marginBottom: 8,
    fontWeight: 600,
  },
  tierRow: {
    fontSize: 11,
    color: '#3a7090',
    marginBottom: 4,
  },
  tierVal: {
    color: '#c0e0ff',
  },
  tierNote: {
    fontSize: 10,
    color: '#2a5070',
    marginTop: 12,
    lineHeight: 1.5,
    borderTop: '1px solid #1a2a3c',
    paddingTop: 10,
  },
  table: {
    width: '100%',
    borderCollapse: 'collapse' as const,
    fontSize: 12,
  },
  th: {
    padding: '10px 14px',
    textAlign: 'left' as const,
    background: '#070e1e',
    color: '#44aaff',
    fontSize: 9,
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    borderBottom: '1px solid #1a3a5c',
  },
  td: (highlight: boolean) => ({
    padding: '10px 14px',
    borderBottom: '1px solid #0d1e30',
    color: highlight ? '#fff' : '#6090b0',
    background: highlight ? '#071830' : 'transparent',
    fontWeight: highlight ? 700 : 400,
  }),
  notBankGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
    gap: 12,
    marginTop: 24,
  },
  notBankCard: {
    background: '#070e1e',
    border: '1px solid #1a2a3c',
    borderRadius: 4,
    padding: 16,
  },
  notBankTitle: {
    fontSize: 9,
    color: '#f44',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    marginBottom: 6,
  },
  notBankText: {
    fontSize: 11,
    color: '#4070a0',
    lineHeight: 1.5,
  },
  archBlock: {
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    borderRadius: 6,
    padding: 24,
    fontFamily: 'monospace',
    fontSize: 11,
    color: '#4090c0',
    whiteSpace: 'pre' as const,
    overflowX: 'auto' as const,
    lineHeight: 1.7,
  },
  footer: {
    borderTop: '1px solid #1a2a3c',
    padding: '24px',
    textAlign: 'center' as const,
    fontSize: 9,
    color: '#2a4060',
    letterSpacing: '0.1em',
  },
};

const ARCH_DIAGRAM = `ENTRY RAILS                    PARALLAX                    EXIT RAILS
(any of these)                 (NOVA sovereign)            (any of these)
──────────────                 ───────────────             ──────────────
MXN bank/card    ─────────→    ONESICAN/NOVA-PESO   →─────  USD bank/ACH
USD card/Chime   ─────────→    (settles instantly)  →─────  EUR SEPA
BTC wallet       ─────────→    sovereign ledger     →─────  MXN SPEI
ETH wallet       ─────────→    quipu_ledger records →─────  SOL wallet
Chase account    ─────────→    all movements        →─────  JPY Zengin
GBP Barclays     ─────────→                         →─────  BRL PIX / cash`;

// ── Component ─────────────────────────────────────────────────────────────
export function ParallaxLanding({ onLaunch }: ParallaxLandingProps) {
  const [hoverPrimary, setHoverPrimary] = useState(false);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  // Particle field — pure JavaScript-style canvas animation in React
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let frame = 0;
    type Particle = { x: number; y: number; vx: number; vy: number; alpha: number; r: number };
    const particles: Particle[] = Array.from({ length: 60 }, () => ({
      x:  Math.random() * canvas.width,
      y:  Math.random() * canvas.height,
      vx: (Math.random() - 0.5) * 0.3,
      vy: (Math.random() - 0.5) * 0.3,
      alpha: Math.random() * 0.4 + 0.1,
      r:  Math.random() * 1.5 + 0.5,
    }));

    const resize = () => {
      canvas.width  = canvas.offsetWidth;
      canvas.height = canvas.offsetHeight;
    };
    resize();
    window.addEventListener('resize', resize);

    let raf: number;
    const tick = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      frame++;
      particles.forEach((p) => {
        p.x += p.vx;
        p.y += p.vy;
        if (p.x < 0) p.x = canvas.width;
        if (p.x > canvas.width) p.x = 0;
        if (p.y < 0) p.y = canvas.height;
        if (p.y > canvas.height) p.y = 0;
        const pulse = 0.5 + 0.5 * Math.sin(frame * 0.02 + p.x * 0.01);
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(68,170,255,${p.alpha * pulse})`;
        ctx.fill();
      });
      raf = requestAnimationFrame(tick);
    };
    tick();
    return () => {
      cancelAnimationFrame(raf);
      window.removeEventListener('resize', resize);
    };
  }, []);

  return (
    <div style={S.root}>
      {/* ── HERO ─────────────────────────────────────────────────────── */}
      <div style={S.hero}>
        <canvas
          ref={canvasRef}
          style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', pointerEvents: 'none' }}
        />
        <div style={{ position: 'relative', zIndex: 1 }}>
          <div style={S.badge}>NOVA · PARALLAX · Sovereign Settlement Infrastructure · Build №37</div>
          <div style={S.heroTitle}>
            <span style={S.heroAccent}>PARALLAX</span><br />
            powers Phantom Wallet.
          </div>
          <div style={S.heroSub}>
            PARALLAX is the settlement layer. Not a product — the engine.<br />
            Every product in the NOVA ecosystem runs on this.
          </div>
          <div style={S.heroCaption}>
            φ⁻⁴ = 0.146% · Same day · No bank required · 6 currencies · 5 tiers · "Powered by PARALLAX"
          </div>
          <div style={S.heroCTA}>
            <button
              style={{ ...S.btnPrimary, transform: hoverPrimary ? 'scale(1.03)' : 'scale(1)' }}
              onMouseEnter={() => setHoverPrimary(true)}
              onMouseLeave={() => setHoverPrimary(false)}
              onClick={onLaunch}
            >
              Clearinghouse Dashboard →
            </button>
            <button style={S.btnSecondary} onClick={() => {
              document.getElementById('parallax-arch')?.scrollIntoView({ behavior: 'smooth' });
            }}>
              Architecture
            </button>
          </div>
          {/* Products powered by PARALLAX */}
          <div style={{ display: 'flex', gap: 20, marginTop: 8, fontSize: 10, color: '#2a5070' }}>
            <span style={{ color: '#44aaff' }}>Powered by PARALLAX →</span>
            <span>Phantom Wallet</span>
            <span style={{ opacity: 0.5 }}>·</span>
            <span style={{ opacity: 0.4 }}>[Phantom Bank — future]</span>
          </div>
        </div>
      </div>

      {/* ── ARCHITECTURE DIAGRAM ─────────────────────────────────────── */}
      <div id="parallax-arch" style={S.section}>
        <div style={S.sectionTitle}>Settlement Architecture</div>
        <div style={S.sectionSub}>Entry rail and exit rail change. Internal settlement doesn't.</div>
        <div style={S.archBlock}>{ARCH_DIAGRAM}</div>
      </div>

      {/* ── 5 TIERS ──────────────────────────────────────────────────── */}
      <div style={{ ...S.section, borderTop: '1px solid #1a2a3c' }}>
        <div style={S.sectionTitle}>5 User Tiers — One Settlement Layer</div>
        <div style={S.sectionSub}>
          Every tier uses PARALLAX. Only the entry and exit rails change.
        </div>
        <div style={S.tiersGrid}>
          {TIERS.map((t) => (
            <div key={t.num} style={S.tierCard(t.color)}>
              <div style={S.tierNum(t.color)}>{t.num}</div>
              <div style={{ fontSize: 22, marginBottom: 6 }}>{t.icon}</div>
              <div style={S.tierLabel(t.color)}>Tier {t.num} — {t.label}</div>
              <div style={S.tierPerson}>{t.person}</div>
              <div style={S.tierRow}>
                Sends: <span style={S.tierVal}>{t.send}</span>
              </div>
              <div style={S.tierRow}>
                Recipient: <span style={S.tierVal}>{t.receive}</span>
              </div>
              <div style={S.tierNote}>{t.note}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── FEE COMPARISON TABLE ─────────────────────────────────────── */}
      <div style={{ ...S.section, borderTop: '1px solid #1a2a3c' }}>
        <div style={S.sectionTitle}>Fee Comparison</div>
        <div style={S.sectionSub}>On $60B/year US→Mexico remittances: 0.146% returns $3.6B to people.</div>
        <table style={S.table}>
          <thead>
            <tr>
              <th style={S.th}>Service</th>
              <th style={S.th}>Fee</th>
              <th style={S.th}>Speed</th>
              <th style={S.th}>Notes</th>
            </tr>
          </thead>
          <tbody>
            {COMPARE.map((row) => {
              const isParallax = row.service === 'PARALLAX';
              return (
                <tr key={row.service}>
                  <td style={S.td(isParallax)}>{row.service}</td>
                  <td style={S.td(isParallax)}>{row.fee}</td>
                  <td style={S.td(isParallax)}>{row.speed}</td>
                  <td style={S.td(isParallax)}>{row.notes}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* ── WHAT IT'S NOT ─────────────────────────────────────────────── */}
      <div style={{ ...S.section, borderTop: '1px solid #1a2a3c' }}>
        <div style={S.sectionTitle}>What PARALLAX Is Not</div>
        <div style={S.sectionSub}>Important distinctions.</div>
        <div style={S.notBankGrid}>
          {[
            { title: 'Not a bank', text: "PARALLAX doesn't hold deposits. It settles and routes. You keep your money." },
            { title: 'Not a crypto exchange', text: "You don't need to 'buy crypto.' ONESICAN is internal accounting. Users never see it." },
            { title: 'Not a stablecoin issuer', text: "NOVA-PESO is a sovereign peg — internal accounting unit, not a public stablecoin." },
            { title: 'Not ICP-dependent', text: "NOVA is Layer Zero. ICP is one substrate. PARALLAX is portable across substrates." },
            { title: 'Not a custodian', text: "For crypto users: PARALLAX never holds BTC or ETH. Assets move via NOVA sovereign key." },
          ].map((item) => (
            <div key={item.title} style={S.notBankCard}>
              <div style={S.notBankTitle}>{item.title}</div>
              <div style={S.notBankText}>{item.text}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── FINAL CTA ────────────────────────────────────────────────── */}
      <div style={{ ...S.section, textAlign: 'center', borderTop: '1px solid #1a2a3c' }}>
        <div style={{ ...S.sectionTitle, marginBottom: 16 }}>Ready to settle?</div>
        <div style={S.sectionSub}>
          Connect to the PARALLAX clearinghouse. No bank required on either end.
        </div>
        <button style={{ ...S.btnPrimary, fontSize: 16, padding: '16px 56px' }} onClick={onLaunch}>
          Launch Clearinghouse →
        </button>
      </div>

      {/* ── FOOTER ────────────────────────────────────────────────────── */}
      <div style={S.footer}>
        © 2024-2026 Medina Tech · Alfredo Medina Hernandez · Dallas, Texas, USA ·
        NOVA PARALLAX Build №35 · CONFIDENTIAL & PROPRIETARY ·
        φ⁻⁴ = 0.14589803375031546%
      </div>
    </div>
  );
}
