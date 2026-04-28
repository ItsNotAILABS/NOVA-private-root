// ═══════════════════════════════════════════════════════════════════════════
// PHANTOM WALLET — Consumer Landing Page
// Language: TypeScript + React (CPL: typed JSX, CSS-in-JS)
// Powered by PARALLAX · Medina Tech · 2026
//
// This is the consumer face of the product. Not a technical page.
// Simple. Clear. Powerful. Mexico first.
// ═══════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState } from 'react';

interface PhantomWalletLandingProps {
  onLaunch: () => void;
}

// ── Testimonials / use case vignettes ─────────────────────────────────────
const STORIES = [
  {
    person:  'Luis, Houston',
    sends:   '$300 USD from his Chime card',
    receives:'His mom in Guadalajara gets 5,940 MXN on her Banorte — in 3 minutes',
    savings: 'WU would have charged $24. Phantom Wallet charged $0.44.',
    color:   '#44aaff',
    flag:    '🇺🇸→🇲🇽',
  },
  {
    person:  'Carmen, Monterrey',
    sends:   '3,000 MXN from her debit card',
    receives:'Her daughter in Chicago gets $150 via ACH',
    savings: 'No bank wire needed. No wait. No fees to the bank.',
    color:   '#f90',
    flag:    '🇲🇽→🇺🇸',
  },
  {
    person:  'Javier, Dallas',
    sends:   '$500 to his cousin who has no bank account',
    receives:'Cousin gets a claim link. Redeems it at Oxxo. Cash in hand.',
    savings: 'No account required on either end.',
    color:   '#4f4',
    flag:    '💳→📱',
  },
];

// ── Styles ────────────────────────────────────────────────────────────────
const S = {
  root: {
    width:       '100%',
    height:      '100%',
    overflowY:   'auto' as const,
    background:  '#06080f',
    color:       '#f0f4ff',
    fontFamily:  "'Inter', 'Helvetica Neue', Arial, sans-serif",
  },
  hero: {
    minHeight:       '90vh',
    display:         'flex',
    flexDirection:   'column' as const,
    alignItems:      'center',
    justifyContent:  'center',
    textAlign:       'center' as const,
    padding:         '60px 24px',
    background:      'radial-gradient(ellipse at 50% 30%, #0a1628 0%, #06080f 70%)',
    borderBottom:    '1px solid #1a2a3c',
    position:        'relative' as const,
    overflow:        'hidden',
  },
  heroBadge: {
    display:         'inline-flex',
    alignItems:      'center',
    gap:             6,
    background:      '#0d1e30',
    border:          '1px solid #1a3a5c',
    borderRadius:    20,
    padding:         '4px 14px',
    fontSize:        11,
    color:           '#44aaff',
    letterSpacing:   '0.1em',
    textTransform:   'uppercase' as const,
    marginBottom:    32,
  },
  poweredBy: {
    fontSize:      9,
    color:         '#3a6080',
    letterSpacing: '0.12em',
  },
  heroTitle: {
    fontSize:     'clamp(36px, 7vw, 76px)',
    fontWeight:   800,
    lineHeight:   1.08,
    letterSpacing:'-0.03em',
    color:        '#ffffff',
    marginBottom: 16,
  },
  heroAccent: {
    color:         '#44aaff',
    textShadow:    '0 0 40px rgba(68,170,255,0.4)',
  },
  heroSub: {
    fontSize:     'clamp(15px, 2.2vw, 20px)',
    color:        '#8ab0d0',
    maxWidth:     520,
    lineHeight:   1.65,
    marginBottom: 12,
  },
  heroCaption: {
    fontSize:     11,
    color:        '#2a5070',
    marginBottom: 44,
    letterSpacing:'0.06em',
  },
  heroCTA: {
    display:         'flex',
    gap:             14,
    flexWrap:        'wrap' as const,
    justifyContent:  'center',
    marginBottom:    48,
  },
  btnPrimary: (hover: boolean) => ({
    padding:        '16px 48px',
    fontSize:       15,
    fontWeight:     700,
    background:     hover ? '#5abcff' : '#44aaff',
    color:          '#050a14',
    border:         'none',
    borderRadius:   8,
    cursor:         'pointer',
    letterSpacing:  '0.02em',
    transition:     'all 0.15s',
    transform:      hover ? 'translateY(-1px)' : 'none',
    boxShadow:      hover ? '0 8px 24px rgba(68,170,255,0.4)' : '0 4px 16px rgba(68,170,255,0.2)',
  }),
  btnSecondary: {
    padding:        '16px 36px',
    fontSize:       15,
    fontWeight:     500,
    background:     'transparent',
    color:          '#6090b0',
    border:         '1px solid #1a3a5c',
    borderRadius:   8,
    cursor:         'pointer',
    letterSpacing:  '0.02em',
  },
  section: {
    padding:    '72px 24px',
    maxWidth:   1080,
    margin:     '0 auto',
  },
  sectionTag: {
    fontSize:       9,
    color:          '#44aaff',
    letterSpacing:  '0.3em',
    textTransform:  'uppercase' as const,
    marginBottom:   10,
  },
  sectionTitle: {
    fontSize:     'clamp(22px, 3.5vw, 36px)',
    fontWeight:   700,
    color:        '#ffffff',
    marginBottom: 10,
    letterSpacing:'-0.02em',
  },
  sectionSub: {
    fontSize:     14,
    color:        '#4a7090',
    marginBottom: 40,
    lineHeight:   1.6,
    maxWidth:     560,
  },
  storyGrid: {
    display:               'grid',
    gridTemplateColumns:   'repeat(auto-fit, minmax(300px, 1fr))',
    gap:                   16,
  },
  storyCard: (color: string) => ({
    background:    '#09111e',
    border:        `1px solid ${color}22`,
    borderRadius:  10,
    padding:       24,
    position:      'relative' as const,
    overflow:      'hidden',
  }),
  storyFlag: {
    fontSize:      28,
    marginBottom:  12,
  },
  storyPerson: (color: string) => ({
    fontSize:      11,
    color,
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    marginBottom:  8,
    fontWeight:    700,
  }),
  storyLine: {
    fontSize:      13,
    color:         '#8ab0d0',
    marginBottom:  6,
    lineHeight:    1.5,
  },
  storySavings: {
    fontSize:      11,
    color:         '#3a6080',
    marginTop:     10,
    paddingTop:    10,
    borderTop:     '1px solid #1a2a3c',
    lineHeight:    1.5,
  },
  featureGrid: {
    display:               'grid',
    gridTemplateColumns:   'repeat(auto-fit, minmax(220px, 1fr))',
    gap:                   14,
  },
  featureCard: {
    background:    '#09111e',
    border:        '1px solid #1a2a3c',
    borderRadius:  8,
    padding:       20,
  },
  featureIcon: {
    fontSize:      26,
    marginBottom:  10,
  },
  featureTitle: {
    fontSize:      13,
    fontWeight:    700,
    color:         '#c0e0ff',
    marginBottom:  6,
  },
  featureText: {
    fontSize:      12,
    color:         '#3a6080',
    lineHeight:    1.55,
  },
  feeBox: {
    background:    '#09111e',
    border:        '1px solid #1a3a5c',
    borderRadius:  10,
    padding:       28,
    maxWidth:      480,
  },
  feeTitle: {
    fontSize:      13,
    color:         '#44aaff',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    marginBottom:  14,
  },
  feeRow: {
    display:         'flex',
    justifyContent:  'space-between',
    fontSize:        13,
    padding:         '8px 0',
    borderBottom:    '1px solid #0d1a28',
  },
  feeLabel: {
    color: '#4a7090',
  },
  feeVal: (accent: boolean) => ({
    color:      accent ? '#fff' : '#7090a0',
    fontWeight: accent ? 700 : 400,
  }),
  footer: {
    borderTop:   '1px solid #0d1a28',
    padding:     '24px',
    textAlign:   'center' as const,
    fontSize:    10,
    color:       '#1a3050',
    letterSpacing: '0.08em',
    lineHeight:  1.7,
  },
};

// ── Particle canvas ────────────────────────────────────────────────────────
function useParticleCanvas(ref: React.RefObject<HTMLCanvasElement>) {
  useEffect(() => {
    const canvas = ref.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let frame = 0;
    type P = { x: number; y: number; vx: number; vy: number; a: number; r: number };
    const resize = () => { canvas.width = canvas.offsetWidth; canvas.height = canvas.offsetHeight; };
    resize();
    window.addEventListener('resize', resize);

    const pts: P[] = Array.from({ length: 50 }, () => ({
      x:  Math.random() * canvas.width,
      y:  Math.random() * canvas.height,
      vx: (Math.random() - 0.5) * 0.25,
      vy: (Math.random() - 0.5) * 0.25,
      a:  Math.random() * 0.3 + 0.05,
      r:  Math.random() * 1.2 + 0.3,
    }));

    let raf: number;
    const draw = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      frame++;
      pts.forEach((p) => {
        p.x = (p.x + p.vx + canvas.width)  % canvas.width;
        p.y = (p.y + p.vy + canvas.height) % canvas.height;
        const pulse = 0.5 + 0.5 * Math.sin(frame * 0.015 + p.y * 0.008);
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(68,170,255,${p.a * pulse})`;
        ctx.fill();
      });
      raf = requestAnimationFrame(draw);
    };
    draw();
    return () => { cancelAnimationFrame(raf); window.removeEventListener('resize', resize); };
  }, [ref]);
}

// ── Component ─────────────────────────────────────────────────────────────
export function PhantomWalletLanding({ onLaunch }: PhantomWalletLandingProps) {
  const [hover, setHover] = useState(false);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  useParticleCanvas(canvasRef);

  return (
    <div style={S.root}>
      {/* ── HERO ─────────────────────────────────────────────────────── */}
      <div style={S.hero}>
        <canvas ref={canvasRef} style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', pointerEvents: 'none', opacity: 0.7 }} />
        <div style={{ position: 'relative', zIndex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
          <div style={S.heroBadge}>
            <span>⬡</span>
            <span>Phantom Wallet</span>
            <span style={S.poweredBy}>· Powered by PARALLAX</span>
          </div>
          <div style={S.heroTitle}>
            Send money<br />
            <span style={S.heroAccent}>to Mexico.</span><br />
            They get it now.
          </div>
          <div style={S.heroSub}>
            Card to phone. Bank to CLABE. Anywhere, to anyone.
            No bank required on either end.
          </div>
          <div style={S.heroCaption}>
            0.146% fee · Same day · Mexico, USA, Europe & more
          </div>
          <div style={S.heroCTA}>
            <button
              style={S.btnPrimary(hover)}
              onMouseEnter={() => setHover(true)}
              onMouseLeave={() => setHover(false)}
              onClick={onLaunch}
            >
              Send Money →
            </button>
            <button style={S.btnSecondary} onClick={() => {
              document.getElementById('pw-how')?.scrollIntoView({ behavior: 'smooth' });
            }}>
              How it works
            </button>
          </div>
          {/* Live comparison widget */}
          <div style={{ display: 'flex', gap: 24, fontSize: 12, color: '#2a5070' }}>
            <span>Western Union: <span style={{ color: '#f44' }}>4–8% fee</span></span>
            <span>·</span>
            <span>Phantom Wallet: <span style={{ color: '#4af' }}>0.146% fee</span></span>
          </div>
        </div>
      </div>

      {/* ── HOW IT WORKS ─────────────────────────────────────────────── */}
      <div id="pw-how" style={{ background: '#070d1a', borderBottom: '1px solid #1a2a3c' }}>
        <div style={S.section}>
          <div style={S.sectionTag}>How it works</div>
          <div style={S.sectionTitle}>Three steps. That's it.</div>
          <div style={S.featureGrid}>
            {[
              { icon: '1️⃣', title: 'Enter the amount', text: 'Type how much you want to send. Pick the currency. MXN, USD, EUR — whatever you have.' },
              { icon: '2️⃣', title: 'Tell us who', text: 'Phone number, bank account, CLABE, or just say "send a link". No account required on their end.' },
              { icon: '3️⃣', title: 'Done', text: 'They get the money. Via their bank, their phone, or a claim link they can redeem anywhere.' },
            ].map(f => (
              <div key={f.title} style={S.featureCard}>
                <div style={S.featureIcon}>{f.icon}</div>
                <div style={S.featureTitle}>{f.title}</div>
                <div style={S.featureText}>{f.text}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* ── STORIES ──────────────────────────────────────────────────── */}
      <div style={{ borderBottom: '1px solid #1a2a3c' }}>
        <div style={S.section}>
          <div style={S.sectionTag}>Real use</div>
          <div style={S.sectionTitle}>Who uses Phantom Wallet</div>
          <div style={S.sectionSub}>
            40 million Mexicans in the US send $60+ billion home every year.
            At 4–8% fees, that's $2.4–$4.8 billion stolen from families.
            At 0.146%, that money stays where it belongs.
          </div>
          <div style={S.storyGrid}>
            {STORIES.map(s => (
              <div key={s.person} style={S.storyCard(s.color)}>
                <div style={S.storyFlag}>{s.flag}</div>
                <div style={S.storyPerson(s.color)}>{s.person}</div>
                <div style={S.storyLine}>Sends: <strong style={{ color: '#c0e0ff' }}>{s.sends}</strong></div>
                <div style={S.storyLine}>Recipient: {s.receives}</div>
                <div style={S.storySavings}>{s.savings}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* ── FEE BREAKDOWN ────────────────────────────────────────────── */}
      <div style={{ background: '#070d1a', borderBottom: '1px solid #1a2a3c' }}>
        <div style={S.section}>
          <div style={S.sectionTag}>Pricing</div>
          <div style={S.sectionTitle}>One fee. Always.</div>
          <div style={S.sectionSub}>No spread. No hidden exchange rate markup. No surprise.</div>
          <div style={S.feeBox}>
            <div style={S.feeTitle}>Example: Sending 5,000 MXN to Mexico</div>
            {[
              ['Amount sent',     '5,000.00 MXN', false],
              ['Fee (0.146%)',    '7.29 MXN', false],
              ['Net settled',     '4,992.71 MXN → ONESICAN', false],
              ['Exchange rate',   '1 USD = 19.88 MXN (live)', false],
              ['They receive',    '~$251.14 USD', true],
              ['Speed',           'Same day / same hour', true],
            ].map(([l, v, a]) => (
              <div key={l as string} style={S.feeRow}>
                <span style={S.feeLabel}>{l}</span>
                <span style={S.feeVal(a as boolean)}>{v}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* ── FEATURES ─────────────────────────────────────────────────── */}
      <div style={{ borderBottom: '1px solid #1a2a3c' }}>
        <div style={S.section}>
          <div style={S.sectionTag}>Features</div>
          <div style={S.sectionTitle}>Built for the real world</div>
          <div style={S.featureGrid}>
            {[
              { icon: '📱', title: 'No account required to receive', text: 'Recipient gets a claim link. They redeem it however they want. No app install.' },
              { icon: '🏦', title: 'Any bank, any card', text: 'Banorte, Chime, Chase, Oxxo Pay, BBVA. If it can move money, it works.' },
              { icon: '⚡', title: 'Instant settlement', text: 'PARALLAX settles internally in milliseconds. Bank rails vary — SPEI is instant 24/7.' },
              { icon: '🔒', title: 'Sovereign settlement', text: 'No custodian. No third-party holding your money. NOVA sovereign key signs every exit.' },
              { icon: '🌎', title: 'Mexico, USA, Europe', text: 'MXN, USD, EUR, GBP, JPY, BRL supported. More coming.' },
              { icon: '📊', title: 'Live rates', text: 'Exchange rates update from oracle network. You see the exact rate before you send.' },
            ].map(f => (
              <div key={f.title} style={S.featureCard}>
                <div style={S.featureIcon}>{f.icon}</div>
                <div style={S.featureTitle}>{f.title}</div>
                <div style={S.featureText}>{f.text}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* ── FINAL CTA ────────────────────────────────────────────────── */}
      <div style={{ background: '#070d1a' }}>
        <div style={{ ...S.section, textAlign: 'center' as const }}>
          <div style={S.sectionTitle}>Ready to send?</div>
          <div style={{ ...S.sectionSub, margin: '0 auto 32px', textAlign: 'center' as const }}>
            No account required. No signup. Just send.
          </div>
          <button
            style={{ ...S.btnPrimary(false), fontSize: 17, padding: '18px 64px' }}
            onClick={onLaunch}
          >
            Send Money Now →
          </button>
        </div>
      </div>

      {/* ── FOOTER ────────────────────────────────────────────────────── */}
      <div style={S.footer}>
        Phantom Wallet — Powered by PARALLAX · NOVA Sovereign Settlement<br />
        © 2024-2026 Medina Tech · Alfredo Medina Hernandez · Dallas, Texas, USA<br />
        CONFIDENTIAL & PROPRIETARY · Build №37 · phantom_transfer on ICP
      </div>
    </div>
  );
}
