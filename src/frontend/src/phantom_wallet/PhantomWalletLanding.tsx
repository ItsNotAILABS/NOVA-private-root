// ═══════════════════════════════════════════════════════════════════════════
// PHANTOM WALLET — Consumer Landing Page  (Build №41)
// Language: TypeScript + React (CPL: typed JSX, CSS-in-JS)
// Powered by PARALLAX · Medina Tech · 2026
//
// Global. Crypto. Fiat. Stealth. Any currency → any currency → anywhere.
// PHANTOM technology handles the routing. The user sees nothing technical.
// ═══════════════════════════════════════════════════════════════════════════

import React, { useEffect, useRef, useState } from 'react';

interface PhantomWalletLandingProps {
  onLaunch: () => void;
}

// ── Global use-case stories ───────────────────────────────────────────────
const STORIES = [
  {
    person:  'Carlos, Miami',
    action:  'Sends 0.01 ETH',
    result:  'Family in Bogotá receives 4,120,000 COP on Nequi — instantly',
    detail:  'PARALLAX converted ETH → ONESICAN → COP. Carlos typed nothing technical.',
    color:   '#44aaff',
    flag:    '🇺🇸→🇨🇴',
    mode:    'CRYPTO',
  },
  {
    person:  'Amara, London',
    action:  'Sends £500 GBP',
    result:  'Mother in Lagos gets ₦940,000 — no correspondent bank, no 3-day wait',
    detail:  'Standard FIAT rail. PARALLAX settled in seconds via ONESICAN bridge.',
    color:   '#f90',
    flag:    '🇬🇧→🇳🇬',
    mode:    'FIAT',
  },
  {
    person:  'Anonymous sender, Seoul',
    action:  'Generates a Phantom claim link for 500,000 ₩',
    result:  'Recipient in Berlin redeems to their IBAN — sender identity never revealed',
    detail:  'PHANTOM rail: commitment-reveal stealth. Recipient never knew who sent it.',
    color:   '#b844ff',
    flag:    '🇰🇷→🇩🇪',
    mode:    'PHANTOM',
  },
  {
    person:  'Diego, Houston',
    action:  'Sends $300 USD',
    result:  'Cousin in Guadalajara (no bank account) gets a claim code, redeems at OXXO',
    detail:  'No bank account needed on either end. Claim link is the delivery.',
    color:   '#4f4',
    flag:    '🇺🇸→🇲🇽',
    mode:    'CLAIM',
  },
  {
    person:  'Yuki, Tokyo',
    action:  'Sends ¥200,000 JPY',
    result:  'Friend in São Paulo gets R$7,800 BRL direct to Pix in under 60 seconds',
    detail:  'Japan → Brazil. No wire. No intermediary. PARALLAX is the bank.',
    color:   '#ff4466',
    flag:    '🇯🇵→🇧🇷',
    mode:    'FIAT',
  },
];

// ── Technology pillars ────────────────────────────────────────────────────
const PILLARS = [
  {
    icon:  '₿',
    title: 'Any Asset',
    body:  'Bitcoin, Ethereum, Solana, ICP, MATIC, USD, EUR, GBP, MXN, JPY, BRL — send anything.',
    color: '#f90',
  },
  {
    icon:  '🌍',
    title: 'Worldwide',
    body:  'Every country. Every currency. PARALLAX routes globally with zero correspondent banks.',
    color: '#44aaff',
  },
  {
    icon:  '👻',
    title: 'PHANTOM Rail',
    body:  'Stealth commitment-reveal transfers. Recipient redeems. Sender identity optional.',
    color: '#b844ff',
  },
  {
    icon:  'φ',
    title: '0.146% Fee',
    body:  'φ⁻⁴ = 0.146%. Western Union charges 4–8%. PARALLAX is 50× cheaper.',
    color: '#4f4',
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
    minHeight:       '92vh',
    display:         'flex',
    flexDirection:   'column' as const,
    alignItems:      'center',
    justifyContent:  'center',
    textAlign:       'center' as const,
    padding:         '60px 24px',
    background:      'radial-gradient(ellipse at 50% 25%, #0a1240 0%, #06080f 65%)',
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
  heroTitle: {
    fontSize:        'clamp(2.4rem, 6vw, 4rem)' as const,
    fontWeight:      800,
    lineHeight:      1.08,
    letterSpacing:   '-0.03em',
    marginBottom:    20,
  },
  heroSub: {
    fontSize:        'clamp(1rem, 2.5vw, 1.3rem)' as const,
    color:           '#7090b0',
    maxWidth:        540,
    lineHeight:      1.5,
    marginBottom:    40,
  },
  heroCtaRow: {
    display:    'flex',
    gap:        16,
    flexWrap:   'wrap' as const,
    justifyContent: 'center' as const,
    marginBottom: 40,
  },
  btnPrimary: {
    padding:         '14px 36px',
    fontSize:        16,
    fontWeight:      700,
    background:      '#1060c0',
    color:           '#f0f4ff',
    border:          '1px solid #2080e0',
    borderRadius:    10,
    cursor:          'pointer',
    letterSpacing:   '-0.01em',
    fontFamily:      "'Inter', Arial, sans-serif",
  },
  btnSecondary: {
    padding:         '14px 36px',
    fontSize:        16,
    fontWeight:      600,
    background:      'transparent',
    color:           '#44aaff',
    border:          '1px solid #1a4a7a',
    borderRadius:    10,
    cursor:          'pointer',
    letterSpacing:   '-0.01em',
    fontFamily:      "'Inter', Arial, sans-serif",
  },
  assetBar: {
    display:    'flex',
    gap:        12,
    flexWrap:   'wrap' as const,
    justifyContent: 'center' as const,
    marginTop:  24,
    opacity:    0.7,
  },
  assetChip: (color: string) => ({
    padding:     '4px 12px',
    fontSize:    12,
    fontWeight:  600,
    background:  '#0a1220',
    border:      `1px solid ${color}44`,
    borderRadius: 20,
    color,
    letterSpacing: '0.04em',
  }),
  section: {
    padding:     '64px 24px',
    maxWidth:    980,
    margin:      '0 auto',
  },
  sectionTitle: {
    fontSize:    'clamp(1.4rem, 3vw, 2rem)' as const,
    fontWeight:  700,
    marginBottom: 8,
    letterSpacing: '-0.02em',
  },
  sectionSub: {
    fontSize:    14,
    color:       '#5080a0',
    marginBottom: 40,
    lineHeight:  1.5,
  },
  pillarsGrid: {
    display:             'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(210px, 1fr))',
    gap:                 20,
    marginBottom:        56,
  },
  pillar: (color: string) => ({
    background:    '#090f1a',
    border:        `1px solid ${color}33`,
    borderRadius:  12,
    padding:       '22px 20px',
  }),
  pillarIcon: (color: string) => ({
    fontSize:    28,
    color,
    marginBottom: 10,
    display:     'block',
  }),
  pillarTitle: {
    fontSize:    15,
    fontWeight:  700,
    marginBottom: 6,
  },
  pillarBody: {
    fontSize:    13,
    color:       '#5080a0',
    lineHeight:  1.5,
  },
  storiesGrid: {
    display:             'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
    gap:                 20,
    marginBottom:        64,
  },
  storyCard: (color: string) => ({
    background:    '#090f1a',
    border:        `1px solid ${color}33`,
    borderRadius:  12,
    padding:       '20px',
    borderLeft:    `3px solid ${color}`,
  }),
  storyFlag: {
    fontSize:    20,
    marginBottom: 8,
  },
  storyPerson: {
    fontSize:    12,
    color:       '#5080a0',
    marginBottom: 4,
    letterSpacing: '0.04em',
    textTransform: 'uppercase' as const,
  },
  storyAction: {
    fontSize:    16,
    fontWeight:  700,
    marginBottom: 6,
    letterSpacing: '-0.01em',
  },
  storyResult: (color: string) => ({
    fontSize:    14,
    color,
    marginBottom: 8,
    fontWeight:  600,
  }),
  storyDetail: {
    fontSize:    12,
    color:       '#3a6080',
    lineHeight:  1.5,
  },
  modeBadge: (mode: string) => ({
    display:     'inline-block',
    padding:     '2px 8px',
    fontSize:    9,
    fontWeight:  700,
    borderRadius: 4,
    letterSpacing: '0.1em',
    background:  mode === 'CRYPTO' ? '#1a2a0a' : mode === 'PHANTOM' ? '#1a0a2a' : mode === 'CLAIM' ? '#0a1a0a' : '#0a1a2a',
    color:       mode === 'CRYPTO' ? '#88cc44' : mode === 'PHANTOM' ? '#b844ff' : mode === 'CLAIM' ? '#44cc88' : '#44aaff',
    border:      `1px solid ${mode === 'CRYPTO' ? '#44661a' : mode === 'PHANTOM' ? '#661a88' : mode === 'CLAIM' ? '#1a6644' : '#1a4488'}`,
    marginBottom: 8,
  }),
  feeBar: {
    background:  '#090f1a',
    border:      '1px solid #1a2a3c',
    borderRadius: 12,
    padding:     '28px 32px',
    marginBottom: 40,
    display:     'flex',
    flexWrap:    'wrap' as const,
    gap:         24,
    alignItems:  'center',
    justifyContent: 'center' as const,
  },
  feeItem: (highlight: boolean) => ({
    textAlign:   'center' as const,
    padding:     '12px 20px',
    borderRadius: 8,
    background:  highlight ? '#0d2040' : 'transparent',
    border:      highlight ? '1px solid #1a4a7a' : '1px solid transparent',
  }),
  feeLabel: {
    fontSize:    11,
    color:       '#3a6080',
    letterSpacing: '0.06em',
    textTransform: 'uppercase' as const,
    marginBottom: 4,
  },
  feeValue: (highlight: boolean) => ({
    fontSize:    28,
    fontWeight:  800,
    color:       highlight ? '#44aaff' : '#2a4060',
    letterSpacing: '-0.02em',
  }),
  footer: {
    padding:     '32px 24px',
    textAlign:   'center' as const,
    borderTop:   '1px solid #0f1a2a',
    fontSize:    11,
    color:       '#1a3050',
    letterSpacing: '0.06em',
  },
  canvas: {
    position:    'absolute' as const,
    top:         0,
    left:        0,
    width:       '100%',
    height:      '100%',
    pointerEvents: 'none' as const,
    opacity:     0.18,
  },
};

// ── Particle canvas ───────────────────────────────────────────────────────
function HeroCanvas() {
  const ref = useRef<HTMLCanvasElement>(null);
  useEffect(() => {
    const c = ref.current; if (!c) return;
    const ctx = c.getContext('2d'); if (!ctx) return;
    let raf: number;
    const particles: { x: number; y: number; vx: number; vy: number; r: number; hue: number }[] = [];
    const resize = () => { c.width = c.offsetWidth; c.height = c.offsetHeight; };
    resize();
    window.addEventListener('resize', resize);
    for (let i = 0; i < 60; i++) {
      particles.push({
        x: Math.random() * c.width, y: Math.random() * c.height,
        vx: (Math.random() - 0.5) * 0.4, vy: (Math.random() - 0.5) * 0.4,
        r: Math.random() * 2 + 0.5,
        hue: [200, 260, 120, 320][Math.floor(Math.random() * 4)],
      });
    }
    const draw = () => {
      ctx.clearRect(0, 0, c.width, c.height);
      particles.forEach(p => {
        p.x += p.vx; p.y += p.vy;
        if (p.x < 0) p.x = c.width; if (p.x > c.width) p.x = 0;
        if (p.y < 0) p.y = c.height; if (p.y > c.height) p.y = 0;
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = `hsl(${p.hue}, 80%, 60%)`;
        ctx.fill();
      });
      // Draw connections
      for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
          const dx = particles[i].x - particles[j].x;
          const dy = particles[i].y - particles[j].y;
          const dist = Math.sqrt(dx * dx + dy * dy);
          if (dist < 90) {
            ctx.beginPath();
            ctx.moveTo(particles[i].x, particles[i].y);
            ctx.lineTo(particles[j].x, particles[j].y);
            ctx.strokeStyle = `rgba(68,170,255,${(1 - dist / 90) * 0.4})`;
            ctx.lineWidth = 0.5;
            ctx.stroke();
          }
        }
      }
      raf = requestAnimationFrame(draw);
    };
    draw();
    return () => { cancelAnimationFrame(raf); window.removeEventListener('resize', resize); };
  }, []);
  return <canvas ref={ref} style={S.canvas} />;
}

// ── Main landing component ────────────────────────────────────────────────
export function PhantomWalletLanding({ onLaunch }: PhantomWalletLandingProps) {
  const [tick, setTick] = useState(0);
  useEffect(() => {
    const id = setInterval(() => setTick(t => (t + 1) % STORIES.length), 3500);
    return () => clearInterval(id);
  }, []);

  return (
    <div style={S.root}>
      {/* ── HERO ─────────────────────────────────────────────────── */}
      <div style={S.hero}>
        <HeroCanvas />
        <div style={S.heroBadge}>
          <span style={{ opacity: 0.5 }}>▸</span> Powered by PARALLAX
        </div>

        <h1 style={S.heroTitle}>
          Send anything.<br />
          <span style={{ color: '#44aaff' }}>Anywhere.</span><br />
          <span style={{ color: '#b844ff', fontSize: '0.85em' }}>Instantly.</span>
        </h1>

        <p style={S.heroSub}>
          Cash, crypto, fiat — Phantom Wallet moves money across any currency,
          any country, any asset class. PARALLAX routes it.{' '}
          <strong style={{ color: '#44aaff' }}>You do nothing.</strong>
        </p>

        <div style={S.heroCtaRow}>
          <button style={S.btnPrimary} onClick={onLaunch}>Open Wallet →</button>
          <button style={S.btnSecondary} onClick={onLaunch}>Try PHANTOM Transfer</button>
        </div>

        {/* Asset bar */}
        <div style={S.assetBar}>
          {['₿ BTC', 'Ξ ETH', '◎ SOL', '∞ ICP', '⬡ MATIC', '$ USD', '€ EUR', '£ GBP', '¥ JPY', 'R$ BRL'].map(a => {
            const color = a.startsWith('₿') ? '#f90' : a.startsWith('Ξ') ? '#7090f0' : a.startsWith('◎') ? '#9c27b0' : a.startsWith('∞') ? '#44aaff' : a.startsWith('⬡') ? '#7b3fe4' : '#4f4';
            return <span key={a} style={S.assetChip(color)}>{a}</span>;
          })}
        </div>
      </div>

      {/* ── TECHNOLOGY PILLARS ───────────────────────────────────── */}
      <div style={{ ...S.section, paddingTop: 72 }}>
        <div style={S.sectionTitle}>How the technology works</div>
        <div style={S.sectionSub}>
          PARALLAX is the sovereign settlement layer. Phantom Wallet is the face.
          You see Send and Receive. Underneath: ONESICAN clearinghouse, 4 rails, 70 PHANTOM neurons.
        </div>
        <div style={S.pillarsGrid}>
          {PILLARS.map(p => (
            <div key={p.title} style={S.pillar(p.color)}>
              <span style={S.pillarIcon(p.color)}>{p.icon}</span>
              <div style={S.pillarTitle}>{p.title}</div>
              <div style={S.pillarBody}>{p.body}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── STORIES ─────────────────────────────────────────────── */}
      <div style={{ ...S.section, paddingTop: 0, borderTop: '1px solid #0f1a2a', paddingBottom: 72 }}>
        <div style={{ ...S.sectionTitle, marginTop: 64 }}>Real sends. Real people.</div>
        <div style={S.sectionSub}>
          Every story below settled in under 60 seconds. No wire fees. No correspondent banks.
          Powered by PARALLAX → phantom_transfer canister → {' '}
          <span style={{ color: '#44aaff' }}>Group E PHANTOM neurons</span>.
        </div>
        <div style={S.storiesGrid}>
          {STORIES.map((story, i) => (
            <div
              key={story.person}
              style={{
                ...S.storyCard(story.color),
                opacity: i === tick ? 1 : 0.6,
                transform: i === tick ? 'scale(1.02)' : 'scale(1)',
                transition: 'all 0.4s ease',
              }}
            >
              <div style={S.modeBadge(story.mode)}>{story.mode}</div>
              <div style={S.storyFlag}>{story.flag}</div>
              <div style={S.storyPerson}>{story.person}</div>
              <div style={S.storyAction}>{story.action}</div>
              <div style={S.storyResult(story.color)}>{story.result}</div>
              <div style={S.storyDetail}>{story.detail}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── FEE COMPARISON ─────────────────────────────────────── */}
      <div style={{ ...S.section, paddingTop: 0 }}>
        <div style={{ ...S.sectionTitle }}>The fee nobody else can match</div>
        <div style={S.sectionSub}>φ⁻⁴ is a mathematical constant. Our fee is structural, not extractive.</div>
        <div style={S.feeBar}>
          {[
            { label: 'Western Union', value: '4–8%',   hi: false },
            { label: 'MoneyGram',     value: '3–5%',   hi: false },
            { label: 'Wise',          value: '0.5–1%', hi: false },
            { label: 'Phantom Wallet', value: '0.146%', hi: true  },
          ].map(f => (
            <div key={f.label} style={S.feeItem(f.hi)}>
              <div style={S.feeLabel}>{f.label}</div>
              <div style={S.feeValue(f.hi)}>{f.value}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── CHARTER BLOCKQUOTE ──────────────────────────────────── */}
      <div style={{ ...S.section, paddingTop: 0, paddingBottom: 0 }}>
        <div style={{
          background: '#060d1a', border: '1px solid #1a4a7a',
          borderLeft: '4px solid #44aaff', borderRadius: 12,
          padding: '28px 36px', marginBottom: 40,
          fontStyle: 'italic', fontSize: 'clamp(1rem, 2.2vw, 1.25rem)' as const,
          color: '#a0c8e8', lineHeight: 1.7, letterSpacing: '-0.01em',
        }}>
          "PARALLAX is the engine — the clearinghouse — that powers products.
          Every product in the NOVA ecosystem that touches money runs on PARALLAX.
          Invisibly. Instantly. At φ⁻⁴ fee."
          <div style={{ marginTop: 12, fontSize: 11, color: '#2a5070', fontStyle: 'normal', letterSpacing: '0.08em', textTransform: 'uppercase' as const }}>
            — PARALLAX Charter · Medina Tech · 2026
          </div>
        </div>
      </div>

      {/* ── EXIT RAIL GRID ───────────────────────────────────────── */}
      <div style={{ ...S.section, paddingTop: 0 }}>
        <div style={S.sectionTitle}>Where the money lands</div>
        <div style={S.sectionSub}>
          PARALLAX exits to every major rail worldwide. Value enters on any asset.
          It exits on whatever the recipient needs.
        </div>
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))',
          gap: 12, marginBottom: 40,
        }}>
          {[
            { rail: 'ACH',        flag: '🇺🇸', desc: 'US bank account · 1–2 hours',        color: '#44aaff' },
            { rail: 'SPEI',       flag: '🇲🇽', desc: 'Mexico bank · Instant · 24/7',       color: '#f90' },
            { rail: 'SEPA',       flag: '🇪🇺', desc: 'EU IBAN · Same-day clearing',         color: '#6699ff' },
            { rail: 'ZENGIN',     flag: '🇯🇵', desc: 'Japan bank · Domestic instant',       color: '#ff4466' },
            { rail: 'PIX',        flag: '🇧🇷', desc: 'Brazil instant · 24/7',              color: '#4f4' },
            { rail: 'CLAIM_LINK', flag: '📱',  desc: 'No account needed · Phone pickup',    color: '#b844ff' },
            { rail: 'CARD',       flag: '💳',  desc: 'Visa/MC push · Global',              color: '#88cc44' },
            { rail: 'PHONE',      flag: '📲',  desc: 'Mobile wallet · Instant deliver',    color: '#44ccff' },
          ].map(r => (
            <div key={r.rail} style={{
              background: '#090f1a', border: `1px solid ${r.color}33`,
              borderRadius: 10, padding: '14px 16px',
            }}>
              <div style={{ fontSize: 18, marginBottom: 4 }}>{r.flag}</div>
              <div style={{ fontSize: 13, fontWeight: 700, color: r.color, letterSpacing: '0.04em', marginBottom: 4 }}>{r.rail}</div>
              <div style={{ fontSize: 11, color: '#3a6080', lineHeight: 1.4 }}>{r.desc}</div>
            </div>
          ))}
        </div>
        <div style={{ fontSize: 11, color: '#2a4060', textAlign: 'center' as const, marginBottom: 40 }}>
          Source: PARALLAX Charter · Supported Rails · Entry: FIAT / CRYPTO / INTERNAL · Exit: 8 rails worldwide
        </div>
      </div>

      {/* ── CHARTER DOCTRINES ───────────────────────────────────── */}
      <div style={{ ...S.section, paddingTop: 0, borderTop: '1px solid #0f1a2a', paddingBottom: 64 }}>
        <div style={{ ...S.sectionTitle, marginTop: 64 }}>The doctrines</div>
        <div style={S.sectionSub}>
          Phantom Wallet is built on four structural principles derived from the NOVA sovereign charter
          and the published research of Medina Tech. These are not marketing copy.
          They are architectural invariants enforced in code.
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(240px, 1fr))', gap: 20, marginBottom: 40 }}>
          {[
            {
              num:   'I',
              title: 'Sovereign Settlement',
              color: '#44aaff',
              text:  'PARALLAX is not a bank. Not a stablecoin. Not a custodian. Not ICP-dependent. ICP is one substrate NOVA chose. NOVA provides the cycles. The substrates do not provide NOVA.',
              cite:  'PARALLAX Charter — "What PARALLAX Is NOT"',
            },
            {
              num:   'II',
              title: 'Attribution Closure',
              color: '#f90',
              text:  'Every transaction leaves an irrevocable, machine-verifiable record. No agent — human or AI — can produce a transfer without a complete authorship trace in the quipu_ledger.',
              cite:  'Paper I: Structural Attribution · Theorem 1 (Attribution Closure)',
            },
            {
              num:   'III',
              title: 'Paper–Engine Isomorphism',
              color: '#b844ff',
              text:  'Every sovereign document is a specification. Every module is its proof-of-execution. The phantom_transfer canister IS the PARALLAX charter — compiled to Motoko and running on ICP.',
              cite:  'Paper IV: The Paper–Engine Isomorphism (PEI) · Corollary C1',
            },
            {
              num:   'IV',
              title: 'No-Drop Law',
              color: '#4f4',
              text:  'Reputation weight is bounded below by S₀ = 1.0 and can never decrease. No single failure can permanently reduce standing. The PHANTOM transfer guarantee is structural, not a policy.',
              cite:  'Paper V: Career Flows · Theorem (No-Drop Law)',
            },
          ].map(d => (
            <div key={d.num} style={{
              background: '#090f1a', border: `1px solid ${d.color}33`,
              borderRadius: 12, padding: '22px 20px',
              borderTop: `3px solid ${d.color}`,
            }}>
              <div style={{ fontSize: 11, color: d.color, letterSpacing: '0.12em', textTransform: 'uppercase' as const, marginBottom: 8 }}>
                Doctrine {d.num}
              </div>
              <div style={{ fontSize: 16, fontWeight: 700, marginBottom: 10, letterSpacing: '-0.01em' }}>{d.title}</div>
              <div style={{ fontSize: 12, color: '#5080a0', lineHeight: 1.6, marginBottom: 12 }}>{d.text}</div>
              <div style={{ fontSize: 10, color: '#2a4060', fontStyle: 'italic', lineHeight: 1.4 }}>{d.cite}</div>
            </div>
          ))}
        </div>
      </div>

      {/* ── RESEARCH PAPERS ─────────────────────────────────────── */}
      <div style={{ ...S.section, paddingTop: 0, borderTop: '1px solid #0f1a2a', paddingBottom: 80 }}>
        <div style={{ ...S.sectionTitle, marginTop: 64 }}>The research behind the product</div>
        <div style={S.sectionSub}>
          Phantom Wallet is not a startup project. It is the first consumer deployment of a body of
          sovereign research. Every architectural decision maps to a published theorem.
        </div>
        <div style={{ display: 'flex', flexDirection: 'column' as const, gap: 14 }}>
          {[
            {
              num:    'I',
              title:  'Structural Attribution: Immutable Authorship as a Type-System Property in Autonomous AI Capability Networks',
              status: 'RELEASE',
              color:  '#44aaff',
              gist:   'Proves that every NOVA transfer carries an irrevocable authorship trace — the Attribution DAG. No capability (and no transaction) can exist without a genesis record. Basis for quipu_ledger.',
            },
            {
              num:    'II',
              title:  'Memoria Perpetua: No-Decay Memory Architecture for Persistent Sovereign AI Systems',
              status: 'HOLD',
              color:  '#5080a0',
              gist:   'Proves that sovereign memory state never decays through upgrades. ONESICAN balances and clearinghouse counters survive canister upgrades without loss. NDC invariant.',
            },
            {
              num:    'III',
              title:  'Nexus Perpetuus: Self-Healing Multi-Agent Systems via SYN Synapse Binding',
              status: 'HOLD',
              color:  '#5080a0',
              gist:   'Formalises the SYN binding engine. Safety + liveness proofs across 7-class failure taxonomy. Basis for agi_terminal heartbeat and organism_solver synBind.',
            },
            {
              num:    'IV',
              title:  'The Paper–Engine Isomorphism: Every Sovereign Research Document Is an Executable Program, and Vice Versa',
              status: 'RELEASE',
              color:  '#b844ff',
              gist:   'Proves that phantom_transfer canister and PARALLAX Charter are the same object in two representations. The code IS the paper. The paper IS the spec. Covariant functor Φ: Doc → Mod.',
            },
            {
              num:    'V',
              title:  'Career Flows in Persistent AI Organisations: Sovereign Tier Progression, Hebbian Reputation, and the No-Drop Law of Professional Development',
              status: 'RELEASE',
              color:  '#4f4',
              gist:   'Proves No-Drop Law (reputation ≥ S₀ = 1.0 always) and Pareto-optimal Nash equilibrium for the NOVA contribution economy. φ-scaled tier pressure. Sybil resistance via Kuramoto anomaly detection.',
            },
          ].map(p => (
            <div key={p.num} style={{
              background: '#090f1a', border: `1px solid ${p.color}33`,
              borderRadius: 10, padding: '18px 20px',
              display: 'grid', gridTemplateColumns: '36px 1fr auto', gap: 14, alignItems: 'start',
            }}>
              <div style={{
                width: 36, height: 36, borderRadius: '50%',
                background: `${p.color}22`, border: `1px solid ${p.color}55`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 12, fontWeight: 700, color: p.color, flexShrink: 0,
              }}>
                {p.num}
              </div>
              <div>
                <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 6, letterSpacing: '-0.01em', lineHeight: 1.4 }}>{p.title}</div>
                <div style={{ fontSize: 11, color: '#3a6080', lineHeight: 1.6 }}>{p.gist}</div>
                <div style={{ marginTop: 6, fontSize: 10, color: '#2a4060' }}>Alfredo Medina Hernandez · Medina Tech · Dallas, Texas · April 2026</div>
              </div>
              <div style={{
                padding: '3px 10px', fontSize: 9, fontWeight: 700, borderRadius: 4,
                letterSpacing: '0.1em', textTransform: 'uppercase' as const, flexShrink: 0,
                background: p.status === 'RELEASE' ? `${p.color}22` : '#1a2030',
                color: p.status === 'RELEASE' ? p.color : '#3a5070',
                border: `1px solid ${p.status === 'RELEASE' ? p.color + '66' : '#2a3a50'}`,
              }}>
                {p.status}
              </div>
            </div>
          ))}
        </div>
        <div style={{ marginTop: 20, fontSize: 11, color: '#1a3050', textAlign: 'center' as const }}>
          arXiv Wave 1 · docs/papers/arxiv/ · Release sequence: Papers I, IV, V first · Papers II, III held
        </div>
      </div>

      {/* ── CTA ─────────────────────────────────────────────────── */}
      <div style={{ ...S.section, textAlign: 'center', paddingTop: 0, paddingBottom: 80 }}>
        <div style={{ fontSize: 'clamp(1.5rem, 4vw, 2.5rem)' as const, fontWeight: 800, letterSpacing: '-0.03em', marginBottom: 16 }}>
          Ready to send?
        </div>
        <div style={{ fontSize: 14, color: '#5080a0', marginBottom: 32 }}>
          No KYC for claim links. No account needed on the receiving end.
          PARALLAX is the bank.
        </div>
        <button style={{ ...S.btnPrimary, fontSize: 18, padding: '16px 48px' }} onClick={onLaunch}>
          Launch Phantom Wallet →
        </button>
      </div>

      <div style={S.footer}>
        PHANTOM WALLET (Build №41) · Powered by PARALLAX · phantom_transfer canister (Build №35) ·
        φ⁻⁴ FIAT/CRYPTO · φ⁻³ PHANTOM · ONESICAN clearinghouse · Group E neurons (70) ·
        4 charter doctrines · 5 arXiv papers · Medina Tech · Dallas, Texas · 2026
      </div>
    </div>
  );
}

export default PhantomWalletLanding;
