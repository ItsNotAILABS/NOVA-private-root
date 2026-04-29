// ═══════════════════════════════════════════════════════════════════════════
// NOVA BUILDER — Dashboard (Build №42)
// Language: CPL (TypeScript + JSX substrate)
// Live build log via nova_stream · Cycles burn counter · Deploy receipt
// Medina Tech · 2026
// ═══════════════════════════════════════════════════════════════════════════

import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  getNovaBuilderActor,
  buildStatusLabel,
  buildStatusColor,
  type BuildSession,
  type BuildSummary,
  type BuilderStatus,
} from '../canister/novaBuilderActor';

// ── Styles ────────────────────────────────────────────────────────────────
const S = {
  root: {
    width: '100%',
    height: '100%',
    background: '#030810',
    color: '#c8d8f0',
    fontFamily: "'SF Mono', 'Fira Code', monospace",
    display: 'grid',
    gridTemplateColumns: '1fr 340px',
    gridTemplateRows: '100%',
    overflow: 'hidden',
  },
  main: {
    display: 'flex',
    flexDirection: 'column' as const,
    padding: 20,
    gap: 16,
    overflowY: 'auto' as const,
    borderRight: '1px solid #0a2040',
  },
  sidebar: {
    display: 'flex',
    flexDirection: 'column' as const,
    padding: 16,
    gap: 12,
    overflowY: 'auto' as const,
  },
  // Header
  header: {
    display: 'flex',
    alignItems: 'center',
    gap: 12,
    marginBottom: 4,
  },
  title: {
    fontSize: 14,
    color: '#4af',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    fontWeight: 700,
  },
  badge: (open: boolean) => ({
    fontSize: 8,
    padding: '2px 8px',
    background: open ? 'rgba(68,255,68,0.1)' : 'rgba(255,68,68,0.1)',
    border: `1px solid ${open ? '#4f4' : '#f44'}`,
    borderRadius: 3,
    color: open ? '#4f4' : '#f44',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
  }),
  // Intent input
  intentBox: {
    background: '#050d1a',
    border: '1px solid #0a2040',
    borderRadius: 6,
    padding: 16,
  },
  intentLabel: {
    fontSize: 9,
    color: '#3a6080',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    marginBottom: 8,
    display: 'block',
  },
  intentArea: {
    width: '100%',
    minHeight: 90,
    background: '#020810',
    border: '1px solid #0a2040',
    borderRadius: 4,
    color: '#c8d8f0',
    fontFamily: "'SF Mono', 'Fira Code', monospace",
    fontSize: 12,
    padding: '10px 12px',
    resize: 'vertical' as const,
    boxSizing: 'border-box' as const,
    outline: 'none',
  },
  charCount: (warn: boolean) => ({
    fontSize: 8,
    color: warn ? '#f44' : '#2a4060',
    marginTop: 4,
    display: 'block',
    textAlign: 'right' as const,
  }),
  submitBtn: (disabled: boolean) => ({
    padding: '10px 24px',
    background: disabled ? '#020810' : 'linear-gradient(135deg, #0a2040 0%, #0d3060 100%)',
    border: `1px solid ${disabled ? '#0a2040' : '#4af'}`,
    borderRadius: 4,
    color: disabled ? '#1a3050' : '#4af',
    fontSize: 11,
    fontFamily: 'inherit',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    cursor: disabled ? 'not-allowed' : 'pointer',
    marginTop: 10,
  }),
  // Active session
  sessionBox: {
    background: '#050d1a',
    border: '1px solid #0a2040',
    borderRadius: 6,
    padding: 16,
  },
  sessionId: {
    fontSize: 9,
    color: '#2a4060',
    marginBottom: 8,
    fontFamily: 'inherit',
  },
  statusRow: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    marginBottom: 10,
  },
  statusDot: (color: string) => ({
    width: 8,
    height: 8,
    borderRadius: '50%',
    background: color,
    flexShrink: 0,
  }),
  statusText: (color: string) => ({
    fontSize: 12,
    color,
    fontWeight: 600,
    letterSpacing: '0.08em',
  }),
  deployAddress: {
    fontSize: 10,
    color: '#4f4',
    fontFamily: 'inherit',
    wordBreak: 'break-all' as const,
    background: '#020810',
    padding: '6px 10px',
    borderRadius: 3,
    marginTop: 6,
  },
  errorMsg: {
    fontSize: 10,
    color: '#f44',
    marginTop: 6,
  },
  codeBlock: {
    background: '#020810',
    border: '1px solid #0a2040',
    borderRadius: 4,
    padding: '8px 10px',
    fontSize: 9,
    color: '#4a8070',
    fontFamily: 'inherit',
    whiteSpace: 'pre-wrap' as const,
    maxHeight: 160,
    overflowY: 'auto' as const,
    marginTop: 8,
  },
  // Log stream
  logBox: {
    background: '#020810',
    border: '1px solid #0a2040',
    borderRadius: 6,
    padding: 12,
    flex: 1,
    overflowY: 'auto' as const,
    minHeight: 180,
  },
  logLine: (color?: string) => ({
    fontSize: 9,
    color: color || '#2a4060',
    lineHeight: 1.8,
    fontFamily: 'inherit',
  }),
  // Sidebar panels
  panelTitle: {
    fontSize: 8,
    color: '#3a6080',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    marginBottom: 8,
    borderBottom: '1px solid #0a2040',
    paddingBottom: 4,
  },
  poolBar: (pct: number) => ({
    height: 4,
    background: '#0a2040',
    borderRadius: 2,
    marginBottom: 8,
    position: 'relative' as const,
    overflow: 'hidden' as const,
  }),
  poolFill: (pct: number) => ({
    position: 'absolute' as const,
    top: 0,
    left: 0,
    height: '100%',
    width: `${Math.min(100, pct)}%`,
    background: pct > 50 ? '#4f4' : pct > 20 ? '#fa0' : '#f44',
    borderRadius: 2,
    transition: 'width 0.5s ease',
  }),
  metricRow: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'baseline',
    marginBottom: 6,
  },
  metricLabel: {
    fontSize: 8,
    color: '#2a4060',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
  },
  metricValue: (color?: string) => ({
    fontSize: 11,
    color: color || '#4af',
    fontWeight: 600,
  }),
  recentCard: {
    background: '#050d1a',
    border: '1px solid #0a1830',
    borderRadius: 4,
    padding: '8px 10px',
    marginBottom: 6,
  },
  recentIntent: {
    fontSize: 9,
    color: '#4a6880',
    marginBottom: 4,
    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap' as const,
  },
  recentMeta: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  // Template library
  templateBtn: {
    width: '100%',
    textAlign: 'left' as const,
    background: '#050d1a',
    border: '1px solid #0a2040',
    borderRadius: 4,
    padding: '7px 10px',
    color: '#4a8090',
    fontSize: 9,
    fontFamily: "'SF Mono', 'Fira Code', monospace",
    cursor: 'pointer',
    marginBottom: 4,
    letterSpacing: '0.04em',
  },
  // Build pipeline
  pipelineBox: {
    display: 'flex',
    alignItems: 'center',
    gap: 0,
    marginBottom: 10,
    marginTop: 6,
  },
  pipelineStage: (active: boolean, done: boolean) => ({
    fontSize: 8,
    fontWeight: 600,
    letterSpacing: '0.08em',
    color: active ? '#030810' : done ? '#4f4' : '#1a3050',
    background: active ? '#4af' : 'transparent',
    padding: '3px 6px',
    borderRadius: 2,
    whiteSpace: 'nowrap' as const,
  }),
  pipelineArrow: (done: boolean) => ({
    fontSize: 9,
    color: done ? '#4f4' : '#0a2040',
    padding: '0 2px',
  }),
  // Organism tree
  treeBox: {
    background: '#020810',
    border: '1px solid #0a2040',
    borderRadius: 4,
    padding: '8px 10px',
    fontSize: 9,
    color: '#3a6080',
    fontFamily: "'SF Mono', 'Fira Code', monospace",
    whiteSpace: 'pre' as const,
    lineHeight: 1.7,
    overflowX: 'auto' as const,
  },
  registryItem: (deployed: boolean) => ({
    fontSize: 9,
    color: deployed ? '#4f4' : '#2a4060',
    padding: '4px 0',
    borderBottom: '1px solid #0a1830',
  }),
};

// ── Log entry type (local) ────────────────────────────────────────────────
interface LogEntry {
  ts:    string;
  msg:   string;
  color?: string;
}

function fmtCycles(n: bigint): string {
  const bn = Number(n);
  if (bn >= 1e12) return `${(bn / 1e12).toFixed(2)}T`;
  if (bn >= 1e9)  return `${(bn / 1e9).toFixed(1)}B`;
  if (bn >= 1e6)  return `${(bn / 1e6).toFixed(1)}M`;
  return bn.toLocaleString();
}

function fmtPool(balance: bigint, threshold: bigint): number {
  if (threshold === BigInt(0)) return 100;
  const pct = (Number(balance) / Number(threshold)) * 100;
  return Math.min(200, pct); // pool can exceed threshold; cap at 200 for display
}

// ── Template library ──────────────────────────────────────────────────────
const TEMPLATES: { label: string; intent: string }[] = [
  { label: '⊕ Counter',    intent: 'Counter canister with increment, decrement, and get' },
  { label: '⊕ KV Store',   intent: 'Key-value store with CRUD operations' },
  { label: '⊕ Token',      intent: 'Token ledger with mint, transfer, and balance' },
  { label: '⊕ NFT',        intent: 'NFT collection with mint and transfer' },
  { label: '⊕ DAO',        intent: 'DAO governance with proposals and voting' },
  { label: '⊕ Blog/CMS',   intent: 'Blog/CMS with posts and comments' },
];

// ── Build pipeline stages ─────────────────────────────────────────────────
const PIPELINE_STAGES = ['INTENT', 'BRAIN', 'CODE', 'FACTORY', 'DEPLOYED'] as const;

function stageIndex(status: BuildSession['status']): number {
  if ('QUEUED'     in status) return 0;
  if ('GENERATING' in status) return 1;
  if ('GENERATED'  in status) return 2;
  if ('DEPLOYING'  in status) return 3;
  if ('DEPLOYED'   in status) return 4;
  return -1; // FAILED
}

// ── Mock organism registry ────────────────────────────────────────────────
const MOCK_ORGANISMS = [
  { id: 'ORG-001', name: 'Counter Organism',  canisterId: 'bkyz2-fmaaa-aaaaa-qaaaq-cai', deployed: true },
  { id: 'ORG-002', name: 'Token Ledger',      canisterId: 'rrkah-fqaaa-aaaaa-aaaaq-cai', deployed: true },
  { id: 'ORG-003', name: 'DAO Module',        canisterId: null,                          deployed: false },
];

// ── Dashboard component ───────────────────────────────────────────────────
export function NovaBuilderDashboard() {
  const [intent,         setIntent]         = useState('');
  const [submitting,     setSubmitting]      = useState(false);
  const [sessionId,      setSessionId]       = useState<string | null>(null);
  const [session,        setSession]         = useState<BuildSession | null>(null);
  const [status,         setStatus]          = useState<BuilderStatus | null>(null);
  const [recentBuilds,   setRecentBuilds]    = useState<BuildSummary[]>([]);
  const [logs,           setLogs]            = useState<LogEntry[]>([]);
  const [error,          setError]           = useState<string | null>(null);
  const logRef = useRef<HTMLDivElement>(null);

  const MAX_INTENT = 2000;

  function addLog(msg: string, color?: string) {
    const ts = new Date().toISOString().slice(11, 23);
    setLogs(prev => [...prev.slice(-200), { ts, msg, color }]);
  }

  // ── Load status & recent builds ─────────────────────────────────────
  const loadStatus = useCallback(async () => {
    try {
      const actor = getNovaBuilderActor();
      const [s, r] = await Promise.all([
        actor.getBuilderStatus(),
        actor.getRecentBuilds(BigInt(10)),
      ]);
      setStatus(s);
      setRecentBuilds(r);
    } catch (e) {
      addLog('Status fetch failed (canister not deployed — demo mode)', '#fa0');
      // Provide mock status for visual demo when canister isn't deployed
      setStatus({
        buildNumber:       BigInt(42),
        sovereignSeal:     'NOVA-BUILDER-BUILD42-DEMO',
        totalBuilds:       BigInt(0),
        totalDeployed:     BigInt(0),
        totalFailed:       BigInt(0),
        totalCyclesBurned: BigInt(0),
        subsidyPoolBalance: BigInt(5_000_000_000),
        cyclesPerBuild:    BigInt(1_000_000_000),
        subsidyThreshold:  BigInt(500_000_000),
        queueDepth:        BigInt(0),
        openToBuilders:    true,
        missionStatement:  'Non-profit. Sovereign. Permissionless. Every build burns ICP cycles.',
        uptimeNs:          BigInt(0),
      });
    }
  }, []);

  useEffect(() => {
    loadStatus();
    addLog('NOVA BUILDER BUILD №42 — Sovereign CaffeineAI Replacement', '#4af');
    addLog('Non-Profit · Permissionless · On-Chain · Cannot Be Shut Down', '#4f4');
    addLog('Awaiting build intent submission...', '#3a6080');
  }, [loadStatus]);

  // Auto-refresh status every 5s
  useEffect(() => {
    const t = setInterval(loadStatus, 5000);
    return () => clearInterval(t);
  }, [loadStatus]);

  // ── Poll active session ──────────────────────────────────────────────
  useEffect(() => {
    if (!sessionId) return;
    const poll = async () => {
      try {
        const actor = getNovaBuilderActor();
        const result = await actor.getBuildSession(sessionId);
        if (result.length > 0) {
          const s = result[0];
          setSession(s);
          const label = buildStatusLabel(s.status);
          if ('DEPLOYED' in s.status || 'FAILED' in s.status) {
            // Terminal — stop polling
            if ('DEPLOYED' in s.status) {
              addLog(`✓ DEPLOYED: ${s.deployAddress}`, '#4f4');
              addLog(`  Cycles burned: ${fmtCycles(s.cyclesConsumed)}`, '#4f4');
              loadStatus();
            } else {
              addLog(`✗ FAILED: ${s.errorMsg}`, '#f44');
            }
            return;
          }
          addLog(`Session ${sessionId} → ${label}`, buildStatusColor(s.status));
        }
      } catch {
        addLog('Session poll error', '#f44');
      }
    };
    const t = setInterval(poll, 2000);
    return () => clearInterval(t);
  }, [sessionId, loadStatus]);

  // Auto-scroll log
  useEffect(() => {
    if (logRef.current) {
      logRef.current.scrollTop = logRef.current.scrollHeight;
    }
  }, [logs]);

  // ── Submit build ────────────────────────────────────────────────────
  const handleSubmit = async () => {
    if (!intent.trim() || submitting) return;
    setSubmitting(true);
    setError(null);
    setSession(null);
    setSessionId(null);
    addLog(`Submitting build intent: "${intent.slice(0, 60)}${intent.length > 60 ? '...' : ''}"`, '#4af');
    try {
      const actor = getNovaBuilderActor();
      const sid = await actor.submitBuild(intent);
      if (sid.startsWith('NB-')) {
        setSessionId(sid);
        addLog(`Session created: ${sid}`, '#4af');
        addLog('AGI reasoning in progress...', '#fa0');
      } else {
        setError(sid);
        addLog(`Submission error: ${sid}`, '#f44');
      }
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      setError(msg);
      addLog(`Error: ${msg}`, '#f44');
    } finally {
      setSubmitting(false);
    }
  };

  const isOpen = status?.openToBuilders ?? true;
  const poolPct = status
    ? fmtPool(status.subsidyPoolBalance, status.subsidyThreshold)
    : 100;

  return (
    <div style={S.root}>
      {/* ── Main panel ─────────────────────────────────────────── */}
      <div style={S.main}>

        {/* Header */}
        <div style={S.header}>
          <span style={S.title}>⊕ NOVA BUILDER</span>
          <span style={S.badge(isOpen)}>{isOpen ? '● OPEN — Build Now' : '○ POOL LOW'}</span>
          <span style={{ marginLeft: 'auto', fontSize: 8, color: '#2a4060' }}>
            BUILD №42 · NON-PROFIT
          </span>
        </div>

        {/* Intent input */}
        <div style={S.intentBox}>
          <span style={S.intentLabel}>
            ⌨ Describe what you want to build (plain language)
          </span>
          <textarea
            style={S.intentArea}
            value={intent}
            onChange={e => setIntent(e.target.value)}
            placeholder={
              'Examples:\n' +
              '• A counter canister that tracks votes\n' +
              '• A simple key-value store with get/set/delete\n' +
              '• A canister that stores and retrieves user profiles'
            }
            maxLength={MAX_INTENT}
            disabled={submitting}
          />
          <span style={S.charCount(intent.length > MAX_INTENT * 0.9)}>
            {intent.length}/{MAX_INTENT}
          </span>
          <div>
            <button
              style={S.submitBtn(!isOpen || submitting || intent.trim().length === 0)}
              onClick={handleSubmit}
              disabled={!isOpen || submitting || intent.trim().length === 0}
            >
              {submitting ? '◉ Submitting...' : '⊕ Build It — Free · No Account Needed'}
            </button>
          </div>
          {error && <div style={{ fontSize: 10, color: '#f44', marginTop: 8 }}>{error}</div>}
        </div>

        {/* Template library */}
        <div style={S.intentBox}>
          <span style={S.intentLabel}>⊞ Templates — Click to populate</span>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 4 }}>
            {TEMPLATES.map(t => (
              <button
                key={t.label}
                style={S.templateBtn}
                onClick={() => setIntent(t.intent)}
                disabled={submitting}
              >
                {t.label}
              </button>
            ))}
          </div>
        </div>

        {/* Active session */}
        {session && (
          <div style={S.sessionBox}>
            <div style={S.sessionId}>Session: {session.sessionId}</div>
            <div style={S.statusRow}>
              <div style={S.statusDot(buildStatusColor(session.status))} />
              <span style={S.statusText(buildStatusColor(session.status))}>
                {buildStatusLabel(session.status)}
              </span>
              <span style={{ marginLeft: 'auto', fontSize: 8, color: '#2a4060' }}>
                {fmtCycles(session.cyclesConsumed)} cycles committed
              </span>
            </div>
            {/* Build pipeline visualization */}
            <div style={S.pipelineBox}>
              {PIPELINE_STAGES.map((stage, i) => {
                const si = stageIndex(session.status);
                const done    = si > i;
                const active  = si === i;
                const failed  = si === -1;
                return (
                  <React.Fragment key={stage}>
                    {i > 0 && (
                      <span style={S.pipelineArrow(done)}>→</span>
                    )}
                    <span style={S.pipelineStage(active, done)}>
                      {done ? '✓' : active ? '◉' : failed ? '✗' : '○'}{' '}{stage}
                    </span>
                  </React.Fragment>
                );
              })}
            </div>
            {'DEPLOYED' in session.status && session.deployAddress && (
              <div style={S.deployAddress}>
                ✓ Canister deployed: {session.deployAddress}
              </div>
            )}
            {'FAILED' in session.status && session.errorMsg && (
              <div style={S.errorMsg}>✗ {session.errorMsg}</div>
            )}
            {session.generatedCode && (
              <div style={S.codeBlock}>{session.generatedCode}</div>
            )}
          </div>
        )}

        {/* Build log */}
        <div style={S.logBox} ref={logRef}>
          {logs.map((l, i) => (
            <div key={i} style={S.logLine(l.color)}>
              <span style={{ color: '#1a3050' }}>[{l.ts}]</span>{' '}
              {l.msg}
            </div>
          ))}
        </div>
      </div>

      {/* ── Sidebar ──────────────────────────────────────────────── */}
      <div style={S.sidebar}>

        {/* Pool health */}
        <div>
          <div style={S.panelTitle}>Cycles Subsidy Pool</div>
          <div style={S.poolBar(poolPct)}>
            <div style={S.poolFill(poolPct)} />
          </div>
          {status && (
            <>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Pool balance</span>
                <span style={S.metricValue('#4af')}>{fmtCycles(status.subsidyPoolBalance)}</span>
              </div>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Per build</span>
                <span style={S.metricValue()}>{fmtCycles(status.cyclesPerBuild)}</span>
              </div>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Total burned</span>
                <span style={S.metricValue('#4f4')}>{fmtCycles(status.totalCyclesBurned)}</span>
              </div>
            </>
          )}
        </div>

        {/* Build stats */}
        <div>
          <div style={S.panelTitle}>Build Statistics</div>
          {status ? (
            <>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Total builds</span>
                <span style={S.metricValue()}>{Number(status.totalBuilds).toLocaleString()}</span>
              </div>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Deployed</span>
                <span style={S.metricValue('#4f4')}>{Number(status.totalDeployed).toLocaleString()}</span>
              </div>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Failed</span>
                <span style={S.metricValue('#f44')}>{Number(status.totalFailed).toLocaleString()}</span>
              </div>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Queue depth</span>
                <span style={S.metricValue('#fa0')}>{Number(status.queueDepth)}</span>
              </div>
            </>
          ) : (
            <div style={{ fontSize: 9, color: '#2a4060' }}>Loading...</div>
          )}
        </div>

        {/* Mission */}
        <div>
          <div style={S.panelTitle}>Mission Statement</div>
          <div style={{ fontSize: 9, color: '#3a6080', lineHeight: 1.7 }}>
            {status?.missionStatement ?? 'Non-profit. Sovereign. Permissionless. Every build burns ICP cycles.'}
          </div>
        </div>

        {/* Recent builds */}
        <div>
          <div style={S.panelTitle}>Recent Builds (Public Proof)</div>
          {recentBuilds.length === 0 ? (
            <div style={{ fontSize: 9, color: '#1a3050' }}>No builds yet — be the first.</div>
          ) : (
            recentBuilds.map(b => (
              <div key={b.sessionId} style={S.recentCard}>
                <div style={S.recentIntent}>{b.intent}</div>
                <div style={S.recentMeta}>
                  <span style={{ fontSize: 8, color: buildStatusColor(b.status), letterSpacing: '0.1em' }}>
                    {buildStatusLabel(b.status)}
                  </span>
                  <span style={{ fontSize: 8, color: '#2a4060' }}>
                    {fmtCycles(b.cyclesConsumed)} burned
                  </span>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Organism branching visualization */}
        <div>
          <div style={S.panelTitle}>Organism Branching</div>
          <div style={S.treeBox}>
{`◉ ORGANISM VEIN
├── ⊕ Counter Module
│   ├── increment()
│   └── decrement()
├── ⊕ Token Branch
│   ├── mint()
│   ├── transfer()
│   └── ⊕ Audit Sub-Branch
│       ├── log()
│       └── verify()
├── ⊕ DAO Branch
│   ├── propose()
│   └── vote()
└── ⊕ [Next Build...]`}
          </div>
          <div style={{ fontSize: 8, color: '#1a3050', marginTop: 4, lineHeight: 1.6 }}>
            Each build creates a vein. Products branch off.<br />
            Sub-branches extend the organism tree.
          </div>
        </div>

        {/* Organism registry */}
        <div>
          <div style={S.panelTitle}>Your Organisms</div>
          {MOCK_ORGANISMS.map(org => (
            <div key={org.id} style={S.registryItem(org.deployed)}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span>{org.deployed ? '●' : '○'} {org.name}</span>
                <span style={{ fontSize: 7, color: '#2a4060' }}>{org.id}</span>
              </div>
              {org.canisterId && (
                <div style={{ fontSize: 8, color: '#2a4060', marginTop: 2, paddingLeft: 12 }}>
                  └ {org.canisterId}
                </div>
              )}
            </div>
          ))}
        </div>

        {/* No-account doctrine + pipeline status */}
        <div style={{ marginTop: 'auto' }}>
          <div style={S.panelTitle}>Automated Pipeline</div>
          <div style={{ fontSize: 8, color: '#4a6880', lineHeight: 1.8, marginBottom: 12 }}>
            ● Intent → swarm_brain (AGI code gen)<br />
            ● Code → sovereign_factory (deploy)<br />
            ● Cycles burned → ICP deflation<br />
            ● Heartbeat processes queue every tick<br />
            ● Graduated rate by pool balance
          </div>
          <div style={S.panelTitle}>No-Limit Doctrine</div>
          <div style={{ fontSize: 8, color: '#1a3050', lineHeight: 1.8 }}>
            ● No account limits · Ever<br />
            ● No signup required<br />
            ● No ToS shutdown clause<br />
            ● Pool-rate limited only<br />
            ● Every build = ICP deflation<br />
            ● Community-governed DAO<br />
            ● Runs on ICP · Cannot stop
          </div>
        </div>
      </div>
    </div>
  );
}
