// ═══════════════════════════════════════════════════════════════════════════
// PARALLAX DASHBOARD — Runtime Clearinghouse App
// Language: TypeScript + React (CPL: typed JSX calling Motoko canister)
// Wired to: phantom_transfer/main.mo Build №35 — real canister calls
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// ═══════════════════════════════════════════════════════════════════════════

import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  parallax_getClearinghouseStatus,
  parallax_getExchangeRates,
  parallax_getQueuedExits,
  parallax_registerUser,
  parallax_ingestFiatPayment,
  parallax_sendRemittance,
  parallax_exitToFiat,
  parallax_generateClaimLink,
  parallax_redeemClaimLink,
  type ClearinghouseStatus,
  type ExchangeRate,
  type QueuedExit,
} from '../canister/parallaxActor';

// ── Tab definition ────────────────────────────────────────────────────────
type DashTab = 'STATUS' | 'SEND' | 'RATES' | 'EXITS' | 'CLAIMS' | 'REGISTER';

// ── Number formatting helpers ─────────────────────────────────────────────
const fmtBig = (n: bigint | undefined): string =>
  n !== undefined ? n.toLocaleString() : '—';
const fmtCents = (cents: bigint, currency = ''): string => {
  if (cents === undefined) return '—';
  const major = Number(cents) / 100;
  return `${major.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })} ${currency}`;
};

// ── Styles ────────────────────────────────────────────────────────────────
const C = {
  root: {
    width: '100%',
    height: '100%',
    background: '#050a14',
    color: '#e0f0ff',
    fontFamily: "'Courier New', monospace",
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  },
  header: {
    height: 44,
    background: '#070e1e',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    padding: '0 16px',
    gap: 6,
    flexShrink: 0,
  },
  brand: {
    fontSize: 11,
    color: '#44aaff',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    marginRight: 20,
    fontWeight: 700,
  },
  tabBtn: (active: boolean) => ({
    padding: '4px 12px',
    fontSize: 9,
    background:   active ? '#1a3a5c' : 'transparent',
    color:        active ? '#44aaff' : '#3a6080',
    border:       `1px solid ${active ? '#44aaff' : 'transparent'}`,
    borderRadius: 3,
    cursor:       'pointer',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    fontFamily: "'Courier New', monospace",
  }),
  statusDot: (live: boolean) => ({
    width: 6, height: 6, borderRadius: '50%',
    background: live ? '#4f4' : '#f44',
    marginLeft: 'auto',
  }),
  statusText: (live: boolean) => ({
    fontSize: 8, color: live ? '#4f4' : '#f44', letterSpacing: '0.12em',
  }),
  body: {
    flex: 1,
    overflowY: 'auto' as const,
    padding: 20,
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))',
    gap: 16,
    alignContent: 'start',
  },
  fullBody: {
    flex: 1, overflowY: 'auto' as const, padding: 20,
  },
  panel: {
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    borderRadius: 6,
    padding: 16,
  },
  panelTitle: {
    fontSize: 9,
    color: '#44aaff',
    letterSpacing: '0.2em',
    textTransform: 'uppercase' as const,
    marginBottom: 14,
    borderBottom: '1px solid #1a2a3c',
    paddingBottom: 8,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  row: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: 11,
    padding: '5px 0',
    borderBottom: '1px solid #0d1a28',
  },
  rowLabel: { color: '#3a6080' },
  rowVal: (accent = false) => ({ color: accent ? '#44aaff' : '#c0e0ff', fontWeight: accent ? 700 : 400 }),
  input: {
    width: '100%',
    background: '#040c1a',
    border: '1px solid #1a3a5c',
    borderRadius: 3,
    padding: '8px 10px',
    fontSize: 11,
    color: '#c0e0ff',
    fontFamily: "'Courier New', monospace",
    marginBottom: 10,
    outline: 'none',
  },
  select: {
    width: '100%',
    background: '#040c1a',
    border: '1px solid #1a3a5c',
    borderRadius: 3,
    padding: '8px 10px',
    fontSize: 11,
    color: '#c0e0ff',
    fontFamily: "'Courier New', monospace",
    marginBottom: 10,
  },
  label: {
    fontSize: 9,
    color: '#3a6080',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    marginBottom: 4,
    display: 'block',
  },
  btn: (variant: 'primary' | 'secondary' | 'danger') => ({
    padding: '9px 20px',
    fontSize: 10,
    fontFamily: "'Courier New', monospace",
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    border: 'none',
    borderRadius: 3,
    cursor: 'pointer',
    fontWeight: 700,
    background: variant === 'primary' ? '#44aaff' : variant === 'danger' ? '#f44' : '#1a3a5c',
    color: variant === 'primary' ? '#050a14' : '#c0e0ff',
    marginRight: 8,
    marginTop: 4,
  }),
  msg: (ok: boolean) => ({
    fontSize: 10,
    color: ok ? '#4f4' : '#f66',
    marginTop: 10,
    lineHeight: 1.5,
    wordBreak: 'break-all' as const,
    background: ok ? '#071a07' : '#1a0707',
    border: `1px solid ${ok ? '#1a4a1a' : '#4a1a1a'}`,
    borderRadius: 3,
    padding: '8px 10px',
  }),
  rateCard: (currency: string) => ({
    display: 'inline-flex',
    flexDirection: 'column' as const,
    background: '#040c1a',
    border: '1px solid #1a3a5c',
    borderRadius: 4,
    padding: '10px 14px',
    marginRight: 10,
    marginBottom: 10,
    minWidth: 90,
  }),
  rateCurrency: { fontSize: 16, color: '#44aaff', fontWeight: 700 },
  rateVal: { fontSize: 10, color: '#3a6080', marginTop: 4 },
  exitRow: {
    background: '#040c1a',
    border: '1px solid #1a2a3c',
    borderRadius: 4,
    padding: '10px 12px',
    marginBottom: 8,
    fontSize: 10,
  },
  exitStatus: (s: string) => ({
    fontSize: 8,
    letterSpacing: '0.12em',
    color: s === 'QUEUED' ? '#fa0' : s === 'DELIVERED' ? '#4f4' : '#f44',
    textTransform: 'uppercase' as const,
  }),
  spinner: {
    color: '#44aaff',
    fontSize: 10,
    letterSpacing: '0.15em',
    animation: 'pulse 1s infinite',
  },
};

const CURRENCIES = ['USD', 'MXN', 'EUR', 'GBP', 'JPY', 'BRL'];
const REF_TYPES  = ['BANK_ACH', 'BANK_SPEI', 'BANK_SEPA', 'BANK_ZENGIN', 'CARD_VISA', 'CARD_CHIME', 'PHONE', 'CLAIM_LINK', 'NOVA_WALLET'];
const EXIT_RAILS = ['ACH', 'SPEI', 'SEPA', 'ZENGIN', 'PIX', 'CARD', 'NOVA'];

// ── Sub-panels ────────────────────────────────────────────────────────────

function StatusPanel({ status, loading }: { status: ClearinghouseStatus | null; loading: boolean }) {
  if (loading) return <div style={C.panel}><div style={C.panelTitle}>Status</div><div style={C.spinner}>Loading…</div></div>;
  if (!status)  return <div style={C.panel}><div style={C.panelTitle}>Status</div><div style={{ fontSize: 10, color: '#f44' }}>Canister unreachable — check connection</div></div>;

  const rows: Array<[string, string, boolean?]> = [
    ['Build', status.buildNumber.toString()],
    ['Transfers settled', fmtBig(status.totalTransfersSettled), true],
    ['Total remittances', fmtBig(status.totalRemittances), true],
    ['Fees collected (ONESICAN)', fmtBig(status.totalFeesCollected)],
    ['Registered users', fmtBig(status.registeredUsers)],
    ['Linked accounts', fmtBig(status.linkedAccountsTotal)],
    ['Claims generated', fmtBig(status.claimsGenerated)],
    ['Claims redeemed', fmtBig(status.claimsRedeemed)],
    ['Exits queued', fmtBig(status.exitsQueued)],
    ['Exits delivered', fmtBig(status.exitsDelivered)],
    ['Liquidity pool', fmtBig(status.liquidityPool) + ' ONESICAN'],
    ['Group E neurons', fmtBig(status.groupENeurons)],
    ['Oracles', fmtBig(status.authorizedOracles)],
  ];

  return (
    <div style={C.panel}>
      <div style={C.panelTitle}>
        <span>Clearinghouse Status</span>
        <span style={{ fontSize: 8, color: '#3a6080' }}>LIVE · Build #{status.buildNumber.toString()}</span>
      </div>
      {rows.map(([l, v, accent]) => (
        <div key={l} style={C.row}>
          <span style={C.rowLabel}>{l}</span>
          <span style={C.rowVal(!!accent)}>{v}</span>
        </div>
      ))}
      <div style={{ fontSize: 8, color: '#2a4a60', marginTop: 10, lineHeight: 1.5, fontStyle: 'italic' }}>
        {status.architectureStatement?.slice(0, 200)}…
      </div>
    </div>
  );
}

function RatesPanel({ rates, loading }: { rates: ExchangeRate[]; loading: boolean }) {
  if (loading) return <div style={C.panel}><div style={C.panelTitle}>Exchange Rates</div><div style={C.spinner}>Loading…</div></div>;
  return (
    <div style={C.panel}>
      <div style={C.panelTitle}>
        <span>Exchange Rates</span>
        <span style={{ fontSize: 8, color: '#3a6080' }}>Oracle-live · setExchangeRate()</span>
      </div>
      <div style={{ display: 'flex', flexWrap: 'wrap' as const }}>
        {rates.map((r) => (
          <div key={r.currency} style={C.rateCard(r.currency)}>
            <span style={C.rateCurrency}>{r.currency}</span>
            <span style={C.rateVal}>{r.ratePerCent.toString()} ONESICAN / 100¢</span>
            <span style={{ ...C.rateVal, fontSize: 8 }}>by {r.updatedBy.slice(0, 12)}…</span>
          </div>
        ))}
      </div>
      <div style={{ fontSize: 9, color: '#2a4a60', marginTop: 8 }}>
        φ⁻⁴ fee = 0.146% on all fiat rails · Rates updatable by oracle or sovereign
      </div>
    </div>
  );
}

function ExitsPanel({ exits, loading, onRefresh }: { exits: QueuedExit[]; loading: boolean; onRefresh: () => void }) {
  return (
    <div style={{ ...C.panel, gridColumn: '1 / -1' }}>
      <div style={C.panelTitle}>
        <span>Queued Fiat Exits</span>
        <button style={C.btn('secondary')} onClick={onRefresh}>↻ Refresh</button>
      </div>
      {loading && <div style={C.spinner}>Loading…</div>}
      {!loading && exits.length === 0 && <div style={{ fontSize: 10, color: '#3a6080' }}>No exits queued. Bridge is idle.</div>}
      {exits.map((ex) => (
        <div key={ex.exitId.toString()} style={C.exitRow}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
            <span style={{ color: '#44aaff', fontWeight: 700 }}>Exit #{ex.exitId.toString()}</span>
            <span style={C.exitStatus(ex.status)}>{ex.status}</span>
          </div>
          <div style={{ color: '#3a6080' }}>
            {fmtBig(ex.amountOnesican)} ONESICAN → {fmtCents(ex.amountFiat, ex.targetCurrency)} via {ex.exitRail}
          </div>
          <div style={{ color: '#2a4a60', fontSize: 9, marginTop: 4 }}>
            to: {ex.destRef} · {ex.note}
          </div>
        </div>
      ))}
    </div>
  );
}

// ── Send Remittance form ──────────────────────────────────────────────────
function SendPanel() {
  const [fromCurrency, setFromCurrency] = useState('MXN');
  const [amountCents,  setAmountCents]  = useState('');
  const [fromCardRef,  setFromCardRef]  = useState('');
  const [toCurrency,   setToCurrency]   = useState('USD');
  const [toRef,        setToRef]        = useState('');
  const [toRefType,    setToRefType]    = useState('BANK_ACH');
  const [note,         setNote]         = useState('');
  const [loading,      setLoading]      = useState(false);
  const [result,       setResult]       = useState<{ ok: boolean; msg: string } | null>(null);

  const submit = useCallback(async () => {
    setLoading(true);
    setResult(null);
    try {
      const cents = Math.round(parseFloat(amountCents) * 100);
      if (!cents || cents <= 0) throw new Error('Amount must be > 0');
      const res = await parallax_sendRemittance(
        fromCurrency, cents, fromCardRef || 'CARD-TOKEN-' + Date.now(),
        toCurrency, toRef, toRefType, note || 'via PARALLAX PWA'
      );
      setResult({ ok: res.success, msg: res.message });
    } catch (err: unknown) {
      setResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally {
      setLoading(false);
    }
  }, [fromCurrency, amountCents, fromCardRef, toCurrency, toRef, toRefType, note]);

  return (
    <div style={C.panel}>
      <div style={C.panelTitle}>
        <span>Send Remittance</span>
        <span style={{ fontSize: 8, color: '#3a6080' }}>sendRemittance() → canister</span>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
        <div>
          <label style={C.label}>From currency</label>
          <select style={C.select} value={fromCurrency} onChange={e => setFromCurrency(e.target.value)}>
            {CURRENCIES.map(c => <option key={c}>{c}</option>)}
          </select>
        </div>
        <div>
          <label style={C.label}>Amount (major units)</label>
          <input
            style={C.input}
            type="number"
            min="0"
            step="0.01"
            placeholder="e.g. 5000"
            value={amountCents}
            onChange={e => setAmountCents(e.target.value)}
          />
        </div>
      </div>

      <label style={C.label}>From card/bank reference (tokenized)</label>
      <input
        style={C.input}
        placeholder="CARD-TOKEN-xxx or BANK-ACH-xxx (off-chain tokenized ref)"
        value={fromCardRef}
        onChange={e => setFromCardRef(e.target.value)}
      />

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
        <div>
          <label style={C.label}>To currency</label>
          <select style={C.select} value={toCurrency} onChange={e => setToCurrency(e.target.value)}>
            {CURRENCIES.map(c => <option key={c}>{c}</option>)}
          </select>
        </div>
        <div>
          <label style={C.label}>Delivery type</label>
          <select style={C.select} value={toRefType} onChange={e => setToRefType(e.target.value)}>
            {REF_TYPES.map(r => <option key={r}>{r}</option>)}
          </select>
        </div>
      </div>

      <label style={C.label}>Recipient reference (routing+acct / CLABE / phone / card)</label>
      <input
        style={C.input}
        placeholder="e.g. 021000021-1234567890 or +52-123-456-7890"
        value={toRef}
        onChange={e => setToRef(e.target.value)}
      />

      <label style={C.label}>Note (optional)</label>
      <input style={C.input} placeholder="Para mi familia" value={note} onChange={e => setNote(e.target.value)} />

      <button style={C.btn('primary')} onClick={submit} disabled={loading}>
        {loading ? 'Settling…' : 'Send →'}
      </button>

      {result && (
        <div style={C.msg(result.ok)}>
          {result.ok ? '✓ ' : '✗ '}{result.msg}
        </div>
      )}

      <div style={{ fontSize: 9, color: '#2a4a60', marginTop: 12, lineHeight: 1.5 }}>
        PHONE / CLAIM_LINK → generates claim link (no NOVA account needed) ·
        All other types → exit queued to fiat rail ·
        Fee: φ⁻⁴ = 0.146%
      </div>
    </div>
  );
}

// ── Claim Links panel ─────────────────────────────────────────────────────
function ClaimsPanel() {
  // Generate claim link
  const [genAmount,  setGenAmount]  = useState('');
  const [genCurrency,setGenCurrency]= useState('MXN');
  const [genMethod,  setGenMethod]  = useState('CARD_VISA');
  const [genNote,    setGenNote]    = useState('');
  const [genResult,  setGenResult]  = useState<{ ok: boolean; msg: string } | null>(null);
  const [genLoading, setGenLoading] = useState(false);

  // Redeem claim link
  const [redeemCode,   setRedeemCode]   = useState('');
  const [redeemMethod, setRedeemMethod] = useState('CARD_VISA');
  const [redeemRef,    setRedeemRef]    = useState('');
  const [redeemResult, setRedeemResult] = useState<{ ok: boolean; msg: string } | null>(null);
  const [redeemLoading,setRedeemLoading]= useState(false);

  const generate = useCallback(async () => {
    setGenLoading(true);
    setGenResult(null);
    try {
      const onesicans = Math.round(parseFloat(genAmount) * 100);
      if (!onesicans || onesicans <= 0) throw new Error('Amount must be > 0');
      const res = await parallax_generateClaimLink(onesicans, genCurrency, genMethod, genNote || 'claim link');
      setGenResult({ ok: res.success, msg: res.message + (res.claimCode ? `\nCode: ${res.claimCode}` : '') });
    } catch (err: unknown) {
      setGenResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally {
      setGenLoading(false);
    }
  }, [genAmount, genCurrency, genMethod, genNote]);

  const redeem = useCallback(async () => {
    setRedeemLoading(true);
    setRedeemResult(null);
    try {
      if (!redeemCode.trim()) throw new Error('Claim code is required');
      const res = await parallax_redeemClaimLink(redeemCode.trim(), redeemMethod, redeemRef);
      setRedeemResult({ ok: res.success, msg: res.message });
    } catch (err: unknown) {
      setRedeemResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally {
      setRedeemLoading(false);
    }
  }, [redeemCode, redeemMethod, redeemRef]);

  return (
    <div style={{ ...C.panel, gridColumn: '1 / -1', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24 }}>
      {/* Generate */}
      <div>
        <div style={C.panelTitle}>
          <span>Generate Claim Link</span>
          <span style={{ fontSize: 8, color: '#3a6080' }}>generateClaimLink() → canister</span>
        </div>
        <label style={C.label}>Amount (ONESICAN units — enter major currency)</label>
        <input style={C.input} type="number" min="0" step="0.01" placeholder="e.g. 900" value={genAmount} onChange={e => setGenAmount(e.target.value)} />
        <label style={C.label}>Currency</label>
        <select style={C.select} value={genCurrency} onChange={e => setGenCurrency(e.target.value)}>
          {CURRENCIES.map(c => <option key={c}>{c}</option>)}
        </select>
        <label style={C.label}>Redeem method</label>
        <select style={C.select} value={genMethod} onChange={e => setGenMethod(e.target.value)}>
          {REF_TYPES.map(r => <option key={r}>{r}</option>)}
        </select>
        <label style={C.label}>Note</label>
        <input style={C.input} placeholder="For María's sister" value={genNote} onChange={e => setGenNote(e.target.value)} />
        <button style={C.btn('primary')} onClick={generate} disabled={genLoading}>
          {genLoading ? 'Generating…' : 'Generate Claim Link'}
        </button>
        {genResult && <div style={C.msg(genResult.ok)}>{genResult.ok ? '✓ ' : '✗ '}{genResult.msg}</div>}
        <div style={{ fontSize: 9, color: '#2a4a60', marginTop: 8 }}>
          72h expiry · Recipient redeems without NOVA account
        </div>
      </div>

      {/* Redeem */}
      <div>
        <div style={C.panelTitle}>
          <span>Redeem Claim Link</span>
          <span style={{ fontSize: 8, color: '#3a6080' }}>redeemClaimLink() → canister</span>
        </div>
        <label style={C.label}>Claim code</label>
        <input style={C.input} placeholder="NOVA-CLM-1-MXN-900" value={redeemCode} onChange={e => setRedeemCode(e.target.value)} />
        <label style={C.label}>Delivery method</label>
        <select style={C.select} value={redeemMethod} onChange={e => setRedeemMethod(e.target.value)}>
          {REF_TYPES.filter(r => r !== 'CLAIM_LINK').map(r => <option key={r}>{r}</option>)}
        </select>
        <label style={C.label}>Recipient reference</label>
        <input style={C.input} placeholder="CLABE / card token / routing+acct" value={redeemRef} onChange={e => setRedeemRef(e.target.value)} />
        <button style={C.btn('primary')} onClick={redeem} disabled={redeemLoading}>
          {redeemLoading ? 'Redeeming…' : 'Redeem →'}
        </button>
        {redeemResult && <div style={C.msg(redeemResult.ok)}>{redeemResult.ok ? '✓ ' : '✗ '}{redeemResult.msg}</div>}
        <div style={{ fontSize: 9, color: '#2a4a60', marginTop: 8 }}>
          Any delivery method accepted · No NOVA account required
        </div>
      </div>
    </div>
  );
}

// ── Register User panel ────────────────────────────────────────────────────
function RegisterPanel() {
  const [label,  setLabel]  = useState('');
  const [result, setResult] = useState<{ ok: boolean; msg: string } | null>(null);
  const [loading,setLoading]= useState(false);

  const submit = useCallback(async () => {
    setLoading(true);
    setResult(null);
    try {
      const res = await parallax_registerUser(label || 'PARALLAX USER');
      setResult({ ok: res.success, msg: res.message + ` | Tier: ${res.tier}` });
    } catch (err: unknown) {
      setResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally {
      setLoading(false);
    }
  }, [label]);

  return (
    <div style={C.panel}>
      <div style={C.panelTitle}>
        <span>Register Identity</span>
        <span style={{ fontSize: 8, color: '#3a6080' }}>registerUser() → canister</span>
      </div>
      <div style={{ fontSize: 10, color: '#3a6080', marginBottom: 12, lineHeight: 1.6 }}>
        Creates a persistent PARALLAX identity tied to your ICP principal.
        Required before sending remittances or linking accounts.
        Tier 1–4 auto-assigned based on linked rails.
      </div>
      <label style={C.label}>Label (your name / handle)</label>
      <input style={C.input} placeholder="e.g. María Monterrey" value={label} onChange={e => setLabel(e.target.value)} />
      <button style={C.btn('primary')} onClick={submit} disabled={loading}>
        {loading ? 'Registering…' : 'Register →'}
      </button>
      {result && <div style={C.msg(result.ok)}>{result.ok ? '✓ ' : '✗ '}{result.msg}</div>}
    </div>
  );
}

// ── Main Dashboard ────────────────────────────────────────────────────────
export function ParallaxDashboard() {
  const [tab,         setTab]         = useState<DashTab>('STATUS');
  const [status,      setStatus]      = useState<ClearinghouseStatus | null>(null);
  const [rates,       setRates]       = useState<ExchangeRate[]>([]);
  const [exits,       setExits]       = useState<QueuedExit[]>([]);
  const [statusLoad,  setStatusLoad]  = useState(true);
  const [ratesLoad,   setRatesLoad]   = useState(true);
  const [exitsLoad,   setExitsLoad]   = useState(true);
  const [live,        setLive]        = useState(false);
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const fetchStatus = useCallback(async () => {
    try {
      const s = await parallax_getClearinghouseStatus();
      setStatus(s);
      setLive(true);
    } catch { setLive(false); }
    setStatusLoad(false);
  }, []);

  const fetchRates = useCallback(async () => {
    try {
      const r = await parallax_getExchangeRates();
      setRates(r);
    } catch { /* offline */ }
    setRatesLoad(false);
  }, []);

  const fetchExits = useCallback(async () => {
    setExitsLoad(true);
    try {
      const ex = await parallax_getQueuedExits(0, 20);
      setExits(ex);
    } catch { /* offline */ }
    setExitsLoad(false);
  }, []);

  useEffect(() => {
    fetchStatus();
    fetchRates();
    fetchExits();
    // Poll status every 12s
    pollRef.current = setInterval(fetchStatus, 12000);
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, [fetchStatus, fetchRates, fetchExits]);

  const TABS: Array<{ id: DashTab; label: string }> = [
    { id: 'STATUS',   label: '⊙ Status'   },
    { id: 'SEND',     label: '→ Send'     },
    { id: 'RATES',    label: '◈ Rates'    },
    { id: 'EXITS',    label: '↑ Exits'    },
    { id: 'CLAIMS',   label: '◎ Claims'   },
    { id: 'REGISTER', label: '☉ Register' },
  ];

  return (
    <div style={C.root}>
      {/* ── Header ───────────────────────────────────────────────── */}
      <div style={C.header}>
        <div style={C.brand}>⬡ PARALLAX</div>
        {TABS.map(t => (
          <button key={t.id} style={C.tabBtn(tab === t.id)} onClick={() => setTab(t.id)}>
            {t.label}
          </button>
        ))}
        <div style={C.statusDot(live)} />
        <span style={C.statusText(live)}>{live ? 'LIVE' : 'OFFLINE'}</span>
      </div>

      {/* ── Body ─────────────────────────────────────────────────── */}
      {tab === 'STATUS' && (
        <div style={C.body}>
          <StatusPanel status={status} loading={statusLoad} />
          <RatesPanel  rates={rates}   loading={ratesLoad}  />
        </div>
      )}
      {tab === 'SEND' && (
        <div style={{ ...C.fullBody, display: 'grid', gridTemplateColumns: '1fr', gap: 16, maxWidth: 620 }}>
          <SendPanel />
        </div>
      )}
      {tab === 'RATES' && (
        <div style={{ ...C.fullBody, display: 'grid', gap: 16 }}>
          <RatesPanel rates={rates} loading={ratesLoad} />
        </div>
      )}
      {tab === 'EXITS' && (
        <div style={{ ...C.fullBody, display: 'grid', gap: 16 }}>
          <ExitsPanel exits={exits} loading={exitsLoad} onRefresh={fetchExits} />
        </div>
      )}
      {tab === 'CLAIMS' && (
        <div style={{ ...C.fullBody, display: 'grid', gap: 16 }}>
          <ClaimsPanel />
        </div>
      )}
      {tab === 'REGISTER' && (
        <div style={{ ...C.fullBody, display: 'grid', gap: 16, maxWidth: 480 }}>
          <RegisterPanel />
        </div>
      )}
    </div>
  );
}
