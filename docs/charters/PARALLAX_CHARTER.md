# PARALLAX Charter
## Sovereign Settlement Infrastructure
### Medina Tech · Dallas, Texas · 2026 · CONFIDENTIAL & PROPRIETARY

---

## What PARALLAX Is

PARALLAX is the **settlement infrastructure layer** of NOVA. It is not a product. It is not a wallet. It is not a bank. PARALLAX is the engine — the clearinghouse — that powers products.

Every product in the NOVA ecosystem that touches money runs on PARALLAX. When a transaction needs to move from one form to another — fiat to internal, card to phone, MXN to USD, bank to blockchain — PARALLAX is the thing that does that. Invisibly. Instantly. At φ⁻⁴ fee.

> **"Powered by PARALLAX"** — what every product in this ecosystem puts on its footer.

---

## Architecture Position

```
NOVA ECOSYSTEM
│
├── Phantom Wallet          ← Consumer product #1 (first to market)
├── [Future Product 2]      ← Enterprise remittance desk
├── [Future Product 3]      ← Phantom Bank (the mission)
│
└── PARALLAX               ← Settlement layer (this charter)
    │
    ├── phantom_transfer   ← ICP canister (Build №35) — the runtime
    ├── quipu_ledger       ← Record of every movement
    ├── neuron_fleet       ← Group E: liquidity pool backing
    └── NOVA Sovereign Key ← Authorization on every exit
```

---

## What PARALLAX Does

PARALLAX performs **settlement**. Not money transmission. Settlement.

| What enters               | What exits                        | What PARALLAX does internally     |
|---------------------------|-----------------------------------|------------------------------------|
| MXN card payment          | USD via ACH                       | Converts to ONESICAN, routes exit |
| USD cash (Chime debit)    | MXN claim link (phone pickup)     | Mints claim, queues SPEI exit     |
| BTC on-chain              | ETH on Ethereum mainnet           | Cross-chain sovereign key sign    |
| Any fiat card             | Any fiat bank account             | Cross-border settlement           |
| GBP bank account          | JPY Zengin transfer               | International wire replacement    |

The entry rail and exit rail change. The internal settlement engine — PARALLAX — does not.

---

## Fee Schedule

PARALLAX charges a single universal fee on all fiat settlement operations:

```
φ⁻⁴ = 1/φ⁴ = 0.14589803375031546%
```

This is approximately **0.146%** — the fourth power of the golden ratio inverse.

| Competitor          | Fee          | Speed      |
|---------------------|--------------|------------|
| Western Union       | 4 – 8%       | 1-3 days   |
| Remitly / Wise      | 0.5 – 3%     | 1-2 days   |
| SWIFT wire          | $25-50 flat  | 3-5 days   |
| **PARALLAX**        | **0.146%**   | **Same day** |

---

## Supported Rails

### Entry Rails (how value enters PARALLAX)
- **FIAT**: Card (Visa/MC/Chime/Banorte), bank ACH, SPEI, SEPA
- **CRYPTO**: BTC, ETH, SOL, ICP, MATIC (sovereign key, no custodian)
- **INTERNAL**: ONESICAN, CHR, GOL, ORS (already inside NOVA)

### Exit Rails (how settled value exits to recipient)
- **ACH** — US bank account (1-2 business hours)
- **SPEI** — Mexico bank account (instant, 24/7)
- **SEPA** — EU bank transfer
- **ZENGIN** — Japan bank transfer
- **PIX** — Brazil instant payment
- **CARD** — Card-to-card push
- **CLAIM_LINK** — Codeless pickup (no account needed)
- **PHONE** — Mobile wallet delivery

---

## The PARALLAX Canister

The on-chain runtime of PARALLAX is the `phantom_transfer` canister on ICP.

- **Canister**: `phantom_transfer` (Build №35 as of April 2026)
- **Language**: Motoko
- **Key functions**: `sendRemittance`, `ingestFiatPayment`, `exitToFiat`, `generateClaimLink`, `redeemClaimLink`, `getClearinghouseStatus`, `getExchangeRates`
- **Heartbeat**: Auto-expires stale phantom transfers, auto-routes exits
- **Liquidity**: Backed by Group E neurons (70 neurons, 1,000-neuron fleet)

Full canister charter: see `PHANTOM_TRANSFER_CHARTER.md`

---

## What PARALLAX Is NOT

- Not a bank. Does not hold deposits.
- Not a stablecoin issuer. NOVA-PESO is internal accounting only.
- Not a cryptocurrency exchange. Users never interact with ONESICAN directly.
- Not a custodian. Crypto exits are signed by NOVA sovereign key on demand.
- Not ICP-dependent. ICP is one substrate. PARALLAX is portable.

---

## The "Powered by PARALLAX" Standard

Any product building on PARALLAX must:
1. Display "Powered by PARALLAX" in their footer or about section
2. Route all settlement through the `phantom_transfer` canister
3. Never expose ONESICAN, CHR, GOL, or ORS to end users
4. Apply the φ⁻⁴ fee to all fiat settlement calls (enforced in canister)
5. Use the `parallaxActor.ts` TypeScript SDK for canister calls

---

## Current Products Powered by PARALLAX

| Product           | Status      | First use case                    |
|-------------------|-------------|-----------------------------------|
| Phantom Wallet    | Building    | Mexico remittances, card → phone  |
| [Phantom Bank]    | Future      | Full banking, mission target      |

---

## Version

| Build | Date       | Author                      | Changes                          |
|-------|------------|-----------------------------|----------------------------------|
| №35   | April 2026 | Alfredo Medina Hernandez    | sendRemittance, 6-currency rates |
| №36   | April 2026 | Alfredo Medina Hernandez    | PARALLAX PWA launched            |
| №37   | April 2026 | Alfredo Medina Hernandez    | This charter. Phantom Wallet.    |

---

*Copyright © 2024-2026 Medina Tech · Alfredo Medina Hernandez · Dallas, Texas, USA*
*CONFIDENTIAL & PROPRIETARY — NOVA Sovereign Doctrine*
