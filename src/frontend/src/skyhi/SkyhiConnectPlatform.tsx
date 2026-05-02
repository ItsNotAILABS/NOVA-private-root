// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — Client Services Connection Platform
// Shows how NOVA connects to Skyhi's existing app via:
//   • Push Notifications — real-time alerts from NOVA swarm intelligence
//   • API Bridge — REST + WebSocket endpoints for Skyhi's backend
//   • SDK Integration — drop-in client SDK for Skyhi's frontend
//   • Virtual Chip — sealed NOVA inference unit embedded in Skyhi's stack
//   • WebSocket Streams — live data feeds from NOVA organism
//   • Webhook Callbacks — event-driven notifications to Skyhi's servers
//
// Architecture:
//   Skyhi App ←→ NOVA SDK (client) ←→ NOVA API Bridge ←→ NOVA Canisters
//   Push: NOVA Organism → Push Gateway → Skyhi App (FCM/APNs/WebPush)
//   Stream: NOVA nova_stream → WebSocket → Skyhi App (real-time)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useRef } from 'react';
import { useSkyhiLive, fmt2, fmtPct } from './useSkyhiLive';
import { CHIP_ID, CHIP_VERSION, CHIP_SEAL } from './SkyhiVirtualChip';

// ── Palette ───────────────────────────────────────────────────────────────
const SKY   = '#44aaff';
const GOLD  = '#d4af37';
const VOID  = '#050a14';
const GREEN = '#44ff88';
const RED   = '#ff4444';
const DIM   = 'rgba(200,220,255,0.45)';
const CYAN  = '#44ddff';

// ── Glass panel factory ───────────────────────────────────────────────────
const glass = (hl: 'sky' | 'gold' | 'green' | 'cyan' | 'none' = 'sky'): React.CSSProperties => {
  const bdr = {
    sky:   'rgba(68,170,255,0.35)',
    gold:  'rgba(212,175,55,0.35)',
    green: 'rgba(68,255,136,0.30)',
    cyan:  'rgba(68,221,255,0.30)',
    none:  'rgba(68,170,255,0.15)',
  }[hl];
  return {
    background: 'rgba(5,10,25,0.82)',
    backdropFilter: 'blur(12px)',
    border: `1px solid ${bdr}`,
    borderRadius: 4,
    boxShadow: '0 0 0 1px rgba(5,10,25,0.5) inset',
  };
};

// ── Status dot ────────────────────────────────────────────────────────────
function Dot({ live, color }: { live: boolean; color?: string }) {
  const c = color ?? (live ? GREEN : RED);
  return (
    <span style={{
      display: 'inline-block',
      width: 6, height: 6, borderRadius: '50%',
      background: c,
      boxShadow: `0 0 6px ${c}`,
      flexShrink: 0,
    }} />
  );
}

// ── Progress bar ──────────────────────────────────────────────────────────
function Bar({ value, color = SKY, max = 1 }: { value: number | null; color?: string; max?: number }) {
  const pct = value == null ? 0 : Math.min(1, value / max) * 100;
  return (
    <div style={{ height: 3, background: 'rgba(68,170,255,0.1)', borderRadius: 2, overflow: 'hidden', marginTop: 4 }}>
      <div style={{ height: '100%', width: `${pct}%`, background: color, borderRadius: 2, transition: 'width 0.8s ease' }} />
    </div>
  );
}

// ── Typography ────────────────────────────────────────────────────────────
const panelTitle: React.CSSProperties = {
  fontSize: 8, color: SKY, letterSpacing: '0.28em', textTransform: 'uppercase',
  marginBottom: 14, display: 'flex', alignItems: 'center', gap: 8,
};
const label: React.CSSProperties = {
  fontSize: 8, color: 'rgba(100,140,180,0.8)', letterSpacing: '0.14em',
  textTransform: 'uppercase', marginBottom: 4,
};

// ═══════════════════════════════════════════════════════════════════════════
// CONNECTION LOG — Simulated real-time activity feed
// ═══════════════════════════════════════════════════════════════════════════

interface ConnectionEvent {
  id: number;
  ts: number;
  type: 'PUSH' | 'API' | 'STREAM' | 'WEBHOOK' | 'SDK' | 'CHIP';
  direction: 'IN' | 'OUT';
  endpoint: string;
  status: 'OK' | 'PENDING' | 'ERROR';
  payload: string;
}

const EVENT_COLORS: Record<ConnectionEvent['type'], string> = {
  PUSH: '#ff8844',
  API: SKY,
  STREAM: CYAN,
  WEBHOOK: GOLD,
  SDK: GREEN,
  CHIP: '#aa88ff',
};

let _eventId = 0;
function makeEvent(connected: boolean): ConnectionEvent {
  const types: ConnectionEvent['type'][] = ['PUSH', 'API', 'STREAM', 'WEBHOOK', 'SDK', 'CHIP'];
  const type = types[Math.floor(Math.random() * types.length)]!;
  const endpoints: Record<string, string[]> = {
    PUSH:    ['push/flight-alert', 'push/deal-notification', 'push/gate-change', 'push/delay-warning'],
    API:     ['api/v1/optimize', 'api/v1/match', 'api/v1/demand', 'api/v1/yield', 'api/v1/health'],
    STREAM:  ['ws/kuramoto-feed', 'ws/forma-ticker', 'ws/agent-status', 'ws/coherence'],
    WEBHOOK: ['webhook/booking-update', 'webhook/fare-change', 'webhook/pax-event'],
    SDK:     ['sdk/init', 'sdk/query', 'sdk/subscribe', 'sdk/push-register'],
    CHIP:    ['chip/infer', 'chip/seal', 'chip/status', 'chip/beat'],
  };
  const ep = endpoints[type]![Math.floor(Math.random() * endpoints[type]!.length)]!;
  const payloads: Record<string, string[]> = {
    PUSH:    ['{ flight: "DFW→LAX", gate: "A22" }', '{ deal: "LAST_MINUTE", route: "DFW→ORD" }', '{ alert: "GATE_CHANGE", new: "B14" }'],
    API:     ['{ routes: 6, demand: [...] }', '{ passengers: 8, gates: [...] }', '{ health: "nominal" }'],
    STREAM:  ['{ R: 0.847, beat: 1204 }', '{ forma_stab: 0.91 }', '{ agents: 4, active: true }'],
    WEBHOOK: ['{ booking_id: "BK-9201", status: "CONFIRMED" }', '{ fare_delta: +12.50, route: "DFW→JFK" }'],
    SDK:     ['{ clientId: "SKYHI-GROUP-001" }', '{ query: "demand", routes: [...] }', '{ channel: "flight-alerts" }'],
    CHIP:    ['{ chipBeat: 847, R: 0.82, seal: true }', '{ flights: 6, optimized: true }'],
  };
  const payload = payloads[type]![Math.floor(Math.random() * payloads[type]!.length)]!;
  return {
    id: ++_eventId,
    ts: Date.now(),
    type,
    direction: ['PUSH', 'STREAM', 'WEBHOOK'].includes(type) ? 'OUT' : 'IN',
    endpoint: ep,
    status: connected ? (Math.random() > 0.05 ? 'OK' : 'PENDING') : 'ERROR',
    payload,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION: SERVICE CONNECTION CARDS
// ═══════════════════════════════════════════════════════════════════════════

interface ServiceDef {
  id: string;
  name: string;
  icon: string;
  desc: string;
  protocol: string;
  endpoint: string;
  status: boolean;
  statusLabel: string;
  color: string;
  features: string[];
  codeSnippet: string;
}

function ServiceCard({ svc }: { svc: ServiceDef }) {
  const [showCode, setShowCode] = useState(false);
  return (
    <div style={{ ...glass(svc.status ? 'sky' : 'none'), padding: '16px 18px' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
        <Dot live={svc.status} color={svc.color} />
        <span style={{ fontSize: 14 }}>{svc.icon}</span>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: svc.color, letterSpacing: '0.08em' }}>{svc.name}</div>
          <div style={{ fontSize: 8, color: DIM }}>{svc.desc}</div>
        </div>
        <div style={{
          padding: '2px 8px',
          border: `1px solid ${svc.status ? svc.color : 'rgba(255,68,68,0.4)'}`,
          borderRadius: 2, fontSize: 7,
          color: svc.status ? svc.color : RED,
          letterSpacing: '0.12em', textTransform: 'uppercase',
        }}>
          {svc.statusLabel}
        </div>
      </div>

      {/* Connection details */}
      <div style={{ marginBottom: 8 }}>
        {[
          ['Protocol', svc.protocol],
          ['Endpoint', svc.endpoint],
        ].map(([k, v]) => (
          <div key={k} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 3 }}>
            <span style={{ fontSize: 8, color: DIM, letterSpacing: '0.1em' }}>{k}</span>
            <span style={{ fontSize: 9, color: svc.color, fontFamily: "'Courier New', monospace" }}>{v}</span>
          </div>
        ))}
      </div>

      {/* Features */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 3, marginBottom: 10 }}>
        {svc.features.map(f => (
          <div key={f} style={{ display: 'flex', gap: 5, alignItems: 'flex-start' }}>
            <span style={{ color: svc.color, fontSize: 7, flexShrink: 0, marginTop: 1 }}>◆</span>
            <span style={{ fontSize: 8, color: DIM, lineHeight: 1.4 }}>{f}</span>
          </div>
        ))}
      </div>

      {/* Code snippet toggle */}
      <button
        onClick={() => setShowCode(!showCode)}
        style={{
          width: '100%', padding: '5px 0',
          background: showCode ? 'rgba(68,170,255,0.08)' : 'transparent',
          border: `1px solid rgba(68,170,255,0.15)`,
          borderRadius: 2, cursor: 'pointer',
          fontSize: 8, color: SKY, letterSpacing: '0.12em', textTransform: 'uppercase',
          fontFamily: "'Courier New', monospace",
        }}
      >
        {showCode ? '▾ Hide Integration Code' : '▸ Show Integration Code'}
      </button>
      {showCode && (
        <pre style={{
          marginTop: 8, padding: '10px 12px',
          background: 'rgba(5,10,25,0.9)',
          border: '1px solid rgba(68,170,255,0.12)',
          borderRadius: 3, overflow: 'auto',
          fontSize: 9, color: 'rgba(200,220,255,0.7)',
          fontFamily: "'Courier New', monospace",
          lineHeight: 1.6, whiteSpace: 'pre-wrap',
        }}>
          {svc.codeSnippet}
        </pre>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════

export function SkyhiConnectPlatform() {
  const live = useSkyhiLive();
  const [events, setEvents] = useState<ConnectionEvent[]>([]);
  const logRef = useRef<HTMLDivElement>(null);

  // Simulate real-time connection events
  useEffect(() => {
    const id = setInterval(() => {
      setEvents(prev => [...prev.slice(-49), makeEvent(live.connected)]);
    }, 1800);
    return () => clearInterval(id);
  }, [live.connected]);

  // Auto-scroll log
  useEffect(() => {
    if (logRef.current) {
      logRef.current.scrollTop = logRef.current.scrollHeight;
    }
  }, [events]);

  // Derive service statuses from live canister data
  const orgUp     = live.connected;
  const kuramotoUp = live.connected && live.kuramoto != null;
  const formaUp   = live.connected && live.economy != null;
  const healthUp  = live.connected && live.health != null;

  // Connection stats
  const totalEvents = events.length;
  const okEvents    = events.filter(e => e.status === 'OK').length;
  const errEvents   = events.filter(e => e.status === 'ERROR').length;
  const successRate = totalEvents > 0 ? okEvents / totalEvents : 0;

  // ── Service definitions ─────────────────────────────────────────────────
  const services: ServiceDef[] = [
    {
      id: 'PUSH',
      name: 'Push Notifications',
      icon: '🔔',
      desc: 'Real-time alerts pushed from NOVA to Skyhi app users',
      protocol: 'FCM / APNs / WebPush',
      endpoint: 'push.nova-api.io/v1/skyhi',
      status: orgUp,
      statusLabel: orgUp ? 'CONNECTED' : 'OFFLINE',
      color: '#ff8844',
      features: [
        'Flight delay & gate change alerts — instant push to user devices',
        'Last-minute deal notifications — yield-optimized fare drops',
        'Demand surge alerts — notify ops when route demand spikes',
        'Coherence alerts — system health warnings for ops team',
        'Custom channel subscriptions — users choose alert types',
      ],
      codeSnippet: `// Skyhi App — Register for push notifications
import { NovaSDK } from '@nova/skyhi-sdk';

const nova = new NovaSDK({
  clientId: 'SKYHI-GROUP-001',
  apiKey:   process.env.NOVA_API_KEY,  // NDA-sealed key
  endpoint: 'push.nova-api.io/v1/skyhi',
});

// Register device for push
await nova.push.register({
  token: fcmToken,           // FCM or APNs token
  channels: [
    'flight-alerts',         // gate changes, delays
    'deal-notifications',    // last-minute deals
    'demand-surge',          // ops-only channel
  ],
});

// Handle incoming push in Skyhi app
nova.push.onMessage((msg) => {
  // msg.type: 'GATE_CHANGE' | 'DEAL' | 'DELAY' | 'SURGE'
  // msg.data: { flight, gate, route, ... }
  showNotification(msg);
});`,
    },
    {
      id: 'API',
      name: 'REST API Bridge',
      icon: '⚡',
      desc: 'Skyhi backend ↔ NOVA intelligence via REST endpoints',
      protocol: 'HTTPS / TLS 1.3 / AES-256-GCM',
      endpoint: 'api.nova-api.io/v1/skyhi',
      status: healthUp,
      statusLabel: healthUp ? 'LIVE' : 'OFFLINE',
      color: SKY,
      features: [
        'Flight yield optimization — demand scoring + pricing recommendations',
        'Passenger matching — φ-coherence routing for gate + crew pairing',
        'Real-time demand analysis — per-route demand signals from NOVA engines',
        'System health endpoint — organism vitality + canister status',
        'Sealed outputs — every response carries SHA-256 integrity seal',
      ],
      codeSnippet: `// Skyhi Backend — Call NOVA API
const response = await fetch('https://api.nova-api.io/v1/skyhi/optimize', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer ' + NOVA_API_KEY,
    'X-NDA-Seal':    ndaSeal,
    'X-Chip-ID':     '${CHIP_ID}',
    'Content-Type':  'application/json',
  },
  body: JSON.stringify({
    routes:        ['DFW→LAX', 'DFW→ORD', 'DFW→JFK'],
    demandSignals: [0.82, 0.45, 0.71],
    passengerIds:  ['PAX-4281', 'PAX-7193'],
    gates:         ['A22', 'B14', 'C31'],
    externalStress: 0.15,
  }),
});

const result = await response.json();
// result.flights[0].recommendation → 'PRICE_UP'
// result.network.orderParameter → 0.847
// result.encrypted → true
// result.seal → 'sha256:a4f2c8...'`,
    },
    {
      id: 'WEBSOCKET',
      name: 'WebSocket Streams',
      icon: '📡',
      desc: 'Live data feeds from NOVA organism to Skyhi dashboard',
      protocol: 'WSS / Binary Frames / Protobuf',
      endpoint: 'wss://stream.nova-api.io/v1/skyhi',
      status: kuramotoUp,
      statusLabel: kuramotoUp ? 'STREAMING' : 'DISCONNECTED',
      color: CYAN,
      features: [
        'Kuramoto coherence feed — live R, phase, K_c telemetry every 873ms',
        'FORMA ticker — real-time token stability, mint/burn modulators',
        'Agent status stream — active agents, missions, coherence levels',
        'Demand pulse — live demand signals per route updated in real-time',
        'Health heartbeat — 873ms organism pulse with full vitals',
      ],
      codeSnippet: `// Skyhi Frontend — Connect to live streams
import { NovaSDK } from '@nova/skyhi-sdk';

const nova = new NovaSDK({
  clientId: 'SKYHI-GROUP-001',
  apiKey:   process.env.NOVA_API_KEY,
});

// Open WebSocket connection
const stream = nova.stream.connect({
  channels: ['kuramoto', 'forma', 'demand', 'health'],
});

stream.on('kuramoto', (data) => {
  // data.R:     0.847  — Kuramoto order parameter
  // data.beat:  1204   — organism heartbeat count
  // data.K_c:   0.312  — critical coupling
  updateDashboard(data);
});

stream.on('demand', (data) => {
  // data.routes: [{ id: 'DFW→LAX', demand: 0.82 }, ...]
  updateRouteDisplay(data.routes);
});

stream.on('health', (pulse) => {
  // pulse.vitality:  0.91
  // pulse.connected: true
  // pulse.beat:      1205
  updateStatusBar(pulse);
});`,
    },
    {
      id: 'WEBHOOK',
      name: 'Webhook Callbacks',
      icon: '🔗',
      desc: 'NOVA pushes events to Skyhi servers on booking/fare changes',
      protocol: 'HTTPS POST / HMAC-SHA256 signed',
      endpoint: 'skyhi-app.com/nova-webhook (your server)',
      status: formaUp,
      statusLabel: formaUp ? 'REGISTERED' : 'PENDING',
      color: GOLD,
      features: [
        'Booking confirmations — real-time settlement events from PARALLAX',
        'Fare yield changes — automatic price adjustment notifications',
        'Passenger events — rebook triggers, gate re-assignments',
        'System alerts — coherence drops, defense activations, anomalies',
        'HMAC-SHA256 signed — every webhook payload cryptographically verified',
      ],
      codeSnippet: `// Skyhi Server — Webhook handler
// Register webhook URL in NOVA dashboard:
//   POST https://api.nova-api.io/v1/skyhi/webhooks
//   { url: "https://skyhi-app.com/nova-webhook", events: ["*"] }

// Express handler on Skyhi's server:
app.post('/nova-webhook', (req, res) => {
  // Verify HMAC-SHA256 signature
  const signature = req.headers['x-nova-signature'];
  const expected  = hmac(WEBHOOK_SECRET, req.rawBody);
  if (signature !== expected) return res.status(401).send('Invalid');

  const event = req.body;
  switch (event.type) {
    case 'BOOKING_CONFIRMED':
      updateBookingStatus(event.data);
      break;
    case 'FARE_YIELD_CHANGE':
      adjustPricing(event.data);
      break;
    case 'GATE_REASSIGNMENT':
      notifyPassenger(event.data);
      break;
    case 'COHERENCE_ALERT':
      alertOpsTeam(event.data);
      break;
  }
  res.status(200).send('OK');
});`,
    },
    {
      id: 'SDK',
      name: 'Client SDK',
      icon: '📦',
      desc: 'Drop-in SDK for Skyhi\'s frontend — pre-built NOVA components',
      protocol: 'NPM Package / ESM / UMD',
      endpoint: 'npm install @nova/skyhi-sdk',
      status: orgUp,
      statusLabel: orgUp ? 'AVAILABLE' : 'OFFLINE',
      color: GREEN,
      features: [
        'One-line initialization — just clientId + apiKey to connect',
        'Pre-built UI components — demand heatmaps, coherence badges, fare cards',
        'Type-safe API client — full TypeScript definitions for all endpoints',
        'Automatic reconnection — WebSocket auto-heal on disconnect',
        'Push notification helpers — register/unregister device tokens',
        'Offline mode — local cache with sync-on-reconnect',
      ],
      codeSnippet: `// Install the SDK
// npm install @nova/skyhi-sdk

import { NovaSDK, DemandHeatmap, CoherenceBadge } from '@nova/skyhi-sdk';

// Initialize (one time)
const nova = new NovaSDK({
  clientId: 'SKYHI-GROUP-001',
  apiKey:   process.env.NOVA_API_KEY,
  options: {
    pushEnabled:  true,    // enable push notifications
    streamAuto:   true,    // auto-connect WebSocket
    cacheOffline: true,    // offline mode
  },
});

// Use pre-built components in your React app:
function SkyhiFlightPage() {
  return (
    <div>
      <DemandHeatmap routes={['DFW→LAX','DFW→ORD']} />
      <CoherenceBadge />
      {/* Your existing Skyhi UI here */}
    </div>
  );
}

// Or use the API client directly:
const demand = await nova.api.getDemand(['DFW→LAX']);
const match  = await nova.api.matchPassenger('PAX-4281');`,
    },
    {
      id: 'CHIP',
      name: 'Virtual Chip Bridge',
      icon: '🔮',
      desc: 'Sealed NOVA inference chip embedded in Skyhi\'s stack',
      protocol: 'Internal / Sealed / NDA-Protected',
      endpoint: `chip://${CHIP_ID}`,
      status: orgUp,
      statusLabel: orgUp ? 'SEALED · ACTIVE' : 'OFFLINE',
      color: '#aa88ff',
      features: [
        `Chip ID: ${CHIP_ID} · Version: ${CHIP_VERSION}`,
        `Seal: ${CHIP_SEAL} — heartbeat-locked encryption`,
        'Engines: Kuramoto · Lyapunov · Quantum · Geometry · Emergence · Antifragility · Behavioral',
        'Math hidden — only optimized outputs surface to Skyhi',
        'SHA-256 sealed — every inference output tamper-verified',
        'Trade secret — all engine internals classified',
      ],
      codeSnippet: `// Virtual Chip access (via API — chip runs server-side)
const inference = await nova.api.chipInfer({
  routes:         ['DFW→LAX', 'DFW→ORD'],
  demandSignals:  [0.82, 0.45],
  passengerIds:   ['PAX-4281'],
  gates:          ['A22', 'B14'],
  externalStress: 0.15,
});

// inference.chipId:     '${CHIP_ID}'
// inference.encrypted:  true
// inference.ndaRequired: true
// inference.network.orderParameter: 0.847
// inference.flights[0].recommendation: 'PRICE_UP'
// inference.seal: 'sha256:...'

// NOTE: The chip runs NOVA's real math engines internally.
// You see ONLY the outputs. The math is NEVER exposed.
// All outputs are SHA-256 sealed for tamper detection.`,
    },
  ];

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>

      {/* ═══ HEADER — Architecture overview ══════════════════════════════ */}
      <div style={{ ...glass('gold'), padding: '16px 20px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
          <span style={{ fontSize: 20, color: GOLD }}>⬡</span>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 700, color: '#e8f4ff', letterSpacing: '0.1em' }}>
              How NOVA Connects to Your App
            </div>
            <div style={{ fontSize: 9, color: DIM, marginTop: 3, lineHeight: 1.5 }}>
              Your existing Skyhi app stays as-is. NOVA plugs in through these 6 connection layers.
              Each service is independently configurable. All traffic is encrypted (TLS 1.3 + AES-256-GCM) and NDA-sealed.
            </div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontSize: 8, color: DIM, marginBottom: 2 }}>SERVICES ACTIVE</div>
            <div style={{ fontSize: 20, fontWeight: 700, color: GREEN }}>
              {services.filter(s => s.status).length}/{services.length}
            </div>
          </div>
        </div>

        {/* Architecture flow diagram */}
        <div style={{
          marginTop: 14, padding: '12px 16px',
          background: 'rgba(5,10,25,0.7)',
          border: '1px solid rgba(212,175,55,0.15)',
          borderRadius: 3,
        }}>
          <div style={{ fontSize: 8, color: GOLD, letterSpacing: '0.2em', textTransform: 'uppercase', marginBottom: 8 }}>
            Connection Architecture
          </div>
          <div style={{
            fontSize: 9, color: 'rgba(200,220,255,0.6)', fontFamily: "'Courier New', monospace",
            lineHeight: 1.8, whiteSpace: 'pre',
          }}>
{`┌─────────────────┐     ┌──────────────────┐     ┌─────────────────────────┐
│  SKYHI APP       │     │  NOVA API BRIDGE  │     │  NOVA ORGANISM          │
│  (Your existing  │◄───►│  REST · WebSocket │◄───►│  40+ Canisters          │
│   application)   │     │  Push · Webhooks  │     │  70+ Workers            │
│                  │     │  SDK · Chip       │     │  29 Math Engines        │
│  ✈ Flight Search │     │                  │     │  873ms Heartbeat        │
│  📋 My Bookings  │     │  TLS 1.3         │     │  Kuramoto · Lyapunov    │
│  💰 Deals        │     │  AES-256-GCM     │     │  Quantum · Geometry     │
│  👤 Account      │     │  NDA-Sealed      │     │  FORMA · VAEL · ARES    │
└─────────────────┘     └──────────────────┘     └─────────────────────────┘`}
          </div>
        </div>
      </div>

      {/* ═══ CONNECTION HEALTH BAR ═══════════════════════════════════════ */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 10 }}>
        {[
          ['Connection Rate', `${(successRate * 100).toFixed(1)}%`, successRate > 0.9 ? GREEN : '#ff8844', successRate],
          ['Total Events', `${totalEvents}`, SKY, null],
          ['Errors', `${errEvents}`, errEvents > 0 ? RED : GREEN, null],
          ['Organism Beat', live.snapshot?.beat != null ? `${live.snapshot.beat}` : '—', GOLD, null],
        ].map(([lbl, val, color, barVal]) => (
          <div key={lbl as string} style={{ ...glass('none'), padding: '10px 14px' }}>
            <div style={{ fontSize: 8, color: DIM, letterSpacing: '0.1em', marginBottom: 4 }}>{lbl as string}</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: color as string }}>{val as string}</div>
            {barVal != null && <Bar value={barVal as number} color={color as string} />}
          </div>
        ))}
      </div>

      {/* ═══ SERVICE CARDS ═══════════════════════════════════════════════ */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
        {services.map(svc => (
          <ServiceCard key={svc.id} svc={svc} />
        ))}
      </div>

      {/* ═══ LIVE CONNECTION LOG ════════════════════════════════════════ */}
      <div style={{ ...glass('cyan'), padding: '16px 18px' }}>
        <div style={{ ...panelTitle, color: CYAN }}>
          <Dot live={live.connected} color={CYAN} /> Live Connection Activity
        </div>

        <div
          ref={logRef}
          style={{
            maxHeight: 200, overflow: 'auto',
            background: 'rgba(5,10,25,0.7)',
            border: '1px solid rgba(68,221,255,0.1)',
            borderRadius: 3, padding: '8px 10px',
          }}
        >
          {events.length === 0 && (
            <div style={{ fontSize: 9, color: DIM, textAlign: 'center', padding: 16 }}>
              Waiting for connection events…
            </div>
          )}
          {events.map(ev => (
            <div key={ev.id} style={{
              display: 'flex', alignItems: 'center', gap: 8,
              padding: '3px 0',
              borderBottom: '1px solid rgba(68,221,255,0.04)',
              fontSize: 8,
            }}>
              <span style={{ color: DIM, width: 56, flexShrink: 0 }}>
                {new Date(ev.ts).toLocaleTimeString()}
              </span>
              <span style={{
                width: 50, flexShrink: 0, textAlign: 'center',
                padding: '1px 4px',
                border: `1px solid ${EVENT_COLORS[ev.type]}40`,
                borderRadius: 2,
                color: EVENT_COLORS[ev.type],
                letterSpacing: '0.08em',
              }}>
                {ev.type}
              </span>
              <span style={{ color: ev.direction === 'OUT' ? '#ff8844' : SKY, width: 20, flexShrink: 0 }}>
                {ev.direction === 'OUT' ? '→' : '←'}
              </span>
              <span style={{ color: 'rgba(200,220,255,0.6)', flex: 1, fontFamily: "'Courier New', monospace" }}>
                {ev.endpoint}
              </span>
              <span style={{
                color: ev.status === 'OK' ? GREEN : ev.status === 'ERROR' ? RED : GOLD,
                width: 50, textAlign: 'right', flexShrink: 0,
                letterSpacing: '0.08em',
              }}>
                {ev.status}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* ═══ QUICK START ════════════════════════════════════════════════ */}
      <div style={{ ...glass('green'), padding: '16px 18px' }}>
        <div style={{ ...panelTitle, color: GREEN }}>
          <Dot live={true} color={GREEN} /> Quick Start — Connect in 3 Steps
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 14 }}>
          {[
            {
              step: '1',
              title: 'Install SDK',
              desc: 'Add the NOVA SDK to your existing Skyhi app. One npm install, one import.',
              code: 'npm install @nova/skyhi-sdk',
              color: GREEN,
            },
            {
              step: '2',
              title: 'Initialize',
              desc: 'Configure with your NDA-sealed credentials. SDK auto-connects all services.',
              code: "new NovaSDK({ clientId: 'SKYHI-GROUP-001' })",
              color: SKY,
            },
            {
              step: '3',
              title: 'Go Live',
              desc: 'Push, API, streams, webhooks — all active. Your app now has NOVA intelligence.',
              code: 'nova.push.register() // done ✓',
              color: GOLD,
            },
          ].map(s => (
            <div key={s.step} style={{ ...glass('none'), padding: '14px 16px' }}>
              <div style={{
                width: 24, height: 24, borderRadius: '50%',
                background: `${s.color}20`, border: `1px solid ${s.color}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 12, fontWeight: 700, color: s.color,
                marginBottom: 10,
              }}>
                {s.step}
              </div>
              <div style={{ fontSize: 11, fontWeight: 700, color: s.color, marginBottom: 4 }}>{s.title}</div>
              <div style={{ fontSize: 8, color: DIM, lineHeight: 1.5, marginBottom: 8 }}>{s.desc}</div>
              <div style={{
                padding: '6px 10px',
                background: 'rgba(5,10,25,0.8)',
                border: '1px solid rgba(68,170,255,0.1)',
                borderRadius: 2,
                fontSize: 9, color: 'rgba(200,220,255,0.6)',
                fontFamily: "'Courier New', monospace",
              }}>
                {s.code}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Footer */}
      <div style={{ fontSize: 8, color: 'rgba(100,130,160,0.4)', textAlign: 'center' }}>
        All connections encrypted · NDA-protected · SHA-256 sealed · Trade secret engines hidden ·
        © 2026 Alfredo Medina Hernandez · Medina Tech · Dallas, TX
      </div>
    </div>
  );
}
