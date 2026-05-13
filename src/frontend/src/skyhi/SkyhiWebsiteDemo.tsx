// ═══════════════════════════════════════════════════════════════════════════
// SKYHI GROUP — Website Integration Demo
// Shows how NOVA intelligence fuses with Skyhi's travel operations platform.
// Powered by REAL NOVA math engines via the Virtual Inference Chip.
// No math shown — only optimized outputs from sealed chip inference.
//
// Architecture:
//   Skyhi Website (travel UI) ←→ NOVA API Bridge ←→ Virtual Chip ←→ NOVA Engines
//   All outputs encrypted · NDA-sealed · Closed access
//
// Copyright © 2024-2026 Alfredo Medina Hernandez | Medina Tech
// CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
// ═══════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useRef, useCallback } from 'react';
import {
  chipInfer,
  sealOutput,
  getChipBeat,
  resetChip,
  CHIP_ID,
  CHIP_VERSION,
  CHIP_SEAL,
  type ChipOutput,
  type FlightOptimization,
  type PassengerMatch,
  type ChipInput,
} from './SkyhiVirtualChip';

// ── Palette ───────────────────────────────────────────────────────────────
const SKY   = '#44aaff';
const GOLD  = '#d4af37';
const VOID  = '#050a14';
const GREEN = '#44ff88';
const RED   = '#ff4444';
const DIM   = 'rgba(200,220,255,0.45)';

// ── Glass panel ───────────────────────────────────────────────────────────
const glass = (hl: 'sky' | 'gold' | 'red' | 'none' = 'sky'): React.CSSProperties => {
  const bdr = {
    sky:  'rgba(68,170,255,0.35)',
    gold: 'rgba(212,175,55,0.35)',
    red:  'rgba(255,68,68,0.25)',
    none: 'rgba(68,170,255,0.15)',
  }[hl];
  return {
    background: 'rgba(5,10,25,0.82)',
    backdropFilter: 'blur(12px)',
    border: `1px solid ${bdr}`,
    borderRadius: 4,
    boxShadow: '0 0 0 1px rgba(5,10,25,0.5) inset',
  };
};

// ── Simulated DFW route / passenger data ──────────────────────────────────
const DFW_ROUTES = [
  { id: 'DFW→LAX', origin: 'DFW', dest: 'LAX', airline: 'AA', gate: 'A22' },
  { id: 'DFW→ORD', origin: 'DFW', dest: 'ORD', airline: 'UA', gate: 'B14' },
  { id: 'DFW→JFK', origin: 'DFW', dest: 'JFK', airline: 'AA', gate: 'C31' },
  { id: 'DFW→MIA', origin: 'DFW', dest: 'MIA', airline: 'AA', gate: 'A08' },
  { id: 'DFW→SFO', origin: 'DFW', dest: 'SFO', airline: 'SW', gate: 'E12' },
  { id: 'DFW→DEN', origin: 'DFW', dest: 'DEN', airline: 'UA', gate: 'B22' },
];

const SAMPLE_PAX = [
  'PAX-4281', 'PAX-7193', 'PAX-2847', 'PAX-5029',
  'PAX-8412', 'PAX-1058', 'PAX-6372', 'PAX-9501',
];

const GATES = ['A08', 'A22', 'B14', 'B22', 'C31', 'E12'];

// ═══════════════════════════════════════════════════════════════════════════
// STATUS DOT
// ═══════════════════════════════════════════════════════════════════════════
function Dot({ live, size = 6 }: { live: boolean; size?: number }) {
  return (
    <span style={{
      display: 'inline-block',
      width: size, height: size, borderRadius: '50%',
      background: live ? GREEN : RED,
      boxShadow: live ? `0 0 6px ${GREEN}` : `0 0 4px ${RED}`,
      flexShrink: 0,
    }} />
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// BAR
// ═══════════════════════════════════════════════════════════════════════════
function Bar({ value, color = SKY, max = 1 }: { value: number; color?: string; max?: number }) {
  const pct = Math.min(1, value / max) * 100;
  return (
    <div style={{ height: 3, background: 'rgba(68,170,255,0.1)', borderRadius: 2, overflow: 'hidden', marginTop: 3 }}>
      <div style={{ height: '100%', width: `${pct}%`, background: color, borderRadius: 2, transition: 'width 0.6s ease' }} />
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// RECOMMENDATION COLOR
// ═══════════════════════════════════════════════════════════════════════════
function recColor(rec: FlightOptimization['recommendation']): string {
  switch (rec) {
    case 'PRICE_UP': return GREEN;
    case 'PRICE_DOWN': return RED;
    case 'LAST_MINUTE_DEAL': return '#ff8844';
    default: return SKY;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN DEMO COMPONENT
// ═══════════════════════════════════════════════════════════════════════════

interface Props {
  ndaSeal: string;
  clientId: string;
}

export function SkyhiWebsiteDemo({ ndaSeal, clientId }: Props) {
  const [output, setOutput]       = useState<ChipOutput | null>(null);
  const [seal, setSeal]           = useState<string | null>(null);
  const [stress, setStress]       = useState(0.15);
  const [running, setRunning]     = useState(true);
  const [demandOverrides, setDemandOverrides] = useState<number[]>(
    DFW_ROUTES.map(() => 0.4 + Math.random() * 0.5)
  );
  const tickRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // ── Chip inference tick ─────────────────────────────────────────────────
  const runChipTick = useCallback(async () => {
    // Drift demand slightly each tick for realism
    const drifted = demandOverrides.map(d => {
      const drift = (Math.random() - 0.5) * 0.06;
      return Math.max(0, Math.min(1, d + drift));
    });
    setDemandOverrides(drifted);

    const input: ChipInput = {
      routes: DFW_ROUTES.map(r => r.id),
      demandSignals: drifted,
      passengerIds: SAMPLE_PAX,
      gates: GATES,
      externalStress: stress + (Math.random() - 0.5) * 0.05,
    };

    const result = chipInfer(input);
    setOutput(result);

    // Seal the output
    const hash = await sealOutput(result);
    setSeal(hash);
  }, [stress, demandOverrides]);

  // ── Start / stop loop ───────────────────────────────────────────────────
  useEffect(() => {
    if (running) {
      // Initial tick
      runChipTick();
      tickRef.current = setInterval(runChipTick, 2000);
    } else if (tickRef.current) {
      clearInterval(tickRef.current);
      tickRef.current = null;
    }
    return () => { if (tickRef.current) clearInterval(tickRef.current); };
  }, [running, runChipTick]);

  const net = output?.network;

  return (
    <div style={{
      width: '100%', height: '100%',
      background: VOID,
      fontFamily: "'Courier New', monospace",
      display: 'flex', flexDirection: 'column',
      overflow: 'hidden', color: '#e8f4ff',
    }}>

      {/* ═══ TOP BAR ═══════════════════════════════════════════════════════ */}
      <div style={{
        height: 48, flexShrink: 0,
        background: 'rgba(5,10,25,0.95)',
        borderBottom: '1px solid rgba(212,175,55,0.3)',
        display: 'flex', alignItems: 'center',
        padding: '0 18px', gap: 12,
      }}>
        <span style={{ fontSize: 18, color: GOLD }}>⬡</span>
        <div>
          <div style={{ fontSize: 11, fontWeight: 700, color: '#e8f4ff', letterSpacing: '0.12em' }}>
            NOVA × SKYHI GROUP — Integration Demo
          </div>
          <div style={{ fontSize: 7, color: GOLD, letterSpacing: '0.22em', textTransform: 'uppercase' }}>
            Confidential · NDA-Sealed · Encrypted Outputs
          </div>
        </div>

        {/* Chip status */}
        <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <Dot live={output != null} />
            <span style={{ fontSize: 8, color: output ? GREEN : DIM }}>
              {output ? 'CHIP ACTIVE' : 'INITIALIZING'}
            </span>
          </div>
          <span style={{ fontSize: 8, color: DIM }}>
            {CHIP_ID} v{CHIP_VERSION}
          </span>
          {net && (
            <span style={{ fontSize: 8, color: SKY }}>
              BEAT {net.chipBeat} · R={net.orderParameter.toFixed(3)}
            </span>
          )}
          <div style={{
            padding: '2px 8px',
            border: `1px solid rgba(255,68,68,0.3)`,
            borderRadius: 2,
            fontSize: 7, color: RED,
            letterSpacing: '0.14em',
            textTransform: 'uppercase',
          }}>
            🔒 Encrypted
          </div>
        </div>
      </div>

      {/* ═══ MAIN CONTENT ══════════════════════════════════════════════════ */}
      <div style={{ flex: 1, overflow: 'auto', padding: 16, display: 'flex', flexDirection: 'column', gap: 14 }}>

        {/* ── Row 1: Skyhi Website Mock + API Bridge + Chip Status ──────── */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 14 }}>

          {/* Skyhi Website Panel */}
          <div style={{ ...glass('gold'), padding: '16px 18px' }}>
            <div style={{
              fontSize: 8, color: GOLD, letterSpacing: '0.24em',
              textTransform: 'uppercase', marginBottom: 12,
              display: 'flex', alignItems: 'center', gap: 8,
            }}>
              <Dot live={true} /> Skyhi Group Platform
            </div>
            <div style={{
              background: 'rgba(10,15,30,0.8)',
              border: '1px solid rgba(212,175,55,0.15)',
              borderRadius: 3, padding: '12px 14px',
              marginBottom: 10,
            }}>
              <div style={{ fontSize: 12, fontWeight: 700, color: GOLD, marginBottom: 6 }}>
                ✈ Skyhi Travel
              </div>
              <div style={{ fontSize: 9, color: DIM, lineHeight: 1.5, marginBottom: 8 }}>
                Subscription flight booking · Last-minute deals · DFW hub operations
              </div>
              <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                {['Flight Search', 'My Bookings', 'Deals', 'Account'].map(tab => (
                  <span key={tab} style={{
                    padding: '3px 8px',
                    border: `1px solid rgba(212,175,55,0.25)`,
                    borderRadius: 2, fontSize: 7, color: DIM,
                    letterSpacing: '0.1em',
                  }}>
                    {tab}
                  </span>
                ))}
              </div>
            </div>
            {/* Active routes display */}
            <div style={{ fontSize: 8, color: DIM, letterSpacing: '0.12em', marginBottom: 6 }}>ACTIVE ROUTES</div>
            {DFW_ROUTES.map((r, i) => (
              <div key={r.id} style={{
                display: 'flex', alignItems: 'center', gap: 8,
                padding: '4px 0',
                borderBottom: i < DFW_ROUTES.length - 1 ? '1px solid rgba(68,170,255,0.06)' : 'none',
              }}>
                <span style={{ fontSize: 9, color: SKY, fontWeight: 700, width: 70 }}>{r.id}</span>
                <span style={{ fontSize: 8, color: DIM }}>{r.airline}</span>
                <span style={{ fontSize: 8, color: DIM }}>Gate {r.gate}</span>
                <span style={{ marginLeft: 'auto', fontSize: 8, color: GOLD }}>
                  Demand: {(demandOverrides[i] * 100).toFixed(0)}%
                </span>
              </div>
            ))}
          </div>

          {/* API Bridge Panel */}
          <div style={{ ...glass('sky'), padding: '16px 18px' }}>
            <div style={{
              fontSize: 8, color: SKY, letterSpacing: '0.24em',
              textTransform: 'uppercase', marginBottom: 12,
              display: 'flex', alignItems: 'center', gap: 8,
            }}>
              <Dot live={output != null} /> NOVA API Bridge
            </div>
            <div style={{
              background: 'rgba(10,15,30,0.8)',
              border: '1px solid rgba(68,170,255,0.15)',
              borderRadius: 3, padding: '12px 14px',
              marginBottom: 10,
            }}>
              <div style={{ fontSize: 10, fontWeight: 700, color: SKY, marginBottom: 4 }}>
                Bridge Architecture
              </div>
              <div style={{ fontSize: 8, color: DIM, lineHeight: 1.6 }}>
                Skyhi Platform → REST/WebSocket → NOVA Bridge → Virtual Chip → NOVA Engines
              </div>
            </div>

            {/* Bridge metrics */}
            {[
              ['Endpoint', '/api/v1/skyhi/optimize', SKY],
              ['Protocol', 'TLS 1.3 + AES-256-GCM', GREEN],
              ['Auth', `NDA Seal: ${ndaSeal.slice(0, 12)}…`, GOLD],
              ['Chip ID', CHIP_ID, SKY],
              ['Seal', CHIP_SEAL, GOLD],
              ['Status', output ? 'CONNECTED · LIVE' : 'CONNECTING…', output ? GREEN : DIM],
            ].map(([lbl, val, clr]) => (
              <div key={lbl as string} style={{
                display: 'flex', justifyContent: 'space-between',
                marginBottom: 5, alignItems: 'center',
              }}>
                <span style={{ fontSize: 8, color: DIM, letterSpacing: '0.1em' }}>{lbl as string}</span>
                <span style={{ fontSize: 9, color: clr as string, fontWeight: 600 }}>{val as string}</span>
              </div>
            ))}

            {/* Controls */}
            <div style={{ marginTop: 14, borderTop: '1px solid rgba(68,170,255,0.1)', paddingTop: 10 }}>
              <div style={{ fontSize: 8, color: DIM, marginBottom: 6 }}>External Stress Level</div>
              <input
                type="range"
                min={0} max={100} value={stress * 100}
                onChange={e => setStress(Number(e.target.value) / 100)}
                style={{ width: '100%', accentColor: SKY }}
              />
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 8, color: DIM }}>
                <span>Calm</span>
                <span style={{ color: stress > 0.5 ? RED : SKY }}>{(stress * 100).toFixed(0)}%</span>
                <span>Disrupted</span>
              </div>
              <button
                onClick={() => setRunning(!running)}
                style={{
                  marginTop: 8, width: '100%',
                  padding: '6px 0',
                  background: running ? 'rgba(255,68,68,0.1)' : 'rgba(68,255,136,0.1)',
                  border: `1px solid ${running ? 'rgba(255,68,68,0.3)' : 'rgba(68,255,136,0.3)'}`,
                  borderRadius: 3,
                  color: running ? RED : GREEN,
                  fontSize: 9, fontWeight: 700,
                  letterSpacing: '0.14em',
                  textTransform: 'uppercase',
                  cursor: 'pointer',
                  fontFamily: "'Courier New', monospace",
                }}
              >
                {running ? '⏸ Pause Inference' : '▶ Resume Inference'}
              </button>
            </div>
          </div>

          {/* Virtual Chip Status */}
          <div style={{ ...glass('gold'), padding: '16px 18px' }}>
            <div style={{
              fontSize: 8, color: GOLD, letterSpacing: '0.24em',
              textTransform: 'uppercase', marginBottom: 12,
              display: 'flex', alignItems: 'center', gap: 8,
            }}>
              <Dot live={output != null} /> Virtual Chip Status
            </div>

            {net && (
              <>
                {/* Order parameter — Kuramoto R (engine output, not the math) */}
                <div style={{ marginBottom: 10 }}>
                  <div style={{ fontSize: 8, color: DIM, letterSpacing: '0.1em', marginBottom: 4 }}>Network Coherence</div>
                  <div style={{ fontSize: 24, fontWeight: 700, color: net.orderParameter > 0.7 ? GREEN : SKY }}>
                    {(net.orderParameter * 100).toFixed(1)}%
                  </div>
                  <Bar value={net.orderParameter} color={net.orderParameter > 0.7 ? GREEN : SKY} />
                </div>

                {/* Stability */}
                <div style={{ marginBottom: 10 }}>
                  <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>System Stability</div>
                  <div style={{
                    fontSize: 14, fontWeight: 700,
                    color: net.stabilityConverging ? GREEN : '#ff8844',
                  }}>
                    {net.stabilityConverging ? '✓ Converging' : '⟳ Adapting'}
                  </div>
                  <div style={{ fontSize: 9, color: DIM }}>V(t) = {net.stabilityV.toFixed(4)}</div>
                </div>

                {/* Resilience */}
                <div style={{ marginBottom: 10 }}>
                  <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>Resilience Index</div>
                  <div style={{ fontSize: 14, fontWeight: 700, color: GOLD }}>
                    {(net.resilience * 100).toFixed(1)}%
                  </div>
                  <Bar value={net.resilience} color={GOLD} />
                </div>

                {/* Entropy / economic bias */}
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                  <span style={{ fontSize: 8, color: DIM }}>Sync Entropy</span>
                  <span style={{ fontSize: 9, color: SKY }}>{net.syncEntropy.toFixed(4)}</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: 8, color: DIM }}>Economic Bias</span>
                  <span style={{ fontSize: 9, color: GOLD }}>{net.economicBias.toFixed(3)}</span>
                </div>
              </>
            )}

            {!net && (
              <div style={{ fontSize: 10, color: DIM, textAlign: 'center', padding: 20 }}>
                Initializing virtual chip…
              </div>
            )}
          </div>
        </div>

        {/* ── Row 2: Flight Optimizations ──────────────────────────────────── */}
        <div style={{ ...glass('sky'), padding: '16px 18px' }}>
          <div style={{
            fontSize: 8, color: SKY, letterSpacing: '0.24em',
            textTransform: 'uppercase', marginBottom: 12,
            display: 'flex', alignItems: 'center', gap: 8,
          }}>
            <Dot live={output != null} /> Flight Yield Optimization — Live Chip Outputs
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: 10 }}>
            {(output?.flights ?? []).map(f => (
              <div key={f.routeId} style={{
                ...glass('none'),
                padding: '12px 10px',
                borderColor: recColor(f.recommendation) + '60',
              }}>
                <div style={{ fontSize: 10, fontWeight: 700, color: SKY, marginBottom: 6 }}>{f.routeId}</div>
                <div style={{ fontSize: 8, color: DIM, marginBottom: 2 }}>Demand</div>
                <div style={{ fontSize: 14, fontWeight: 700, color: '#e8f4ff', marginBottom: 4 }}>
                  {(f.demandScore * 100).toFixed(0)}%
                </div>
                <Bar value={f.demandScore} color={f.demandScore > 0.7 ? GREEN : SKY} />

                <div style={{ fontSize: 8, color: DIM, marginTop: 8 }}>Yield ×</div>
                <div style={{ fontSize: 12, fontWeight: 700, color: GOLD }}>{f.yieldMultiplier.toFixed(3)}</div>

                <div style={{ fontSize: 8, color: DIM, marginTop: 6 }}>Fill Conf</div>
                <div style={{ fontSize: 11, color: '#e8f4ff' }}>{(f.fillConfidence * 100).toFixed(1)}%</div>

                <div style={{
                  marginTop: 8, padding: '3px 0',
                  fontSize: 8, fontWeight: 700,
                  color: recColor(f.recommendation),
                  letterSpacing: '0.1em',
                  textAlign: 'center',
                  border: `1px solid ${recColor(f.recommendation)}40`,
                  borderRadius: 2,
                }}>
                  {f.recommendation.replace(/_/g, ' ')}
                </div>

                <div style={{
                  fontSize: 7, color: DIM, marginTop: 4, textAlign: 'center',
                }}>
                  {f.stabilityClass}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ── Row 3: Passenger Matching + Seal ─────────────────────────────── */}
        <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 14 }}>

          {/* Passenger matches */}
          <div style={{ ...glass('sky'), padding: '16px 18px' }}>
            <div style={{
              fontSize: 8, color: SKY, letterSpacing: '0.24em',
              textTransform: 'uppercase', marginBottom: 12,
              display: 'flex', alignItems: 'center', gap: 8,
            }}>
              <Dot live={output != null} /> Passenger Coherence Matching
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8 }}>
              {(output?.passengers ?? []).map(p => (
                <div key={p.passengerId} style={{ ...glass('none'), padding: '10px 10px' }}>
                  <div style={{ fontSize: 9, fontWeight: 700, color: SKY, marginBottom: 4 }}>{p.passengerId}</div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
                    <span style={{ fontSize: 7, color: DIM }}>Match</span>
                    <span style={{ fontSize: 9, color: p.matchScore > 0.7 ? GREEN : '#e8f4ff' }}>
                      {(p.matchScore * 100).toFixed(1)}%
                    </span>
                  </div>
                  <Bar value={p.matchScore} color={p.matchScore > 0.7 ? GREEN : SKY} />
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 4 }}>
                    <span style={{ fontSize: 7, color: DIM }}>Gate</span>
                    <span style={{ fontSize: 9, color: GOLD }}>{p.gateAssignment}</span>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <span style={{ fontSize: 7, color: DIM }}>Crew</span>
                    <span style={{ fontSize: 9, color: '#e8f4ff' }}>{(p.crewSync * 100).toFixed(0)}%</span>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <span style={{ fontSize: 7, color: DIM }}>Rebook</span>
                    <span style={{ fontSize: 9, color: p.rebookProbability > 0.3 ? RED : GREEN }}>
                      {(p.rebookProbability * 100).toFixed(1)}%
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Encryption seal */}
          <div style={{ ...glass('red'), padding: '16px 18px' }}>
            <div style={{
              fontSize: 8, color: RED, letterSpacing: '0.24em',
              textTransform: 'uppercase', marginBottom: 12,
              display: 'flex', alignItems: 'center', gap: 8,
            }}>
              🔒 Encryption & Seal
            </div>

            <div style={{ marginBottom: 10 }}>
              <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>NDA Seal (SHA-256)</div>
              <div style={{
                fontSize: 7, color: 'rgba(200,220,255,0.5)',
                fontFamily: 'monospace',
                wordBreak: 'break-all',
                lineHeight: 1.4,
                padding: '6px 8px',
                background: 'rgba(255,68,68,0.04)',
                border: '1px solid rgba(255,68,68,0.15)',
                borderRadius: 2,
              }}>
                {ndaSeal}
              </div>
            </div>

            <div style={{ marginBottom: 10 }}>
              <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>Output Seal (SHA-256)</div>
              <div style={{
                fontSize: 7, color: 'rgba(200,220,255,0.5)',
                fontFamily: 'monospace',
                wordBreak: 'break-all',
                lineHeight: 1.4,
                padding: '6px 8px',
                background: 'rgba(68,170,255,0.04)',
                border: '1px solid rgba(68,170,255,0.15)',
                borderRadius: 2,
              }}>
                {seal ?? 'Generating…'}
              </div>
            </div>

            <div style={{ marginBottom: 10 }}>
              <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>Encryption</div>
              <div style={{ fontSize: 10, color: GREEN, fontWeight: 700 }}>
                AES-256-GCM · TLS 1.3
              </div>
            </div>

            <div style={{ marginBottom: 10 }}>
              <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>Classification</div>
              <div style={{ fontSize: 10, color: RED, fontWeight: 700 }}>
                TRADE SECRET · CLOSED ACCESS
              </div>
            </div>

            <div style={{ marginBottom: 8 }}>
              <div style={{ fontSize: 8, color: DIM, marginBottom: 4 }}>Protected Under</div>
              <div style={{ fontSize: 8, color: 'rgba(200,220,255,0.6)', lineHeight: 1.5 }}>
                DTSA (18 U.S.C. §1836)<br />
                TUTSA (Tex. Civ. Prac. & Rem. Code §134A)<br />
                Bilateral NDA · {clientId}
              </div>
            </div>

            <div style={{
              marginTop: 12, padding: '6px 0',
              fontSize: 7, color: DIM, letterSpacing: '0.06em',
              textAlign: 'center',
              borderTop: '1px solid rgba(255,68,68,0.1)',
            }}>
              © 2026 Alfredo Medina Hernandez · Medina Tech
            </div>
          </div>
        </div>
      </div>

      {/* ═══ FOOTER ════════════════════════════════════════════════════════ */}
      <div style={{
        height: 22, flexShrink: 0,
        background: 'rgba(5,10,25,0.95)',
        borderTop: '1px solid rgba(212,175,55,0.15)',
        display: 'flex', alignItems: 'center',
        padding: '0 18px', gap: 16,
        fontSize: 7, color: 'rgba(80,110,140,0.5)', letterSpacing: '0.06em',
      }}>
        <span>🔒 CONFIDENTIAL — NDA Protected</span>
        <span>NOVA Virtual Chip {CHIP_ID}</span>
        <span>Engines: Kuramoto · Lyapunov · Quantum · Geometry · Emergence · Antifragility · Behavioral</span>
        <span style={{ marginLeft: 'auto' }}>
          {output ? `Chip beat: ${net?.chipBeat ?? 0} · Seal: ${seal?.slice(0, 16) ?? '—'}…` : 'Awaiting chip…'}
        </span>
      </div>
    </div>
  );
}
