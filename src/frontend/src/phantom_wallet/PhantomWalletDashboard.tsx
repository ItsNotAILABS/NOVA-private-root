// ═══════════════════════════════════════════════════════════════════════════
// PHANTOM WALLET — Runtime Dashboard  (Build №40)
// Language: TypeScript + React (CPL: typed JSX calling Motoko via actor)
// Powered by PARALLAX → phantom_transfer canister (Build №35)
// Medina Tech · 2026
//
// Three rails visible to the user:
//   FIAT    — any fiat currency worldwide (USD/MXN/EUR/GBP/JPY/BRL)
//   CRYPTO  — BTC/ETH/SOL/ICP/MATIC → converted via ONESICAN bridge → any exit
//   PHANTOM — stealth claim link (commitment-reveal, recipient redeems anywhere)
//
// The user never sees ONESICAN, CHR, GOL, or any NOVA internal.
// PARALLAX routes it. You do nothing.
// ═══════════════════════════════════════════════════════════════════════════

import React, { useCallback, useEffect, useRef, useState } from 'react';
import { verifyProtocol } from '../parallax/sovereign-protocol';
import {
  parallax_getClearinghouseStatus,
  parallax_getExchangeRates,
  parallax_sendRemittance,
  parallax_generateClaimLink,
  parallax_redeemClaimLink,
  type ClearinghouseStatus,
  type ExchangeRate,
} from '../canister/parallaxActor';

// ── Fee constants — mirror phantom_transfer canister ─────────────────────
// Must stay in sync with _computeFee in src/phantom_transfer/main.mo.
// Future: fetch from canister's getFeeRate() query if rates become dynamic.
const PHI     = 1.6180339887498948482;
const PHI_INV4_FEE = 1 / (PHI ** 4); // φ⁻⁴ = 0.14589...% — FIAT / CRYPTO rail
const PHI_INV3_FEE = 1 / (PHI ** 3); // φ⁻³ = 0.23606...% — PHANTOM rail (stealth premium)

// ── Crypto spot prices (client-side fallback; canister oracle is authoritative) ─
// These are display-only approximations for fee preview.
// The actual settlement rate comes from the PARALLAX oracle registered in the canister.
const CRYPTO_USD: Record<string, number> = {
  BTC: 67000, ETH: 3500, SOL: 155, ICP: 13, MATIC: 0.72,
};

// ── Tab / mode types ──────────────────────────────────────────────────────
type WalletTab  = 'SEND' | 'RECEIVE' | 'STATUS';
type SendMode   = 'FIAT' | 'CRYPTO' | 'PHANTOM';

// ── Currency options ──────────────────────────────────────────────────────
const FIAT_CURRENCIES   = ['USD', 'MXN', 'EUR', 'GBP', 'JPY', 'BRL'];
const CRYPTO_ASSETS     = ['BTC', 'ETH', 'SOL', 'ICP', 'MATIC'];
const RECEIVE_CURRENCIES = ['USD', 'MXN', 'EUR', 'GBP', 'JPY', 'BRL'];

// ── Helpers ───────────────────────────────────────────────────────────────
const fmt = (cents: number, currency: string) =>
  `${(cents / 100).toLocaleString(undefined, { minimumFractionDigits: 2 })} ${currency}`;
const fmtBig = (n: bigint | undefined) =>
  n !== undefined ? n.toLocaleString() : '—';

// Crypto amount display
const fmtCrypto = (amount: number, asset: string) => {
  const decimals = asset === 'BTC' ? 6 : asset === 'ETH' ? 5 : 2;
  return `${amount.toFixed(decimals)} ${asset}`;
};

// Generate a simple client-side commitment hash for PHANTOM transfers
// (The canister verifies with its own logic — this is the user-visible "seal")
const phantomCommitment = (amount: number, currency: string, nonce: string) => {
  const raw = `NOVA:${amount}:${currency}:${nonce}:${Date.now()}`;
  return 'PHCM-' + btoa(raw).replace(/=/g, '').slice(0, 24).toUpperCase();
};

// ── Styles ────────────────────────────────────────────────────────────────
const W = {
  root: {
    width: '100%', height: '100%',
    background: '#06080f', color: '#f0f4ff',
    fontFamily: "'Inter', 'Helvetica Neue', Arial, sans-serif",
    display: 'flex', flexDirection: 'column' as const, overflow: 'hidden',
  },
  header: {
    height: 54, background: '#09111e',
    borderBottom: '1px solid #1a2a3c',
    display: 'flex', alignItems: 'center', padding: '0 20px', gap: 8, flexShrink: 0,
  },
  brand: { fontSize: 15, fontWeight: 700, color: '#f0f4ff', marginRight: 20, letterSpacing: '-0.01em' },
  brandSub: { fontSize: 9, color: '#2a5070', letterSpacing: '0.12em', textTransform: 'uppercase' as const },
  tab: (active: boolean) => ({
    padding: '6px 18px', fontSize: 12,
    fontWeight: active ? 600 : 400,
    background: active ? '#0d2040' : 'transparent',
    color: active ? '#44aaff' : '#3a6080',
    border: `1px solid ${active ? '#1a4a7a' : 'transparent'}`,
    borderRadius: 6, cursor: 'pointer', fontFamily: "'Inter', Arial, sans-serif",
  }),
  liveDot: (live: boolean) => ({
    width: 7, height: 7, borderRadius: '50%',
    background: live ? '#44ff88' : '#ff4444',
    marginLeft: 'auto',
  }),
  liveText: (live: boolean) => ({
    fontSize: 9, letterSpacing: '0.12em',
    color: live ? '#44ff88' : '#ff4444',
    textTransform: 'uppercase' as const,
  }),
  body: {
    flex: 1, overflowY: 'auto' as const,
    padding: '24px', display: 'flex',
    flexDirection: 'column' as const, alignItems: 'center',
  },
  card: {
    width: '100%', maxWidth: 540,
    background: '#090f1a',
    border: '1px solid #1a2a3c',
    borderRadius: 12, padding: '24px',
    marginBottom: 16,
  },
  cardTitle: { fontSize: 18, fontWeight: 700, marginBottom: 4, letterSpacing: '-0.02em' },
  cardSub: { fontSize: 12, color: '#3a6080', marginBottom: 20, lineHeight: 1.4 },

  // Mode selector
  modeRow: { display: 'flex', gap: 8, marginBottom: 20 },
  modeBtn: (active: boolean, color: string) => ({
    flex: 1, padding: '10px 8px', fontSize: 12, fontWeight: active ? 700 : 400,
    background: active ? `${color}22` : 'transparent',
    color: active ? color : '#3a6080',
    border: `1px solid ${active ? color + '66' : '#1a2a3c'}`,
    borderRadius: 8, cursor: 'pointer', fontFamily: "'Inter', Arial, sans-serif",
    textAlign: 'center' as const, transition: 'all 0.15s',
  }),

  // Route indicator
  routeBar: (color: string) => ({
    background: `${color}11`, border: `1px solid ${color}33`,
    borderRadius: 8, padding: '10px 14px', marginBottom: 16,
    fontSize: 11, color, lineHeight: 1.6, fontFamily: 'monospace',
    letterSpacing: '0.01em',
  }),

  label: { fontSize: 11, color: '#3a6080', letterSpacing: '0.08em', textTransform: 'uppercase' as const, marginBottom: 6, display: 'block' },
  field: { display: 'flex', gap: 8, marginBottom: 12 },
  input: {
    flex: 1, background: '#060d1a', border: '1px solid #1a2a3c',
    borderRadius: 8, padding: '10px 14px', color: '#f0f4ff', fontSize: 15,
    fontFamily: "'Inter', Arial, sans-serif", outline: 'none',
    width: '100%', boxSizing: 'border-box' as const,
  },
  select: {
    background: '#060d1a', border: '1px solid #1a2a3c', borderRadius: 8,
    padding: '10px 10px', color: '#f0f4ff', fontSize: 13,
    fontFamily: "'Inter', Arial, sans-serif", cursor: 'pointer',
  },
  typeRow: { display: 'flex', gap: 8, marginBottom: 12 },
  typeBtn: (active: boolean) => ({
    padding: '6px 12px', fontSize: 11, borderRadius: 6, cursor: 'pointer',
    background: active ? '#0d2040' : 'transparent',
    color: active ? '#44aaff' : '#3a6080',
    border: `1px solid ${active ? '#1a4a7a' : '#1a2a3c'}`,
    fontFamily: "'Inter', Arial, sans-serif",
  }),

  feePreview: {
    background: '#060d1a', border: '1px solid #1a3050',
    borderRadius: 8, padding: '12px 14px', marginBottom: 16,
    fontSize: 12, lineHeight: 1.8, color: '#4a7090',
  },
  btnSend: {
    width: '100%', padding: '13px', fontSize: 14, fontWeight: 700,
    background: '#1060c0', color: '#f0f4ff', border: '1px solid #2080e0',
    borderRadius: 10, cursor: 'pointer', fontFamily: "'Inter', Arial, sans-serif",
    marginBottom: 12,
  },
  btnSecondary: {
    width: '100%', padding: '13px', fontSize: 14, fontWeight: 600,
    background: 'transparent', color: '#44aaff', border: '1px solid #1a4a7a',
    borderRadius: 10, cursor: 'pointer', fontFamily: "'Inter', Arial, sans-serif",
    marginBottom: 12,
  },
  btnPhantom: {
    width: '100%', padding: '13px', fontSize: 14, fontWeight: 700,
    background: '#1a0a2a', color: '#b844ff', border: '1px solid #6622aa',
    borderRadius: 10, cursor: 'pointer', fontFamily: "'Inter', Arial, sans-serif",
    marginBottom: 12,
  },
  result: (ok: boolean) => ({
    padding: '12px 14px', borderRadius: 8, fontSize: 12, lineHeight: 1.6,
    background: ok ? '#061a0f' : '#1a0606',
    border: `1px solid ${ok ? '#1a5030' : '#5a1a1a'}`,
    color: ok ? '#44cc88' : '#cc4444', marginBottom: 8,
  }),
  commitment: {
    background: '#0a0618', border: '1px solid #6622aa44',
    borderRadius: 8, padding: '12px 14px', fontFamily: 'monospace',
    fontSize: 12, color: '#b844ff', letterSpacing: '0.05em',
    wordBreak: 'break-all' as const, marginBottom: 12,
  },
  divider: { borderTop: '1px solid #0f1a2a', margin: '20px 0' },
  statusGrid: {
    display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)',
    gap: 10, marginBottom: 20,
  },
  statBox: {
    background: '#060d1a', border: '1px solid #1a2a3c',
    borderRadius: 8, padding: '10px 12px',
  },
  statLabel: { fontSize: 9, color: '#2a5070', letterSpacing: '0.08em', textTransform: 'uppercase' as const, marginBottom: 3 },
  statVal:   { fontSize: 16, fontWeight: 700, color: '#44aaff' },
  rateRow: {
    display: 'flex', justifyContent: 'space-between' as const,
    padding: '6px 0', borderBottom: '1px solid #0f1a2a', fontSize: 12,
  },
  spinner: { color: '#2a5070', fontSize: 12, textAlign: 'center' as const, padding: '24px' },
};

// ── Routing description for each mode ────────────────────────────────────
const ROUTE_LABEL: Record<SendMode, { text: string; color: string }> = {
  FIAT:    { color: '#44aaff', text: 'Route: EDGE GATE → ONESICAN bridge → fiat exit rail → recipient bank/phone. Fee: φ⁻⁴ (0.146%).' },
  CRYPTO:  { color: '#88cc44', text: 'Route: Crypto amount → USD equiv → ONESICAN bridge → any fiat/crypto exit. Fee: φ⁻⁴ (0.146%). PARALLAX is the bridge — no custodian.' },
  PHANTOM: { color: '#b844ff', text: 'Route: Commitment hash sealed → ONESICAN shielded hold → recipient reveals preimage to claim. Fee: φ⁻³ (0.236%). Stealth premium.' },
};

// ═══════════════════════════════════════════════════════════════════════════
// SEND PANEL — three modes in one
// ═══════════════════════════════════════════════════════════════════════════
function SendPanel({ rates }: { rates: ExchangeRate[] }) {
  const [mode,        setMode]        = useState<SendMode>('FIAT');

  // FIAT mode
  const [fiatAmount,  setFiatAmount]  = useState('');
  const [fiatFrom,    setFiatFrom]    = useState('USD');
  const [fiatTo,      setFiatTo]      = useState('MXN');
  const [fiatRecip,   setFiatRecip]   = useState('');
  const [fiatRefType, setFiatRefType] = useState<'PHONE' | 'CLABE' | 'IBAN' | 'CARD'>('PHONE');
  const [fiatNote,    setFiatNote]    = useState('');

  // CRYPTO mode
  const [cryptoAmt,   setCryptoAmt]   = useState('');
  const [cryptoAsset, setCryptoAsset] = useState('ETH');
  const [cryptoRecip, setCryptoRecip] = useState('');
  const [cryptoRef,   setCryptoRef]   = useState<'PHONE' | 'CLABE' | 'IBAN' | 'CARD'>('PHONE');
  const [cryptoNote,  setCryptoNote]  = useState('');

  // PHANTOM mode
  const [phaAmount,   setPhaAmount]   = useState('');
  const [phaCur,      setPhaCur]      = useState('USD');
  const [phaNote,     setPhaNote]     = useState('');
  const [phaCommit,   setPhaCommit]   = useState('');

  const [loading,     setLoading]     = useState(false);
  const [result,      setResult]      = useState<{ ok: boolean; msg: string; extra?: string } | null>(null);

  // ── Fee previews ──────────────────────────────────────────────────────
  const fiatNum   = parseFloat(fiatAmount) || 0;
  const fiatFee   = fiatNum * PHI_INV4_FEE;
  const fiatNet   = fiatNum - fiatFee;
  const fiatRate  = rates.find(r => r.currency === fiatFrom);

  const cryptoNum  = parseFloat(cryptoAmt) || 0;
  const cryptoUSD  = cryptoNum * (CRYPTO_USD[cryptoAsset] ?? 1);
  const cryptoFee  = cryptoUSD * PHI_INV4_FEE;
  const cryptoNet  = cryptoUSD - cryptoFee;

  const phaNum    = parseFloat(phaAmount) || 0;
  const phaFee    = phaNum * PHI_INV3_FEE;

  // ── Submit handlers ───────────────────────────────────────────────────
  const submitFiat = useCallback(async () => {
    setLoading(true); setResult(null);
    try {
      const cents = Math.round(fiatNum * 100);
      if (!cents || cents <= 0) throw new Error('Enter an amount to send');
      if (!fiatRecip.trim()) throw new Error('Enter a destination');
      const toRefType = fiatRefType === 'PHONE' ? 'PHONE' : fiatRefType === 'CLABE' ? 'BANK_SPEI' : fiatRefType === 'IBAN' ? 'BANK_SEPA' : 'CARD_VISA';
      const res = await parallax_sendRemittance(
        fiatFrom, cents, 'CARD-TOKEN-' + Date.now(),
        fiatTo, fiatRecip.trim(), toRefType,
        fiatNote || 'Phantom Wallet — FIAT transfer'
      );
      const claimPart = res.claimCode ? `\nClaim code: ${res.claimCode}` : '';
      setResult({
        ok:    res.success,
        msg:   res.message,
        extra: res.success
          ? `Sent: ${fmt(Number(res.fiatIn), fiatFrom)} · Fee: ${(Number(res.fee) / 100).toFixed(4)} · Tx #${res.txId}${claimPart}`
          : '',
      });
    } catch (err: unknown) {
      setResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally { setLoading(false); }
  }, [fiatNum, fiatFrom, fiatTo, fiatRecip, fiatRefType, fiatNote]);

  const submitCrypto = useCallback(async () => {
    setLoading(true); setResult(null);
    try {
      if (!cryptoNum || cryptoNum <= 0) throw new Error('Enter an amount');
      if (!cryptoRecip.trim()) throw new Error('Enter a destination');
      // Convert crypto → USD cents → sendRemittance on FIAT rail
      // PARALLAX routes the USD through ONESICAN and out the target rail.
      const usdCents = Math.round(cryptoUSD * 100);
      if (usdCents <= 0) throw new Error('Crypto amount too small');
      const toRefType = cryptoRef === 'PHONE' ? 'PHONE' : cryptoRef === 'CLABE' ? 'BANK_SPEI' : cryptoRef === 'IBAN' ? 'BANK_SEPA' : 'CARD_VISA';
      const res = await parallax_sendRemittance(
        'USD', usdCents, 'CRYPTO-' + cryptoAsset + '-' + Date.now(),
        fiatTo, cryptoRecip.trim(), toRefType,
        cryptoNote || `Phantom Wallet — ${cryptoAsset} bridge transfer`
      );
      setResult({
        ok:    res.success,
        msg:   res.message,
        extra: res.success
          ? `${fmtCrypto(cryptoNum, cryptoAsset)} ≈ $${cryptoUSD.toFixed(2)} USD · Fee $${(cryptoUSD * PHI_INV4_FEE).toFixed(4)} · Tx #${res.txId}`
          : '',
      });
    } catch (err: unknown) {
      setResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally { setLoading(false); }
  }, [cryptoNum, cryptoAsset, cryptoUSD, cryptoRecip, cryptoRef, cryptoNote, fiatTo]);

  const submitPhantom = useCallback(async () => {
    setLoading(true); setResult(null);
    try {
      const cents = Math.round(phaNum * 100);
      if (!cents || cents <= 0) throw new Error('Enter an amount');
      // Generate a client-side commitment hash (displayed to sender as the "seal")
      const nonce  = Math.random().toString(36).slice(2, 10).toUpperCase();
      const commit = phantomCommitment(phaNum, phaCur, nonce);
      setPhaCommit(commit);
      // Use claim link as the PHANTOM rail consumer mechanism:
      // The claim code IS the commitment-reveal — recipient redeems when ready.
      const res = await parallax_generateClaimLink(
        cents, phaCur, 'PHONE',
        (phaNote || 'PHANTOM stealth transfer') + ' | seal=' + commit
      );
      setResult({
        ok:    res.success,
        msg:   res.message,
        extra: res.success ? `Claim code: ${res.claimCode} · Seal: ${commit}` : '',
      });
    } catch (err: unknown) {
      setResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally { setLoading(false); }
  }, [phaNum, phaCur, phaNote]);

  const route = ROUTE_LABEL[mode];

  return (
    <div style={W.card}>
      <div style={W.cardTitle}>Send</div>
      <div style={W.cardSub}>Any asset · Any currency · Any country — PARALLAX routes it invisibly</div>

      {/* Mode selector */}
      <div style={W.modeRow}>
        {([['FIAT', '💱 Fiat', '#44aaff'], ['CRYPTO', '₿ Crypto', '#88cc44'], ['PHANTOM', '👻 Phantom', '#b844ff']] as [SendMode, string, string][]).map(([m, label, color]) => (
          <button key={m} style={W.modeBtn(mode === m, color)} onClick={() => { setMode(m); setResult(null); }}>
            {label}
          </button>
        ))}
      </div>

      {/* Routing indicator */}
      <div style={W.routeBar(route.color)}>{route.text}</div>

      {/* ── FIAT mode ─────────────────────────────────────────────── */}
      {mode === 'FIAT' && (
        <>
          <label style={W.label}>Amount</label>
          <div style={W.field}>
            <input
              style={{ ...W.input, fontSize: 24, fontWeight: 700, flex: 1 }}
              type="number" min="0" step="0.01" placeholder="0.00"
              value={fiatAmount} onChange={e => setFiatAmount(e.target.value)}
            />
            <select style={W.select} value={fiatFrom} onChange={e => setFiatFrom(e.target.value)}>
              {FIAT_CURRENCIES.map(c => <option key={c}>{c}</option>)}
            </select>
          </div>
          <label style={W.label}>They receive in</label>
          <select style={{ ...W.select, width: '100%', marginBottom: 12 }} value={fiatTo} onChange={e => setFiatTo(e.target.value)}>
            {FIAT_CURRENCIES.map(c => <option key={c}>{c}</option>)}
          </select>
          <label style={W.label}>Destination</label>
          <div style={W.typeRow}>
            {(['PHONE', 'CLABE', 'IBAN', 'CARD'] as const).map(t => (
              <button key={t} style={W.typeBtn(fiatRefType === t)} onClick={() => setFiatRefType(t)}>
                {t === 'PHONE' ? '📱' : t === 'CLABE' ? '🏦' : t === 'IBAN' ? '🌍' : '💳'}
              </button>
            ))}
          </div>
          <input
            style={{ ...W.input, marginBottom: 12 }}
            placeholder={fiatRefType === 'PHONE' ? '+1 / +52 / +44 …' : fiatRefType === 'CLABE' ? '18-digit CLABE' : fiatRefType === 'IBAN' ? 'IBAN (EU/UK)' : 'Card token ref'}
            value={fiatRecip} onChange={e => setFiatRecip(e.target.value)}
          />
          <input style={{ ...W.input, marginBottom: 16 }} placeholder="Note (optional)" value={fiatNote} onChange={e => setFiatNote(e.target.value)} />
          {fiatNum > 0 && (
            <div style={W.feePreview}>
              <div>Sending: <strong style={{ color: '#c0e0ff' }}>{fmt(fiatNum * 100, fiatFrom)}</strong></div>
              <div>Fee φ⁻⁴ (0.146%): <span style={{ color: '#4a7090' }}>{fmt(fiatFee * 100, fiatFrom)}</span></div>
              <div>Settled: <strong style={{ color: '#44aaff' }}>{fmt(fiatNet * 100, fiatFrom)}</strong> → {fiatTo}</div>
              {fiatRate && <div style={{ color: '#2a5070', fontSize: 10, marginTop: 4 }}>1 {fiatFrom} ≈ {(Number(fiatRate.ratePerCent) / 100 / 100).toFixed(4)} ONESICAN (oracle)</div>}
            </div>
          )}
          <button style={W.btnSend} onClick={submitFiat} disabled={loading}>
            {loading ? 'PARALLAX routing…' : `Send ${fiatFrom} → ${fiatTo}`}
          </button>
        </>
      )}

      {/* ── CRYPTO mode ───────────────────────────────────────────── */}
      {mode === 'CRYPTO' && (
        <>
          <label style={W.label}>Crypto amount</label>
          <div style={W.field}>
            <input
              style={{ ...W.input, fontSize: 22, fontWeight: 700, flex: 1 }}
              type="number" min="0" step="any" placeholder="0.00"
              value={cryptoAmt} onChange={e => setCryptoAmt(e.target.value)}
            />
            <select style={W.select} value={cryptoAsset} onChange={e => setCryptoAsset(e.target.value)}>
              {CRYPTO_ASSETS.map(a => <option key={a}>{a}</option>)}
            </select>
          </div>
          <label style={W.label}>Recipient receives in</label>
          <select style={{ ...W.select, width: '100%', marginBottom: 12 }} value={fiatTo} onChange={e => setFiatTo(e.target.value)}>
            {FIAT_CURRENCIES.map(c => <option key={c}>{c}</option>)}
          </select>
          <label style={W.label}>Destination</label>
          <div style={W.typeRow}>
            {(['PHONE', 'CLABE', 'IBAN', 'CARD'] as const).map(t => (
              <button key={t} style={W.typeBtn(cryptoRef === t)} onClick={() => setCryptoRef(t)}>
                {t === 'PHONE' ? '📱' : t === 'CLABE' ? '🏦' : t === 'IBAN' ? '🌍' : '💳'}
              </button>
            ))}
          </div>
          <input
            style={{ ...W.input, marginBottom: 12 }}
            placeholder={cryptoRef === 'PHONE' ? '+1 / +52 / +44 …' : cryptoRef === 'CLABE' ? '18-digit CLABE' : cryptoRef === 'IBAN' ? 'IBAN (EU/UK)' : 'Card token ref'}
            value={cryptoRecip} onChange={e => setCryptoRecip(e.target.value)}
          />
          <input style={{ ...W.input, marginBottom: 16 }} placeholder="Note (optional)" value={cryptoNote} onChange={e => setCryptoNote(e.target.value)} />
          {cryptoNum > 0 && (
            <div style={W.feePreview}>
              <div>Sending: <strong style={{ color: '#c0f0c0' }}>{fmtCrypto(cryptoNum, cryptoAsset)}</strong></div>
              <div style={{ color: '#5080a0' }}>≈ USD ${cryptoUSD.toLocaleString(undefined, { minimumFractionDigits: 2 })} (display rate)</div>
              <div>Fee φ⁻⁴ (0.146%): <span style={{ color: '#4a7090' }}>${cryptoFee.toFixed(4)}</span></div>
              <div>Bridge net: <strong style={{ color: '#88cc44' }}>${cryptoNet.toLocaleString(undefined, { minimumFractionDigits: 2 })}</strong> → {fiatTo}</div>
              <div style={{ color: '#2a5070', fontSize: 10, marginTop: 4 }}>PARALLAX routes {cryptoAsset} through ONESICAN → fiat exit. No custodian.</div>
            </div>
          )}
          <button style={{ ...W.btnSend, background: '#0a2010', border: '1px solid #2a6020', color: '#88cc44' }} onClick={submitCrypto} disabled={loading}>
            {loading ? 'PARALLAX bridging…' : `Bridge ${cryptoAsset} → ${fiatTo}`}
          </button>
        </>
      )}

      {/* ── PHANTOM mode ──────────────────────────────────────────── */}
      {mode === 'PHANTOM' && (
        <>
          <div style={{ background: '#0f0520', border: '1px solid #6622aa33', borderRadius: 8, padding: '12px 14px', marginBottom: 16, fontSize: 12, color: '#9060cc', lineHeight: 1.6 }}>
            👻 Stealth transfer. Recipient gets a claim code. They redeem anywhere, anytime.
            Sender identity is optional. PARALLAX holds the commitment. φ⁻³ = 0.236% fee.
          </div>
          <label style={W.label}>Amount</label>
          <div style={W.field}>
            <input
              style={{ ...W.input, fontSize: 22, fontWeight: 700, flex: 1 }}
              type="number" min="0" step="0.01" placeholder="0.00"
              value={phaAmount} onChange={e => setPhaAmount(e.target.value)}
            />
            <select style={W.select} value={phaCur} onChange={e => setPhaCur(e.target.value)}>
              {FIAT_CURRENCIES.map(c => <option key={c}>{c}</option>)}
            </select>
          </div>
          <input style={{ ...W.input, marginBottom: 16 }} placeholder="Note (optional — not revealed to recipient)" value={phaNote} onChange={e => setPhaNote(e.target.value)} />
          {phaNum > 0 && (
            <div style={W.feePreview}>
              <div>Shielding: <strong style={{ color: '#e0c0ff' }}>{fmt(phaNum * 100, phaCur)}</strong></div>
              <div>Fee φ⁻³ (0.236%): <span style={{ color: '#6040a0' }}>{fmt(phaFee * 100, phaCur)}</span></div>
              <div style={{ color: '#2a1a4a', fontSize: 10, marginTop: 4 }}>PHANTOM rail: commitment-reveal stealth. 24h hold. Recipient redeems to any exit.</div>
            </div>
          )}
          {phaCommit !== '' && (
            <div>
              <div style={W.label}>Commitment seal (keep this)</div>
              <div style={W.commitment}>{phaCommit}</div>
            </div>
          )}
          <button style={W.btnPhantom} onClick={submitPhantom} disabled={loading}>
            {loading ? 'Sealing commitment…' : '👻 Initiate PHANTOM Transfer'}
          </button>
        </>
      )}

      {result && (
        <div style={W.result(result.ok)}>
          {result.ok ? '✓ ' : '✗ '}{result.msg}
          {result.extra && <div style={{ marginTop: 6, color: '#6090a0', fontFamily: 'monospace', fontSize: 11 }}>{result.extra}</div>}
        </div>
      )}

      <div style={{ marginTop: 12, fontSize: 10, color: '#1a3050', textAlign: 'center' as const }}>
        Powered by PARALLAX · phantom_transfer canister (Build №35) · ONESICAN clearinghouse
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// RECEIVE PANEL — generate & redeem claim links
// ═══════════════════════════════════════════════════════════════════════════
function ReceivePanel() {
  const [genAmount,  setGenAmount]  = useState('');
  const [genCur,     setGenCur]     = useState('USD');
  const [genMethod,  setGenMethod]  = useState<'PHONE' | 'CLABE' | 'IBAN' | 'CARD'>('PHONE');
  const [genNote,    setGenNote]    = useState('');
  const [genLoading, setGenLoading] = useState(false);
  const [genResult,  setGenResult]  = useState<{ ok: boolean; msg: string; code?: string } | null>(null);

  const [code,       setCode]       = useState('');
  const [redMethod,  setRedMethod]  = useState<'PHONE' | 'CLABE' | 'IBAN' | 'CARD'>('PHONE');
  const [redRef,     setRedRef]     = useState('');
  const [redLoading, setRedLoading] = useState(false);
  const [redResult,  setRedResult]  = useState<{ ok: boolean; msg: string } | null>(null);

  const generate = useCallback(async () => {
    setGenLoading(true); setGenResult(null);
    try {
      const cents = Math.round(parseFloat(genAmount) * 100);
      if (!cents || cents <= 0) throw new Error('Enter an amount');
      const rm = genMethod === 'CLABE' ? 'BANK_SPEI' : genMethod === 'IBAN' ? 'BANK_SEPA' : genMethod === 'PHONE' ? 'PHONE' : 'CARD_VISA';
      const res = await parallax_generateClaimLink(cents, genCur, rm, genNote || 'Phantom Wallet claim');
      setGenResult({ ok: res.success, msg: res.message, code: res.claimCode || undefined });
    } catch (err: unknown) {
      setGenResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally { setGenLoading(false); }
  }, [genAmount, genCur, genMethod, genNote]);

  const redeem = useCallback(async () => {
    setRedLoading(true); setRedResult(null);
    try {
      if (!code.trim()) throw new Error('Enter the claim code');
      if (!redRef.trim()) throw new Error('Enter your destination ref');
      const rm = redMethod === 'CLABE' ? 'BANK_SPEI' : redMethod === 'IBAN' ? 'BANK_SEPA' : redMethod === 'PHONE' ? 'PHONE' : 'CARD_VISA';
      const res = await parallax_redeemClaimLink(code.trim(), rm, redRef.trim());
      setRedResult({ ok: res.success, msg: res.message });
    } catch (err: unknown) {
      setRedResult({ ok: false, msg: err instanceof Error ? err.message : String(err) });
    } finally { setRedLoading(false); }
  }, [code, redMethod, redRef]);

  return (
    <div style={W.card}>
      <div style={W.cardTitle}>Receive</div>
      <div style={W.cardSub}>Create a claim link — or redeem one. No bank account required.</div>

      {/* Generate */}
      <div style={{ fontSize: 11, color: '#44aaff', letterSpacing: '0.1em', textTransform: 'uppercase' as const, marginBottom: 12 }}>Create Claim Link</div>
      <div style={W.field}>
        <input
          style={{ ...W.input, fontSize: 20, fontWeight: 700, flex: 1 }}
          type="number" min="0" step="0.01" placeholder="0.00"
          value={genAmount} onChange={e => setGenAmount(e.target.value)}
        />
        <select style={W.select} value={genCur} onChange={e => setGenCur(e.target.value)}>
          {RECEIVE_CURRENCIES.map(c => <option key={c}>{c}</option>)}
        </select>
      </div>
      <label style={W.label}>Recipient redeems via</label>
      <div style={W.typeRow}>
        {(['PHONE', 'CLABE', 'IBAN', 'CARD'] as const).map(t => (
          <button key={t} style={W.typeBtn(genMethod === t)} onClick={() => setGenMethod(t)}>
            {t === 'PHONE' ? '📱 Phone' : t === 'CLABE' ? '🏦 CLABE' : t === 'IBAN' ? '🌍 IBAN' : '💳 Card'}
          </button>
        ))}
      </div>
      <input style={{ ...W.input, marginBottom: 16 }} placeholder="Note (optional)" value={genNote} onChange={e => setGenNote(e.target.value)} />
      <button style={W.btnSecondary} onClick={generate} disabled={genLoading}>
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
      <div style={{ fontSize: 11, color: '#44aaff', letterSpacing: '0.1em', textTransform: 'uppercase' as const, marginBottom: 12 }}>Redeem a Claim Link</div>
      <input
        style={{ ...W.input, marginBottom: 12, fontFamily: 'monospace', letterSpacing: '0.04em' }}
        placeholder="NOVA-CLM-…"
        value={code} onChange={e => setCode(e.target.value)}
      />
      <label style={W.label}>Receive to</label>
      <div style={W.typeRow}>
        {(['PHONE', 'CLABE', 'IBAN', 'CARD'] as const).map(t => (
          <button key={t} style={W.typeBtn(redMethod === t)} onClick={() => setRedMethod(t)}>
            {t === 'PHONE' ? '📱' : t === 'CLABE' ? '🏦' : t === 'IBAN' ? '🌍' : '💳'}
          </button>
        ))}
      </div>
      <input
        style={{ ...W.input, marginBottom: 16 }}
        placeholder={redMethod === 'PHONE' ? '+1 / +52 / +44 …' : redMethod === 'CLABE' ? '18-digit CLABE' : redMethod === 'IBAN' ? 'IBAN (EU/UK)' : 'Card token'}
        value={redRef} onChange={e => setRedRef(e.target.value)}
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

// ═══════════════════════════════════════════════════════════════════════════
// STATUS PANEL — live clearinghouse snapshot
// ═══════════════════════════════════════════════════════════════════════════
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
            ['Remittances',      fmtBig(status.totalRemittances)],
            ['Claims out',       fmtBig(status.claimsGenerated)],
            ['Claims redeemed',  fmtBig(status.claimsRedeemed)],
            ['Exits delivered',  fmtBig(status.exitsDelivered)],
            ['Registered users', fmtBig(status.registeredUsers)],
            ['Build',            status.buildNumber.toString()],
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
          Canister offline — check connection or dfx deployment.
        </div>
      )}

      {/* ── Protocol Invariant Verification ─────────────────────── */}
      {(() => {
        const result = verifyProtocol();
        return (
          <div style={{ marginBottom: 16 }}>
            <div style={{
              fontSize: 11, letterSpacing: '0.1em', textTransform: 'uppercase' as const,
              color: result.allPassed ? '#4f4' : '#f44', marginBottom: 8,
            }}>
              Protocol Invariant Check — {result.allPassed ? '✓ ALL PASSED' : '✗ VIOLATION DETECTED'}
            </div>
            {result.doctrineResults.map(d => (
              <div key={d.doctrine} style={{
                display: 'flex', justifyContent: 'space-between', padding: '3px 0',
                borderBottom: '1px solid #090f1a', fontSize: 10,
              }}>
                <span style={{ color: '#2a4060' }}>{d.doctrine}</span>
                <span style={{ color: d.passed ? '#4f4' : '#f44', fontWeight: 700 }}>
                  {d.passed ? '✓' : '✗'}
                </span>
              </div>
            ))}
            <div style={{ marginTop: 6, display: 'flex', gap: 16, fontSize: 10 }}>
              <span style={{ color: result.feeProofValid ? '#44aaff' : '#f44' }}>
                FEE PROOF: {result.feeProofValid ? 'φ⁻³/φ⁻⁴=φ ✓' : '✗'}
              </span>
              <span style={{ color: result.noDropValid ? '#4f4' : '#f44' }}>
                NO-DROP: {result.noDropValid ? 'W≥S₀ ✓' : '✗'}
              </span>
              <span style={{ color: result.layerZeroValid ? '#b844ff' : '#f44' }}>
                LAYER-0: {result.layerZeroValid ? 'NOVA ✓' : '✗'}
              </span>
            </div>
          </div>
        );
      })()}

      <div style={W.divider} />

      <div style={{ fontSize: 11, color: '#44aaff', letterSpacing: '0.1em', textTransform: 'uppercase' as const, marginBottom: 10 }}>
        Oracle Exchange Rates (ONESICAN)
      </div>
      {rates.length === 0 && <div style={{ color: '#3a6080', fontSize: 12 }}>Rates loading…</div>}
      {rates.map(r => (
        <div key={r.currency} style={W.rateRow}>
          <span style={{ color: '#8ab0d0', fontWeight: 600 }}>{r.currency}</span>
          <span style={{ color: '#4a7090' }}>{r.ratePerCent.toString()} ONESICAN / 100¢</span>
        </div>
      ))}

      <div style={W.divider} />

      <div style={{ fontSize: 11, color: '#88cc44', letterSpacing: '0.1em', textTransform: 'uppercase' as const, marginBottom: 10 }}>
        Crypto Display Rates (client-side reference)
      </div>
      {CRYPTO_ASSETS.map(a => (
        <div key={a} style={W.rateRow}>
          <span style={{ color: '#88cc44', fontWeight: 600 }}>{a}</span>
          <span style={{ color: '#4a7090' }}>≈ ${CRYPTO_USD[a].toLocaleString()} USD</span>
        </div>
      ))}

      <div style={W.divider} />

      {/* ── Exit Rail Architecture ─────────────────────────────── */}
      <div style={{ fontSize: 11, color: '#b844ff', letterSpacing: '0.1em', textTransform: 'uppercase' as const, marginBottom: 10 }}>
        Exit Rail Architecture (PARALLAX Charter)
      </div>
      {[
        { rail: 'ACH',         region: '🇺🇸 USA',   speed: 'Instant clearing',  color: '#44aaff' },
        { rail: 'SPEI',        region: '🇲🇽 Mexico', speed: '24/7 instant',       color: '#f90' },
        { rail: 'SEPA',        region: '🇪🇺 EU/UK',  speed: 'Same-day',          color: '#6699ff' },
        { rail: 'ZENGIN',      region: '🇯🇵 Japan',  speed: 'Domestic instant',  color: '#ff4466' },
        { rail: 'PIX',         region: '🇧🇷 Brazil', speed: '24/7 instant',       color: '#4f4' },
        { rail: 'CLAIM_LINK',  region: '🌍 Global',  speed: 'No account needed', color: '#b844ff' },
        { rail: 'CARD',        region: '💳 Global',  speed: 'Push payment',       color: '#88cc44' },
      ].map(r => (
        <div key={r.rail} style={{ ...W.rateRow, alignItems: 'center' }}>
          <span style={{ color: r.color, fontWeight: 700, fontSize: 11, minWidth: 90 }}>{r.rail}</span>
          <span style={{ color: '#4a7090', fontSize: 11, flex: 1, textAlign: 'center' as const }}>{r.region}</span>
          <span style={{ color: '#2a4060', fontSize: 10 }}>{r.speed}</span>
        </div>
      ))}

      <div style={W.divider} />

      {/* ── Charter Doctrines ──────────────────────────────────── */}
      <div style={{ fontSize: 11, color: '#f90', letterSpacing: '0.1em', textTransform: 'uppercase' as const, marginBottom: 10 }}>
        Charter Doctrines
      </div>
      {[
        { num: 'I',   label: 'Sovereign Settlement', text: 'Not a bank. Not a custodian. PARALLAX is the engine.', color: '#44aaff' },
        { num: 'II',  label: 'Attribution Closure',  text: 'Every transfer → irrevocable quipu_ledger record. Paper I.', color: '#f90' },
        { num: 'III', label: 'Paper–Engine Isomorphism', text: 'phantom_transfer canister IS the PARALLAX charter. Paper IV.', color: '#b844ff' },
        { num: 'IV',  label: 'No-Drop Law',          text: 'Reputation ≥ S₀ = 1.0 always. Structural, not policy. Paper V.', color: '#4f4' },
      ].map(d => (
        <div key={d.num} style={{ paddingBottom: 10, marginBottom: 10, borderBottom: '1px solid #0f1a2a' }}>
          <div style={{ display: 'flex', gap: 8, alignItems: 'baseline', marginBottom: 3 }}>
            <span style={{ fontSize: 9, color: d.color, fontWeight: 700, letterSpacing: '0.08em' }}>DOCTRINE {d.num}</span>
            <span style={{ fontSize: 12, fontWeight: 700, color: d.color }}>{d.label}</span>
          </div>
          <div style={{ fontSize: 11, color: '#3a6080', lineHeight: 1.4 }}>{d.text}</div>
        </div>
      ))}

      <div style={{ marginTop: 8, fontSize: 10, color: '#1a3050', textAlign: 'center' as const }}>
        Powered by PARALLAX · phantom_transfer Build #{status?.buildNumber.toString() ?? '35'}<br />
        ONESICAN oracle · φ⁻⁴ FIAT/CRYPTO · φ⁻³ PHANTOM · Group E neurons (70) back liquidity<br />
        arXiv Wave 1 · 5 sovereign papers · Medina Tech · Dallas, Texas · 2026
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN WALLET DASHBOARD SHELL
// ═══════════════════════════════════════════════════════════════════════════
export function PhantomWalletDashboard() {
  const [tab,        setTab]        = useState<WalletTab>('SEND');
  const [status,     setStatus]     = useState<ClearinghouseStatus | null>(null);
  const [rates,      setRates]      = useState<ExchangeRate[]>([]);
  const [statusLoad, setStatusLoad] = useState(true);
  const [live,       setLive]       = useState(false);
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const fetchAll = useCallback(async () => {
    try {
      const [s, r] = await Promise.all([
        parallax_getClearinghouseStatus(),
        parallax_getExchangeRates(),
      ]);
      setStatus(s); setRates(r); setLive(true);
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
      <div style={W.header}>
        <div>
          <div style={W.brand}>👻 Phantom Wallet</div>
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

      <div style={W.body}>
        {tab === 'SEND'    && <SendPanel    rates={rates} />}
        {tab === 'RECEIVE' && <ReceivePanel />}
        {tab === 'STATUS'  && <StatusPanel  status={status} rates={rates} loading={statusLoad} />}
      </div>
    </div>
  );
}

export default PhantomWalletDashboard;
