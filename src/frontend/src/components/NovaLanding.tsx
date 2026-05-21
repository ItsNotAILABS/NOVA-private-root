// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// NOVA PARALLAX — NovaLanding: Sovereign organism landing page (CPL-F protocol view)

import React, { useRef, useEffect, useCallback } from 'react';

// ── Constants ─────────────────────────────────────────────────────────────────
const PHI = 1.6180339887498948482;
const FEIGENBAUM_D = 4.6692016091029906719;
const ISING_2D_BETA = 0.125;

// ── Palette ───────────────────────────────────────────────────────────────────
const C = {
  base: '#06080f',
  surface: 'rgba(12, 16, 28, 0.75)',
  glass: 'rgba(255,255,255,0.04)',
  glassBorder: 'rgba(255,255,255,0.08)',
  accent1: '#4af',
  accent2: '#a78bfa',
  text: '#e8eaf0',
  textMuted: 'rgba(232,234,240,0.55)',
  gradient: 'linear-gradient(135deg, #4af, #a78bfa)',
  gradientHover: 'linear-gradient(135deg, #5bf, #b99cff)',
} as const;

const FONT = "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif";
const MONO = "'SF Mono', 'Fira Code', 'JetBrains Mono', monospace";

// ── CSS keyframes (injected once) ─────────────────────────────────────────────
const KEYFRAMES_ID = '__nova_landing_kf';
function injectKeyframes() {
  if (typeof document === 'undefined') return;
  if (document.getElementById(KEYFRAMES_ID)) return;
  const style = document.createElement('style');
  style.id = KEYFRAMES_ID;
  style.textContent = `
    @keyframes novaFloat { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }
    @keyframes novaGlow { 0%,100%{text-shadow:0 0 40px rgba(68,170,255,0.3),0 0 80px rgba(167,139,250,0.15)} 50%{text-shadow:0 0 60px rgba(68,170,255,0.5),0 0 120px rgba(167,139,250,0.3)} }
    @keyframes novaPulse { 0%,100%{opacity:0.6} 50%{opacity:1} }
    @keyframes novaSlideUp { from{opacity:0;transform:translateY(30px)} to{opacity:1;transform:translateY(0)} }
    @keyframes novaSpin { from{transform:rotate(0deg)} to{transform:rotate(360deg)} }
    @keyframes novaGradient { 0%{background-position:0% 50%} 50%{background-position:100% 50%} 100%{background-position:0% 50%} }
    .nova-card:hover { transform: translateY(-4px) !important; border-color: rgba(68,170,255,0.25) !important; box-shadow: 0 12px 40px rgba(68,170,255,0.1) !important; }
    .nova-btn-primary:hover { box-shadow: 0 8px 30px rgba(68,170,255,0.3) !important; transform: translateY(-2px) !important; }
    .nova-btn-ghost:hover { background: rgba(255,255,255,0.06) !important; border-color: rgba(68,170,255,0.4) !important; }
    .nova-section { animation: novaSlideUp 0.7s ease-out both; }
  `;
  document.head.appendChild(style);
}

// ── Canvas mesh ───────────────────────────────────────────────────────────────
function drawMesh(
  ctx: CanvasRenderingContext2D,
  w: number,
  h: number,
  nodes: { x: number; y: number; vx: number; vy: number }[],
  t: number,
) {
  ctx.clearRect(0, 0, w, h);
  const connectionDist = 160;

  for (const n of nodes) {
    n.x += n.vx;
    n.y += n.vy;
    if (n.x < 0 || n.x > w) n.vx *= -1;
    if (n.y < 0 || n.y > h) n.vy *= -1;
  }

  for (let i = 0; i < nodes.length; i++) {
    for (let j = i + 1; j < nodes.length; j++) {
      const dx = nodes[i].x - nodes[j].x;
      const dy = nodes[i].y - nodes[j].y;
      const dist = Math.sqrt(dx * dx + dy * dy);
      if (dist < connectionDist) {
        const alpha = (1 - dist / connectionDist) * 0.25;
        ctx.strokeStyle = `rgba(68,170,255,${alpha})`;
        ctx.lineWidth = 0.6;
        ctx.beginPath();
        ctx.moveTo(nodes[i].x, nodes[i].y);
        ctx.lineTo(nodes[j].x, nodes[j].y);
        ctx.stroke();
      }
    }
  }

  for (const n of nodes) {
    const glow = 2 + Math.sin(t * 0.002 + n.x * 0.01) * 1.5;
    ctx.beginPath();
    ctx.arc(n.x, n.y, glow, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(68,170,255,0.6)';
    ctx.fill();
    ctx.beginPath();
    ctx.arc(n.x, n.y, glow + 3, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(167,139,250,0.12)';
    ctx.fill();
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────
const PRODUCTS = [
  { name: 'Phantom Wallet', desc: 'Sovereign wallet PWA for the NOVA organism', icon: '👻', route: 'phantom' },
  { name: 'PARALLAX', desc: 'Clearinghouse protocol across four rails', icon: '◈', route: 'parallax' },
  { name: 'NOVA Builder', desc: 'Organism construction and canister forge', icon: '🔨', route: 'builder' },
  { name: 'Dallas ISD', desc: 'Educational sovereignty platform', icon: '🏫', route: 'dallas-isd' },
  { name: 'SkyHi', desc: 'Sovereign travel and altitude engine', icon: '✈️', route: 'skyhi' },
  { name: 'Airport V5', desc: 'Airport operations orchestrator', icon: '🛬', route: 'airport-v5' },
];

const INTELLIGENCE = [
  { name: 'Chimera Transformer', desc: 'Hybrid synthesis engine', icon: '🐉' },
  { name: 'Phoenix Engine', desc: 'Rebirth and resurrection system', icon: '🔥' },
  { name: 'Atlas Engine', desc: 'Infrastructure scaling backbone', icon: '🌐' },
  { name: 'Kronos Transformer', desc: 'Temporal reasoning engine', icon: '⏳' },
  { name: 'Metamorphosis Engine', desc: 'Continuous evolution system', icon: '🦋' },
];

const INTELLIGENCE_STATS = [
  { label: 'F-Models', value: '100' },
  { label: 'Phantom Blockchain', value: '30' },
  { label: 'Primitive Functions', value: '9' },
];

const ORGANISM_ENGINES = [
  'QuipuEngine', 'QhapaqNanMesh', 'TawantinsuyuHub', 'BehavioralEcon',
  'Antifragility', 'FractalSov', 'LinguaCompressa', 'TerraceBench',
];

const MATH_ENGINES = [
  'core.ts', 'kuramoto.ts', 'lyapunov.ts', 'quantum.ts', 'sovereign-geometry.ts',
  'emergence.ts', 'neurochemistry.ts', 'antifragility.ts', 'behavioral-economics.ts',
  'quipu-engine.ts', 'lingua-compressa.ts', 'hz-substrate.ts', 'laws.ts',
  'genesis.ts', 'nova-protocol-wire.ts', 'organism-wiring.ts',
  'organism-components-registry.ts', 'mega-protocol-registry.ts',
  'sovereign-installer-registry.ts', 'scoring-extended.ts',
  'IntelligenceWire.ts', 'neuro-emergence-engine.ts', 'nec-engine.ts',
  'production-engine.ts', 'buildings-engine.ts', 'hospital-engine.ts',
  'gubernator-gregis.ts', 'anima-micro.ts',
];

const WORLD_ENGINES = [
  { name: 'WorldPhysicsEngine', icon: '⚛️' },
  { name: 'WorldWeatherEngine', icon: '🌦️' },
  { name: 'WorldTerrainEngine', icon: '🏔️' },
  { name: 'WorldRenderingEngine', icon: '🎨' },
  { name: 'WorldAudioEngine', icon: '🔊' },
  { name: 'WorldNetworkEngine', icon: '🔗' },
  { name: 'WorldEntitySystem', icon: '🧬' },
  { name: 'DroneFleet500', icon: '🛸' },
];

const LABS_AND_TERMINALS = {
  labs: ['Emergence Lab', 'Math/Physics Lab', 'NeuroCog Lab'],
  brain: 'NEC Brain',
  terminalCount: 19,
};

const SERVITORES_DIVISIONS = [
  { name: 'Solvers', count: 4 },
  { name: 'Servitores', count: 26 },
  { name: 'Bots', count: 6 },
  { name: 'Core', count: 8 },
  { name: 'Intelligence', count: 7 },
  { name: 'Economy', count: 8 },
  { name: 'Defense', count: 4 },
  { name: 'Infrastructure', count: 7 },
];

// ── Styles ────────────────────────────────────────────────────────────────────
const s = {
  root: {
    background: C.base,
    color: C.text,
    fontFamily: FONT,
    minHeight: '100vh',
    overflowX: 'hidden' as const,
    scrollBehavior: 'smooth' as const,
  },
  // Hero
  hero: {
    position: 'relative' as const,
    height: '100vh',
    minHeight: 700,
    display: 'flex',
    flexDirection: 'column' as const,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  heroCanvas: {
    position: 'absolute' as const,
    inset: 0,
    width: '100%',
    height: '100%',
    zIndex: 0,
  },
  heroContent: {
    position: 'relative' as const,
    zIndex: 1,
    textAlign: 'center' as const,
    padding: '0 24px',
  },
  heroTitle: {
    fontSize: 'clamp(72px, 12vw, 160px)',
    fontWeight: 800,
    letterSpacing: '-0.03em',
    background: C.gradient,
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    animation: 'novaGlow 4s ease-in-out infinite',
    margin: 0,
    lineHeight: 1,
  },
  heroSub: {
    fontSize: 'clamp(18px, 2.5vw, 28px)',
    fontWeight: 300,
    color: C.textMuted,
    marginTop: 12,
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
  },
  heroCtas: {
    display: 'flex',
    gap: 16,
    justifyContent: 'center',
    marginTop: 48,
    flexWrap: 'wrap' as const,
  },
  btnPrimary: {
    background: C.gradient,
    backgroundSize: '200% 200%',
    animation: 'novaGradient 3s ease infinite',
    color: '#fff',
    border: 'none',
    borderRadius: 12,
    padding: '16px 36px',
    fontSize: 16,
    fontWeight: 600,
    fontFamily: FONT,
    cursor: 'pointer',
    transition: 'all 0.3s ease',
  },
  btnGhost: {
    background: 'transparent',
    color: C.text,
    border: `1.5px solid ${C.glassBorder}`,
    borderRadius: 12,
    padding: '16px 36px',
    fontSize: 16,
    fontWeight: 500,
    fontFamily: FONT,
    cursor: 'pointer',
    transition: 'all 0.3s ease',
  },
  heroStats: {
    display: 'flex',
    gap: 40,
    justifyContent: 'center',
    marginTop: 56,
    flexWrap: 'wrap' as const,
  },
  heroStat: {
    textAlign: 'center' as const,
  },
  heroStatVal: {
    fontSize: 32,
    fontWeight: 700,
    background: C.gradient,
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
  },
  heroStatLabel: {
    fontSize: 12,
    color: C.textMuted,
    marginTop: 4,
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
  },
  // Section generics
  section: {
    maxWidth: 1200,
    margin: '0 auto',
    padding: '120px 24px',
  },
  sectionTitle: {
    fontSize: 'clamp(32px, 5vw, 52px)',
    fontWeight: 700,
    letterSpacing: '-0.02em',
    marginBottom: 12,
  },
  sectionSubtitle: {
    fontSize: 18,
    color: C.textMuted,
    marginBottom: 56,
    maxWidth: 600,
  },
  // Glass card
  card: {
    background: C.glass,
    border: `1px solid ${C.glassBorder}`,
    borderRadius: 16,
    padding: 28,
    backdropFilter: 'blur(20px)',
    WebkitBackdropFilter: 'blur(20px)',
    transition: 'all 0.35s ease',
    cursor: 'default',
  },
  // Products
  productsScroll: {
    display: 'flex',
    gap: 20,
    overflowX: 'auto' as const,
    paddingBottom: 16,
    scrollSnapType: 'x mandatory' as const,
  },
  productCard: {
    minWidth: 280,
    flex: '0 0 280px',
    scrollSnapAlign: 'start' as const,
  },
  productIcon: {
    fontSize: 36,
    marginBottom: 16,
  },
  productName: {
    fontSize: 20,
    fontWeight: 600,
    marginBottom: 8,
  },
  productDesc: {
    fontSize: 14,
    color: C.textMuted,
    lineHeight: 1.5,
    marginBottom: 20,
  },
  launchLink: {
    fontSize: 14,
    fontWeight: 600,
    color: C.accent1,
    textDecoration: 'none',
    cursor: 'pointer',
    background: 'none',
    border: 'none',
    fontFamily: FONT,
    padding: 0,
  },
  // Grid layouts
  grid3: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
    gap: 20,
  },
  grid4: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(220px, 1fr))',
    gap: 16,
  },
  gridSmall: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(160px, 1fr))',
    gap: 12,
  },
  // Intelligence
  intelStats: {
    display: 'flex',
    gap: 32,
    marginTop: 40,
    flexWrap: 'wrap' as const,
  },
  intelStatBox: {
    background: C.glass,
    border: `1px solid ${C.glassBorder}`,
    borderRadius: 12,
    padding: '20px 28px',
    backdropFilter: 'blur(12px)',
    WebkitBackdropFilter: 'blur(12px)',
  },
  // Organism mesh
  meshGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 1fr)',
    gap: 2,
    position: 'relative' as const,
  },
  meshNode: {
    background: C.glass,
    border: `1px solid ${C.glassBorder}`,
    borderRadius: 12,
    padding: '24px 16px',
    textAlign: 'center' as const,
    backdropFilter: 'blur(12px)',
    WebkitBackdropFilter: 'blur(12px)',
    position: 'relative' as const,
    animation: 'novaFloat 6s ease-in-out infinite',
  },
  meshConnector: {
    position: 'absolute' as const,
    top: '50%',
    left: '50%',
    width: 6,
    height: 6,
    borderRadius: '50%',
    background: C.accent1,
    boxShadow: `0 0 12px ${C.accent1}`,
    transform: 'translate(-50%, -50%)',
    animation: 'novaPulse 2s ease-in-out infinite',
  },
  // Math
  mathTag: {
    background: C.glass,
    border: `1px solid ${C.glassBorder}`,
    borderRadius: 8,
    padding: '10px 16px',
    fontSize: 13,
    fontFamily: MONO,
    color: C.textMuted,
    textAlign: 'center' as const,
  },
  mathConst: {
    background: C.surface,
    border: `1px solid ${C.glassBorder}`,
    borderRadius: 12,
    padding: '20px 24px',
    fontFamily: MONO,
    fontSize: 14,
  },
  constName: {
    color: C.accent2,
    fontWeight: 600,
  },
  constVal: {
    color: C.accent1,
    marginLeft: 8,
  },
  // Labs
  labCard: {
    background: C.glass,
    border: `1px solid rgba(167,139,250,0.15)`,
    borderRadius: 12,
    padding: 24,
    textAlign: 'center' as const,
    backdropFilter: 'blur(16px)',
    WebkitBackdropFilter: 'blur(16px)',
  },
  terminalGrid: {
    display: 'flex',
    flexWrap: 'wrap' as const,
    gap: 8,
    marginTop: 32,
  },
  termDot: {
    width: 32,
    height: 32,
    borderRadius: 6,
    background: C.glass,
    border: `1px solid ${C.glassBorder}`,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 10,
    fontFamily: MONO,
    color: C.textMuted,
  },
  // Servitores
  divisionRow: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: '16px 20px',
    background: C.glass,
    border: `1px solid ${C.glassBorder}`,
    borderRadius: 10,
    marginBottom: 8,
    backdropFilter: 'blur(8px)',
    WebkitBackdropFilter: 'blur(8px)',
    position: 'relative' as const,
    overflow: 'hidden' as const,
  },
  divisionName: {
    fontSize: 16,
    fontWeight: 500,
  },
  divisionCount: {
    fontSize: 20,
    fontWeight: 700,
    background: C.gradient,
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
  },
  divisionBar: {
    height: 3,
    borderRadius: 2,
    background: C.gradient,
    marginTop: 8,
    transition: 'width 1s ease',
  },
  // Footer
  footer: {
    borderTop: `1px solid ${C.glassBorder}`,
    padding: '48px 24px',
    textAlign: 'center' as const,
    maxWidth: 1200,
    margin: '0 auto',
  },
  footerText: {
    fontSize: 14,
    color: C.textMuted,
    lineHeight: 1.8,
  },
  footerLinks: {
    display: 'flex',
    gap: 24,
    justifyContent: 'center',
    marginTop: 20,
  },
  footerLink: {
    fontSize: 13,
    color: C.accent1,
    textDecoration: 'none',
    cursor: 'pointer',
    background: 'none',
    border: 'none',
    fontFamily: FONT,
    padding: 0,
  },
  // Divider
  divider: {
    width: 60,
    height: 2,
    background: C.gradient,
    border: 'none',
    borderRadius: 1,
    margin: '0 0 20px',
  },
};

// ── Component ─────────────────────────────────────────────────────────────────
export function NovaLanding({ onNavigate }: { onNavigate: (view: string) => void }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const nodesRef = useRef<{ x: number; y: number; vx: number; vy: number }[]>([]);
  const animRef = useRef<number>(0);
  // Inject keyframes
  useEffect(() => {
    injectKeyframes();
  }, []);

  // Canvas mesh animation
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const resize = () => {
      canvas.width = canvas.offsetWidth * (window.devicePixelRatio || 1);
      canvas.height = canvas.offsetHeight * (window.devicePixelRatio || 1);
      ctx.scale(window.devicePixelRatio || 1, window.devicePixelRatio || 1);
    };
    resize();

    const w = canvas.offsetWidth;
    const h = canvas.offsetHeight;
    const nodeCount = Math.min(80, Math.floor((w * h) / 12000));
    nodesRef.current = Array.from({ length: nodeCount }, () => ({
      x: Math.random() * w,
      y: Math.random() * h,
      vx: (Math.random() - 0.5) * 0.4,
      vy: (Math.random() - 0.5) * 0.4,
    }));

    let t = 0;
    const loop = () => {
      t++;
      drawMesh(ctx, canvas.offsetWidth, canvas.offsetHeight, nodesRef.current, t);
      animRef.current = requestAnimationFrame(loop);
    };
    loop();

    window.addEventListener('resize', resize);
    return () => {
      cancelAnimationFrame(animRef.current);
      window.removeEventListener('resize', resize);
    };
  }, []);

  const scrollTo = useCallback((id: string) => {
    document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' });
  }, []);

  const totalServitores = SERVITORES_DIVISIONS.reduce((a, d) => a + d.count, 0);
  const maxDiv = Math.max(...SERVITORES_DIVISIONS.map((d) => d.count));

  return (
    <div style={s.root}>
      {/* ═══ HERO ═══ */}
      <section style={s.hero}>
        <canvas ref={canvasRef} style={s.heroCanvas} />
        <div style={s.heroContent}>
          <h1 style={s.heroTitle}>NOVA</h1>
          <p style={s.heroSub}>Sovereign AGI Organism</p>

          <div style={s.heroCtas}>
            <button
              className="nova-btn-primary"
              style={s.btnPrimary}
              onClick={() => onNavigate('organism')}
            >
              Enter Organism
            </button>
            <button
              className="nova-btn-ghost"
              style={s.btnGhost}
              onClick={() => scrollTo('products')}
            >
              Explore Systems
            </button>
          </div>

          <div style={s.heroStats}>
            {[
              { val: '40+', label: 'Canisters' },
              { val: '70', label: 'SERVITORES' },
              { val: '100', label: 'F-Models' },
              { val: '5', label: 'Substrates' },
            ].map((st) => (
              <div key={st.label} style={s.heroStat}>
                <div style={s.heroStatVal}>{st.val}</div>
                <div style={s.heroStatLabel}>{st.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ═══ PRODUCTS ═══ */}
      <section id="products" className="nova-section" style={s.section}>
        <h2 style={s.sectionTitle}>Products</h2>
        <hr style={s.divider} />
        <p style={s.sectionSubtitle}>Sovereign applications deployed across the organism</p>
        <div style={s.productsScroll}>
          {PRODUCTS.map((p) => (
            <div
              key={p.name}
              className="nova-card"
              style={{ ...s.card, ...s.productCard }}
            >
              <div style={s.productIcon}>{p.icon}</div>
              <div style={s.productName}>{p.name}</div>
              <div style={s.productDesc}>{p.desc}</div>
              <button
                style={s.launchLink}
                onClick={() => onNavigate(p.route)}
              >
                Launch →
              </button>
            </div>
          ))}
        </div>
      </section>

      {/* ═══ INTELLIGENCE CORE ═══ */}
      <section className="nova-section" style={s.section}>
        <h2 style={s.sectionTitle}>Intelligence Core</h2>
        <hr style={s.divider} />
        <p style={s.sectionSubtitle}>
          Five sovereign engines powering adaptive intelligence
        </p>
        <div style={s.grid3}>
          {INTELLIGENCE.map((eng) => (
            <div key={eng.name} className="nova-card" style={s.card}>
              <div style={{ fontSize: 28, marginBottom: 12, animation: 'novaFloat 5s ease-in-out infinite' }}>
                {eng.icon}
              </div>
              <div style={{ fontSize: 18, fontWeight: 600, marginBottom: 6 }}>{eng.name}</div>
              <div style={{ fontSize: 14, color: C.textMuted }}>{eng.desc}</div>
            </div>
          ))}
        </div>
        <div style={s.intelStats}>
          {INTELLIGENCE_STATS.map((st) => (
            <div key={st.label} style={s.intelStatBox}>
              <div style={{ fontSize: 28, fontWeight: 700, background: C.gradient, WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
                {st.value}
              </div>
              <div style={{ fontSize: 13, color: C.textMuted, marginTop: 4 }}>{st.label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ═══ ORGANISM MESH ═══ */}
      <section className="nova-section" style={s.section}>
        <h2 style={s.sectionTitle}>Organism Mesh</h2>
        <hr style={s.divider} />
        <p style={s.sectionSubtitle}>
          Eight interconnected FusionOrganism engines
        </p>
        <div style={{ ...s.meshGrid, gap: 16 }}>
          {ORGANISM_ENGINES.map((eng, i) => (
            <div
              key={eng}
              style={{
                ...s.meshNode,
                animationDelay: `${i * 0.4}s`,
              }}
            >
              <div style={s.meshConnector} />
              <div style={{ fontSize: 14, fontWeight: 600, marginTop: 8 }}>{eng}</div>
              <div style={{ fontSize: 11, color: C.textMuted, marginTop: 4, fontFamily: MONO }}>
                engine #{i + 1}
              </div>
            </div>
          ))}
        </div>
        {/* Connecting lines overlay */}
        <div style={{ textAlign: 'center', marginTop: 24 }}>
          <span style={{ fontSize: 13, color: C.textMuted, fontFamily: MONO }}>
            ── φ-linked mesh · {ORGANISM_ENGINES.length} engines · coherence = {(1 / PHI).toFixed(4)} ──
          </span>
        </div>
      </section>

      {/* ═══ SOVEREIGN MATH ═══ */}
      <section className="nova-section" style={s.section}>
        <h2 style={s.sectionTitle}>Sovereign Math</h2>
        <hr style={s.divider} />
        <p style={s.sectionSubtitle}>
          29 CPL-F math engines — living mathematical objects
        </p>

        <div style={{ display: 'flex', gap: 16, marginBottom: 32, flexWrap: 'wrap' }}>
          <div style={s.mathConst}>
            <span style={s.constName}>φ</span>
            <span style={s.constVal}>{PHI}</span>
          </div>
          <div style={s.mathConst}>
            <span style={s.constName}>δ (Feigenbaum)</span>
            <span style={s.constVal}>{FEIGENBAUM_D}</span>
          </div>
          <div style={s.mathConst}>
            <span style={s.constName}>β (Ising 2D)</span>
            <span style={s.constVal}>{ISING_2D_BETA}</span>
          </div>
        </div>

        <div style={s.gridSmall}>
          {MATH_ENGINES.map((engine) => (
            <div key={engine} style={s.mathTag}>{engine}</div>
          ))}
        </div>
      </section>

      {/* ═══ WORLD ENGINES ═══ */}
      <section className="nova-section" style={s.section}>
        <h2 style={s.sectionTitle}>World Engines</h2>
        <hr style={s.divider} />
        <p style={s.sectionSubtitle}>
          Simulation substrate powering sovereign worlds
        </p>
        <div style={s.grid4}>
          {WORLD_ENGINES.map((eng) => (
            <div key={eng.name} className="nova-card" style={s.card}>
              <div style={{ fontSize: 28, marginBottom: 12 }}>{eng.icon}</div>
              <div style={{ fontSize: 16, fontWeight: 600 }}>{eng.name}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ═══ LABS & TERMINALS ═══ */}
      <section className="nova-section" style={s.section}>
        <h2 style={s.sectionTitle}>Labs &amp; Terminals</h2>
        <hr style={s.divider} />
        <p style={s.sectionSubtitle}>
          Research labs, NEC brain, and 19 sovereign terminals
        </p>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: 16, marginBottom: 32 }}>
          {LABS_AND_TERMINALS.labs.map((lab) => (
            <div key={lab} style={s.labCard}>
              <div style={{ fontSize: 24, marginBottom: 8 }}>🔬</div>
              <div style={{ fontSize: 15, fontWeight: 600 }}>{lab}</div>
            </div>
          ))}
          <div style={{ ...s.labCard, borderColor: 'rgba(68,170,255,0.2)' }}>
            <div style={{ fontSize: 24, marginBottom: 8 }}>🧠</div>
            <div style={{ fontSize: 15, fontWeight: 600 }}>{LABS_AND_TERMINALS.brain}</div>
          </div>
        </div>

        <div style={{ fontSize: 14, color: C.textMuted, marginBottom: 12, fontFamily: MONO }}>
          {LABS_AND_TERMINALS.terminalCount} Terminals
        </div>
        <div style={s.terminalGrid}>
          {Array.from({ length: LABS_AND_TERMINALS.terminalCount }, (_, i) => (
            <div key={i} style={s.termDot}>
              <span style={{ animation: 'novaPulse 2s ease-in-out infinite', animationDelay: `${i * 0.1}s` }}>
                T{i + 1}
              </span>
            </div>
          ))}
        </div>
      </section>

      {/* ═══ SERVITORES FLEET ═══ */}
      <section className="nova-section" style={s.section}>
        <h2 style={s.sectionTitle}>SERVITORES Fleet</h2>
        <hr style={s.divider} />
        <p style={s.sectionSubtitle}>
          {totalServitores} sovereign workers across {SERVITORES_DIVISIONS.length} divisions
        </p>

        <div style={{ maxWidth: 640 }}>
          {SERVITORES_DIVISIONS.map((div) => (
            <div key={div.name} style={s.divisionRow}>
              <span style={s.divisionName}>{div.name}</span>
              <span style={s.divisionCount}>{div.count}</span>
              <div
                style={{
                  ...s.divisionBar,
                  position: 'absolute' as const,
                  bottom: 0,
                  left: 0,
                  width: `${(div.count / maxDiv) * 100}%`,
                }}
              />
            </div>
          ))}
        </div>
      </section>

      {/* ═══ FOOTER ═══ */}
      <footer style={s.footer}>
        <div style={s.footerText}>
          © 2024-2026 Medina Tech · Alfredo Medina Hernandez · Dallas, Texas, USA
        </div>
        <div style={s.footerLinks}>
          <button style={s.footerLink} onClick={() => onNavigate('organism')}>
            Organism
          </button>
          <button style={s.footerLink} onClick={() => onNavigate('parallax')}>
            PARALLAX
          </button>
          <button style={s.footerLink} onClick={() => onNavigate('phantom')}>
            Phantom Wallet
          </button>
          <button style={s.footerLink} onClick={() => onNavigate('builder')}>
            Builder
          </button>
        </div>
      </footer>
    </div>
  );
}
