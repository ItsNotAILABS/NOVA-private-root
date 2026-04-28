// ═══════════════════════════════════════════════════════════════════════════
// PHANTOM WALLET — Runtime Dashboard
// Language: TypeScript + React (CPL: typed JSX calling Motoko via actor)
// Powered by PARALLAX → phantom_transfer canister (Build №35)
// Medina Tech · 2026
//
// Consumer-facing wallet. No crypto jargon. No internal tokens visible.
// Send. Receive. Done.
// ═══════════════════════════════════════════════════════════════════════════

import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  parallax_getClearinghouseStatus,
  parallax_getExchangeRates,
  parallax_sendRemittance,
  parallax_generateClaimLink,
  parallax_redeemClaimLink,
  type ClearinghouseStatus,
  type ExchangeRate,
} from '../canister/parallaxActor';

// ── Tab type ──────────────────────────────────────────────────────────────
type WalletTab = 'SEND' | 'RECEIVE' | 'STATUS';

// ── Currency options available to consumers ───────────────────────────────
const SEND_CURRENCIES    = ['MXN', 'USD', 'EUR', 'GBP'];
const RECEIVE_CURRENCIES = ['MXN', 'USD', 'EUR'];

// ── Helper: format cents as major currency ────────────────────────────────
const fmt = (cents: number, currency: string) =>
  `${(cents / 100).toLocaleString(undefined, { minimumFractionDigits: 2 })} ${currency}`;

const fmtBig = (n: bigint | undefined) =>
  n !== undefined ? n.toLocaleString() : '—';

// ── Styles ────────────────────────────────────────────────────────────────
const W = {
  root: {
    width:           '100%',
    height:          '100%',
    background:      '#06080f',
    color:           '#f0f4ff',
    fontFamily:      "'Inter', 'Helvetica Neue', Arial, sans-serif",
    display:         'flex',
    flexDirection:   'column' as const,
    overflow:        'hidden',
  },
  header: {
    height:          54,
    background:      '#09111e',
    borderBottom:    '1px solid #1a2a3c',
    display:         'flex',
    alignItems:      'center',
    padding:         '0 20px',
    gap:             8,
    flexShrink:      0,
  },
  brand: {
    fontSize:        15,
    fontWeight:      700,
    color:           '#f0f4ff',
    marginRight:     20,
    letterSpacing:   '-0.01em',
  },
  brandSub: {
    fontSize:        9,
    color:           '#2a5070',
    letterSpacing:   '0.12em',
    textTransform:   'uppercase' as const,
  },
  tab: (active: boolean) => ({
    padding:         '6px 18px',
    fontSize:        12,
    fontWeight:      active ? 600 : 400,
    background:      active ? '#0d2040' : 'transparent',
    color:           active ? '#44aaff' : '#4a7090',
    border:          `1px solid ${active ? '#1a4a7a' : 'transparent'}`,
    borderRadius:    6,
    cursor:          'pointer',
    fontFamily:      "'Inter', 'Helvetica Neue', Arial, sans-serif",
    transition:      'all 0.12s',
  }),
  liveDot: (live: boolean) => ({
    width:    6, height: 6, borderRadius: '50%',
    background: live ? '#22cc44' : '#666',
    marginLeft: 'auto',
    boxShadow:  live ? '0 0 6px #22cc44' : 'none',
  }),
  liveText: (live: boolean) => ({
    fontSize: 9, color: live ? '#22cc44' : '#555', letterSpacing: '0.1em',
  }),
  body: {
    flex:            1,
    overflow:        'auto',
    display:         'flex',
    justifyContent:  'center',
    alignItems:      'flex-start',
    padding:         '32px 20px',
  },
  card: {
    width:           '100%',
    maxWidth:        480,
    background:      '#09111e',
    border:          '1px solid #1a2a3c',
    borderRadius:    14,
    padding:         28,
  },
  cardTitle: {
    fontSize:        18,
    fontWeight:      700,
    color:           '#ffffff',
    marginBottom:    4,
  },
  cardSub: {
    fontSize:        12,
    color:           '#3a6080',
    marginBottom:    24,
  },
  label: {
    fontSize:        11,
    color:           '#4a7090',
    letterSpacing:   '0.08em',
    textTransform:   'uppercase' as const,
    marginBottom:    6,
    display:         'block',
  },
  field: {
    display:         'flex',
    gap:             8,
    marginBottom:    16,
  },
  input: {
    flex:            1,
    background:      '#060d1a',
    border:          '1px solid #1a3050',
    borderRadius:    8,
    padding:         '12px 14px',
    fontSize:        15,
    color:           '#f0f4ff',
    fontFamily:      "'Inter', 'Helvetica Neue', Arial, sans-serif",
    outline:         'none',
    width:           '100%',
  },
  select: {
    background:      '#060d1a',
    border:          '1px solid #1a3050',
    borderRadius:    8,
    padding:         '12px 10px',
    fontSize:        14,
    color:           '#c0d8f0',
    fontFamily:      "'Inter', 'Helvetica Neue', Arial, sans-serif",
    minWidth:        90,
  },
  feePreview: {
    background:      '#060d1a',
    border:          '1px solid #1a2a3c',
    borderRadius:    8,
    padding:         '12px 14px',
    fontSize:        12,
    color:           '#4a7090',
    marginBottom:    20,
    lineHeight:      1.6,
  },
  btnSend: {
    width:           '100%',
    padding:         '16px',
    fontSize:        16,
    fontWeight:      700,
    background:      '#44aaff',
    color:           '#050a14',
    border:          'none',
    borderRadius:    10,
    cursor:          'pointer',
    fontFamily:      "'Inter', 'Helvetica Neue', Arial, sans-serif",
    letterSpacing:   '0.01em',
    transition:      'all 0.15s',
  },
  btnSecondary: {
    width:           '100%',
    padding:         '14px',
    fontSize:        14,
    fontWeight:      500,
    background:      'transparent',
    color:           '#44aaff',
    border:          '1px solid #1a4a7a',
    borderRadius:    10,
    cursor:          'pointer',
    fontFamily:      "'Inter', 'Helvetica Neue', Arial, sans-serif",
    marginTop:       10,
  },
  result: (ok: boolean) => ({
    marginTop:       14,
    padding:         '12px 14px',
    background:      ok ? '#06180a' : '#180606',
    border:          `1px solid ${ok ? '#1a4a20' : '#4a1a1a'}`,
    borderRadius:    8,
    fontSize:        12,
    color:           ok ? '#44cc66' : '#cc4444',
    lineHeight:      1.6,
    wordBreak:       'break-all' as const,
  }),
  divider: {
    borderTop:       '1px solid #0d1a28',
    margin:          '16px 0',
  },
  statusGrid: {
    display:         'grid',
    gridTemplateColumns: '1fr 1fr',
    gap:             10,
    marginBottom:    16,
  },
  statBox: {
    background:      '#060d1a',
    border:          '1px solid #1a2a3c',
    borderRadius:    8,
    padding:         '12px 14px',
  },
  statLabel: {
    fontSize:        9,
    color:           '#2a5070',
    letterSpacing:   '0.1em',
    textTransform:   'uppercase' as const,
    marginBottom:    4,
  },
  statVal: {
    fontSize:        18,
    fontWeight:      700,
    color:           '#44aaff',
  },
  rateRow: {
    display:         'flex',
    justifyContent:  'space-between',
    padding:         '8px 0',
    borderBottom:    '1px solid #0d1a28',
    fontSize:        13,
  },
  spinner: {
    color:           '#2a5070',
    fontSize:        12,
    textAlign:       'center' as const,
    padding:         '24px',
  },
};

// ── Send Panel ────────────────────────────────────────────────────────────
function SendPanel({ rates }: { rates: ExchangeRate[] }) {
  const [amount,      setAmount]      = useState('');
  const [fromCur,     setFromCur]     = useState('MXN');
  const [toPhone,     setToPhone]     = useState('');
  const [toType,      setToType]      = useState<'PHONE' | 'CLABE' | 'CARD'>('PHONE');
  const [note,        setNote]        = useState('');
  const [loading,     setLoading]     = useState(false);
  const [result,      setResult]      = useState<{ ok: boolean; msg: string; extra?: string } | null>(null);

  // Compute fee preview
  const amountNum = parseFloat(amount) || 0;
  const feePct    = 0.0014589803375031546;
  const feeAmt    = amountNum * feePct;
  const net       = amountNum - feeAmt;

  // Find exchange rate
  const toCur = fromCur === 'MXN' ? 'USD' : 'MXN';
  const rate   = rates.find(r => r.currency === fromCur);
  const rateDisplay = rate
    ? `1 ${fromCur} ≈ ${(Number(rate.ratePerCent) / 100 / 100).toFixed(4)} ONESICAN (live)`
    : 'Rates loading…';

  const toRefType = toType === 'PHONE' ? 'PHONE' : toType === 'CLABE' ? 'BANK_SPEI' : 'CARD_VISA';

  const submit = useCallback(async () => {
    setLoading(true);
    setResult(null);
    try {
      const cents = Math.round(amountNum * 100);
      if (!cents || cents <= 0) throw new Error('Enter an amount to send');
      if (!toPhone.trim()) throw new Error(
        toType === 'PHONE' ? 'Enter a phone number' :
        toType === 'CLABE' ? 'Enter a CLABE' : 'Enter a card reference'
      );
      const res = await parallax_sendRemittance(
        fromCur, cents, 'CARD-TOKEN-' + Date.now(),
        toCur,   toPhone.trim(), toRefType,
        note || 'Phantom Wallet transfer'
      );
      const claimPart = res.claimCode ? `\nClaim code: ${res.claimCode}` : '';
      setResult({
        ok:    res.success,
        msg:   res.message,
        extra: res.success
          ? `Sent: ${fmt(Number(res.fiatIn), fromCur)} · Fee: ${(Number(res.fee) / 100).toFixed(4)} · Tx #${res.txId}${claimPart}`
          : '',
      });
    } catch (err: unknown) {
      setResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally {
      setLoading(false);
    }
  }, [amount, fromCur, toCur, toPhone, toType, toRefType, note, amountNum]);

  const placeholder = toType === 'PHONE' ? '+52 123 456 7890' : toType === 'CLABE' ? '18-digit CLABE' : 'Card token ref';

  return (
    <div style={W.card}>
      <div style={W.cardTitle}>Send Money</div>
      <div style={W.cardSub}>Card, bank, or cash → phone, CLABE, or anywhere</div>

      <label style={W.label}>Amount & currency</label>
      <div style={W.field}>
        <input
          style={{ ...W.input, fontSize: 24, fontWeight: 700, flex: 1 }}
          type="number"
          min="0"
          step="0.01"
          placeholder="0.00"
          value={amount}
          onChange={e => setAmount(e.target.value)}
        />
        <select style={W.select} value={fromCur} onChange={e => setFromCur(e.target.value)}>
          {SEND_CURRENCIES.map(c => <option key={c}>{c}</option>)}
        </select>
      </div>

      <label style={W.label}>Send to</label>
      <div style={{ display: 'flex', gap: 8, marginBottom: 10 }}>
        {(['PHONE', 'CLABE', 'CARD'] as const).map(t => (
          <button
            key={t}
            style={{
              padding: '6px 14px', fontSize: 11, borderRadius: 6, cursor: 'pointer',
              background: toType === t ? '#0d2040' : 'transparent',
              color:      toType === t ? '#44aaff' : '#3a6080',
              border:     `1px solid ${toType === t ? '#1a4a7a' : '#1a2a3c'}`,
              fontFamily: "'Inter', Arial, sans-serif",
            }}
            onClick={() => setToType(t)}
          >
            {t === 'PHONE' ? '📱 Phone' : t === 'CLABE' ? '🏦 CLABE' : '💳 Card'}
          </button>
        ))}
      </div>
      <input
        style={{ ...W.input, marginBottom: 16 }}
        placeholder={placeholder}
        value={toPhone}
        onChange={e => setToPhone(e.target.value)}
      />

      <label style={W.label}>Note (optional)</label>
      <input
        style={{ ...W.input, marginBottom: 16 }}
        placeholder="Para mi familia…"
        value={note}
        onChange={e => setNote(e.target.value)}
      />

      {/* Fee preview */}
      {amountNum > 0 && (
        <div style={W.feePreview}>
          <div>Sending: <strong style={{ color: '#c0e0ff' }}>{fmt(amountNum * 100, fromCur)}</strong></div>
          <div>Fee (0.146%): <span style={{ color: '#4a7090' }}>{fmt(feeAmt * 100, fromCur)}</span></div>
          <div>Net settled: <strong style={{ color: '#44aaff' }}>{fmt(net * 100, fromCur)}</strong></div>
          <div style={{ marginTop: 4, color: '#2a5070', fontSize: 10 }}>{rateDisplay}</div>
          {toType === 'PHONE' && <div style={{ marginTop: 4, color: '#2a5070', fontSize: 10 }}>→ Claim link sent to recipient's phone</div>}
          {toType === 'CLABE'  && <div style={{ marginTop: 4, color: '#2a5070', fontSize: 10 }}>→ SPEI transfer to CLABE (instant, 24/7)</div>}
        </div>
      )}

      <button style={W.btnSend} onClick={submit} disabled={loading}>
        {loading ? 'Sending…' : `Send ${fromCur} →`}
      </button>

      {result && (
        <div style={W.result(result.ok)}>
          {result.ok ? '✓ ' : '✗ '}{result.msg}
          {result.extra && <div style={{ marginTop: 6, color: '#6090a0' }}>{result.extra}</div>}
        </div>
      )}

      <div style={{ marginTop: 16, fontSize: 10, color: '#1a3050', textAlign: 'center' as const }}>
        Powered by PARALLAX · φ⁻⁴ = 0.146% · phantom_transfer canister
      </div>
    </div>
  );
}

// ── Receive / Claim Panel ─────────────────────────────────────────────────
function ReceivePanel({ rates }: { rates: ExchangeRate[] }) {
  // Generate a claim link for yourself
  const [genAmount,  setGenAmount]  = useState('');
  const [genCur,     setGenCur]     = useState('MXN');
  const [genNote,    setGenNote]    = useState('');
  const [genLoading, setGenLoading] = useState(false);
  const [genResult,  setGenResult]  = useState<{ ok: boolean; msg: string; code?: string } | null>(null);

  // Redeem a claim link
  const [code,         setCode]         = useState('');
  const [redeemMethod, setRedeemMethod] = useState<'CLABE' | 'PHONE' | 'CARD'>('CLABE');
  const [redeemRef,    setRedeemRef]    = useState('');
  const [redLoading,   setRedLoading]   = useState(false);
  const [redResult,    setRedResult]    = useState<{ ok: boolean; msg: string } | null>(null);

  const generate = useCallback(async () => {
    setGenLoading(true);
    setGenResult(null);
    try {
      const cents = Math.round(parseFloat(genAmount) * 100);
      if (!cents || cents <= 0) throw new Error('Enter an amount');
      const rm = redeemMethod === 'CLABE' ? 'BANK_SPEI' : redeemMethod === 'PHONE' ? 'PHONE' : 'CARD_VISA';
      const res = await parallax_generateClaimLink(cents, genCur, rm, genNote || 'Phantom Wallet claim');
      setGenResult({ ok: res.success, msg: res.message, code: res.claimCode || undefined });
    } catch (err: unknown) {
      setGenResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally {
      setGenLoading(false);
    }
  }, [genAmount, genCur, genNote, redeemMethod]);

  const redeem = useCallback(async () => {
    setRedLoading(true);
    setRedResult(null);
    try {
      if (!code.trim()) throw new Error('Enter the claim code');
      if (!redeemRef.trim()) throw new Error('Enter your CLABE / phone / card reference');
      const rm = redeemMethod === 'CLABE' ? 'BANK_SPEI' : redeemMethod === 'PHONE' ? 'PHONE' : 'CARD_VISA';
      const res = await parallax_redeemClaimLink(code.trim(), rm, redeemRef.trim());
      setRedResult({ ok: res.success, msg: res.message });
    } catch (err: unknown) {
      setRedResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally {
      setRedLoading(false);
    }
  }, [code, redeemMethod, redeemRef]);

  return (
    <div style={W.card}>
      {/* Generate */}
      <div style={W.cardTitle}>Receive Money</div>
      <div style={W.cardSub}>Create a claim link — or redeem one you received</div>

      <div style={{ ...W.divider, borderTop: '1px solid #44aaff44', marginTop: 0, marginBottom: 16, padding: '6px 0' }}>
        <span style={{ fontSize: 11, color: '#44aaff', letterSpacing: '0.1em', textTransform: 'uppercase' as const }}>Create a Claim Link</span>
      </div>

      <label style={W.label}>Amount</label>
      <div style={W.field}>
        <input
          style={{ ...W.input, fontSize: 20, fontWeight: 700, flex: 1 }}
          type="number"
          min="0"
          step="0.01"
          placeholder="0.00"
          value={genAmount}
          onChange={e => setGenAmount(e.target.value)}
        />
        <select style={W.select} value={genCur} onChange={e => setGenCur(e.target.value)}>
          {RECEIVE_CURRENCIES.map(c => <option key={c}>{c}</option>)}
        </select>
      </div>

      <label style={W.label}>They'll redeem via</label>
      <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
        {(['CLABE', 'PHONE', 'CARD'] as const).map(t => (
          <button
            key={t}
            style={{
              padding: '6px 14px', fontSize: 11, borderRadius: 6, cursor: 'pointer',
              background: redeemMethod === t ? '#0d2040' : 'transparent',
              color:      redeemMethod === t ? '#44aaff' : '#3a6080',
              border:     `1px solid ${redeemMethod === t ? '#1a4a7a' : '#1a2a3c'}`,
              fontFamily: "'Inter', Arial, sans-serif",
            }}
            onClick={() => setRedeemMethod(t)}
          >
            {t === 'CLABE' ? '🏦 CLABE' : t === 'PHONE' ? '📱 Phone' : '💳 Card'}
          </button>
        ))}
      </div>

      <label style={W.label}>Note (optional)</label>
      <input
        style={{ ...W.input, marginBottom: 16 }}
        placeholder="What's this for?"
        value={genNote}
        onChange={e => setGenNote(e.target.value)}
      />

      <button style={W.btnSend} onClick={generate} disabled={genLoading}>
        {genLoading ? 'Generating…' : 'Generate Claim Link'}
      </button>

      {genResult && (
        <div style={W.result(genResult.ok)}>
          {genResult.ok ? '✓ ' : '✗ '}{genResult.msg}
          {genResult.code && (
            <div style={{ marginTop: 8, background: '#060d1a', border: '1px solid #1a4a7a', borderRadius: 6, padding: '8px 12px', fontFamily: 'monospace', fontSize: 13, color: '#44aaff', letterSpacing: '0.05em' }}>
              {genResult.code}
            </div>
          )}
        </div>
      )}

      <div style={W.divider} />

      {/* Redeem */}
      <div style={{ ...W.divider, borderTop: '1px solid #44aaff44', marginTop: 0, marginBottom: 16, padding: '6px 0' }}>
        <span style={{ fontSize: 11, color: '#44aaff', letterSpacing: '0.1em', textTransform: 'uppercase' as const }}>Redeem a Claim Link</span>
      </div>

      <label style={W.label}>Claim code</label>
      <input
        style={{ ...W.input, marginBottom: 16, fontFamily: 'monospace', letterSpacing: '0.04em' }}
        placeholder="NOVA-CLM-1-MXN-…"
        value={code}
        onChange={e => setCode(e.target.value)}
      />

      <label style={W.label}>Receive to</label>
      <input
        style={{ ...W.input, marginBottom: 16 }}
        placeholder={redeemMethod === 'CLABE' ? '18-digit CLABE' : redeemMethod === 'PHONE' ? '+52 123 456 7890' : 'Card token'}
        value={redeemRef}
        onChange={e => setRedeemRef(e.target.value)}
      />

      <button style={W.btnSecondary} onClick={redeem} disabled={redLoading}>
        {redLoading ? 'Redeeming…' : 'Redeem Claim Link →'}
      </button>

      {redResult && (
        <div style={W.result(redResult.ok)}>
          {redResult.ok ? '✓ ' : '✗ '}{redResult.msg}
        </div>
      )}
    </div>
  );
}

// ── Status Panel ───────────────────────────────────────────────────────────
function StatusPanel({ status, rates, loading }: {
  status: ClearinghouseStatus | null;
  rates:  ExchangeRate[];
  loading: boolean;
}) {
  if (loading) return <div style={{ ...W.card, textAlign: 'center' as const }}><div style={W.spinner}>Loading clearinghouse…</div></div>;

  return (
    <div style={W.card}>
      <div style={W.cardTitle}>Live Status</div>
      <div style={W.cardSub}>PARALLAX clearinghouse — real-time snapshot</div>

      {status && (
        <div style={W.statusGrid}>
          {[
            ['Remittances sent',  fmtBig(status.totalRemittances)],
            ['Claims generated',  fmtBig(status.claimsGenerated)],
            ['Claims redeemed',   fmtBig(status.claimsRedeemed)],
            ['Exits delivered',   fmtBig(status.exitsDelivered)],
            ['Registered users',  fmtBig(status.registeredUsers)],
            ['Build №',           status.buildNumber.toString()],
          ].map(([l, v]) => (
            <div key={l} style={W.statBox}>
              <div style={W.statLabel}>{l}</div>
              <div style={W.statVal}>{v}</div>
            </div>
          ))}
        </div>
      )}

      {!status && (
        <div style={{ color: '#3a6080', fontSize: 12, marginBottom: 16 }}>
          Canister offline — check your connection or dfx deployment.
        </div>
      )}

      <div style={W.divider} />
      <div style={{ fontSize: 11, color: '#44aaff', letterSpacing: '0.1em', textTransform: 'uppercase' as const, marginBottom: 10 }}>
        Live Exchange Rates
      </div>
      {rates.length === 0 && <div style={{ color: '#3a6080', fontSize: 12 }}>Rates loading…</div>}
      {rates.map(r => (
        <div key={r.currency} style={W.rateRow}>
          <span style={{ color: '#8ab0d0', fontWeight: 600 }}>{r.currency}</span>
          <span style={{ color: '#4a7090' }}>{r.ratePerCent.toString()} ONESICAN / 100¢</span>
        </div>
      ))}

      <div style={{ marginTop: 16, fontSize: 10, color: '#1a3050', textAlign: 'center' as const }}>
        Powered by PARALLAX · phantom_transfer Build #{status?.buildNumber.toString() ?? '35'}<br />
        Rates update from oracle network · φ⁻⁴ = 0.14589803375031546%
      </div>
    </div>
  );
}

// ── Main Wallet Dashboard ─────────────────────────────────────────────────
export function PhantomWalletDashboard() {
  const [tab,         setTab]         = useState<WalletTab>('SEND');
  const [status,      setStatus]      = useState<ClearinghouseStatus | null>(null);
  const [rates,       setRates]       = useState<ExchangeRate[]>([]);
  const [statusLoad,  setStatusLoad]  = useState(true);
  const [live,        setLive]        = useState(false);
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const fetchAll = useCallback(async () => {
    try {
      const [s, r] = await Promise.all([
        parallax_getClearinghouseStatus(),
        parallax_getExchangeRates(),
      ]);
      setStatus(s);
      setRates(r);
      setLive(true);
    } catch {
      setLive(false);
    }
    setStatusLoad(false);
  }, []);

  useEffect(() => {
    fetchAll();
    pollRef.current = setInterval(fetchAll, 15000);
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, [fetchAll]);

  return (
    <div style={W.root}>
      {/* ── Header ───────────────────────────────────────────────── */}
      <div style={W.header}>
        <div>
          <div style={W.brand}>⬡ Phantom Wallet</div>
          <div style={W.brandSub}>Powered by PARALLAX</div>
        </div>
        {(['SEND', 'RECEIVE', 'STATUS'] as WalletTab[]).map(t => (
          <button key={t} style={W.tab(tab === t)} onClick={() => setTab(t)}>
            {t === 'SEND' ? '→ Send' : t === 'RECEIVE' ? '← Receive' : '⊙ Status'}
          </button>
        ))}
        <div style={W.liveDot(live)} />
        <span style={W.liveText(live)}>{live ? 'LIVE' : 'OFFLINE'}</span>
      </div>

      {/* ── Body ─────────────────────────────────────────────────── */}
      <div style={W.body}>
        {tab === 'SEND'    && <SendPanel    rates={rates} />}
        {tab === 'RECEIVE' && <ReceivePanel rates={rates} />}
        {tab === 'STATUS'  && <StatusPanel  status={status} rates={rates} loading={statusLoad} />}
      </div>
    </div>
  );
}
