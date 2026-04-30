# Phantom Wallet — Master Product Charter
## First Product of the NOVA Ecosystem  (Build №38 — Global + Crypto + PHANTOM Rail)
### Medina Tech · Dallas, Texas · 2026 · CONFIDENTIAL & PROPRIETARY

---

> **"Send anything. Anywhere. PARALLAX routes it. You do nothing."**

---

## The Mission

Phantom Wallet is the **first consumer product** built on PARALLAX. It is not a bank account. It is not a crypto wallet. It is a sovereign value transfer layer — a way for anyone to send any asset to anyone else, instantly, anywhere in the world, using whatever they have.

- You have ETH → they get BRL on their Pix account in São Paulo
- You have USD on your Chime card → they get MXN on their phone in Guadalajara
- You have ¥200,000 JPY → they get €700 EUR on their German IBAN
- You want to send anonymously → PHANTOM rail: commitment hash, claim link, zero identity revealed

The name is **Phantom Wallet** now. The mission is **Phantom Bank** later. That mission means full banking and full financial sovereignty for anyone — regardless of country, citizenship, or bank access.

**Powered by PARALLAX. Invisible by design.**

---

## What This Product Does (Build №38)

Phantom Wallet has **three rails** exposed to the consumer:

### Rail 1: FIAT
Any fiat currency → any fiat currency → anywhere.

| From | To | Rails |
|------|-----|-------|
| USD, MXN, EUR, GBP, JPY, BRL | Same 6 currencies | EDGE GATE → ONESICAN → fiat exit |

Destinations: Phone, CLABE (Mexico), IBAN (EU/UK), Card token.
Function: `sendRemittance()` on `phantom_transfer` canister.
Fee: φ⁻⁴ = 0.146%

### Rail 2: CRYPTO (Bridge)
Any crypto asset → USD equivalent → ONESICAN bridge → any fiat exit.

Supported: **BTC, ETH, SOL, ICP, MATIC**

The sender inputs a crypto amount. PARALLAX converts to USD via the oracle network, bridges through ONESICAN clearinghouse, and settles to the recipient's preferred fiat exit rail. No custodian. NOVA is the bridge.

Fee: φ⁻⁴ = 0.146%

### Rail 3: PHANTOM (Stealth)
Commitment-reveal stealth transfers.

1. Sender commits an amount + currency → PARALLAX generates a **commitment hash** (the seal)
2. PARALLAX holds the commitment in the ONESICAN pool (24h window)
3. Recipient receives a **claim code** — they redeem to any destination when ready
4. Sender identity is never exposed unless they choose to reveal it

This is the PHANTOM rail from `phantom_transfer/main.mo`. Consumer-facing implementation uses `generateClaimLink()`. The commitment hash is displayed to the sender as the cryptographic seal.

Fee: φ⁻³ = 0.236% (stealth premium)

---
- Calls `redeemClaimLink()`
- Money lands in seconds

No Phantom Wallet account required to receive. That is the point.

---

## The User

### Primary: US-Mexico remittance family
- 40 million Mexicans in the United States
- They send $60+ billion per year to Mexico
- Western Union charges 4-8% + bad exchange rates
- PARALLAX charges 0.146%
- On $60B/year, that difference returns $2.3–4.8 billion per year to families

### Secondary: Anyone sending cross-border
- Dallas → Monterrey: daily household remittances
- Houston → Guadalajara: worker wages
- Chicago → CDMX: family support
- Eventually: US → any country PARALLAX supports

---

## Product Architecture

```
Phantom Wallet (consumer UI — this product)
│
├── PhantomWalletLanding.tsx    Consumer-facing landing page
├── PhantomWalletDashboard.tsx  Runtime wallet app (Send / Receive / Status)
├── PhantomWalletApp.tsx        Shell (landing ↔ dashboard)
│
└── Powered by PARALLAX
    └── parallaxActor.ts        TypeScript SDK → phantom_transfer canister
```

Phantom Wallet **never** calls blockchain code directly. All settlement goes through `parallaxActor.ts` → `phantom_transfer` canister → PARALLAX clearinghouse.

---

## User Flows

### Flow 1: Send Money (the main flow)
```
1. User opens Phantom Wallet
2. Enters: amount (in MXN, USD, etc.)
3. Enters: who to send to (phone number, CLABE, card token)
4. Hits: "Send"
5. App calls: sendRemittance()
6. If recipient has no account: generates claim link → sends via SMS/WhatsApp
7. If recipient has account/CLABE: queues ACH/SPEI exit
8. User sees: confirmation, fee (0.146%), expected delivery
```

### Flow 2: Receive (claim link redemption)
```
1. Recipient gets SMS/WhatsApp with claim code
2. Opens Phantom Wallet (or the link — no install required)
3. Enters: how they want to receive (bank, phone wallet, cash pickup code)
4. App calls: redeemClaimLink()
5. PARALLAX routes the exit to their chosen rail
6. Recipient sees: money arrived
```

### Flow 3: Status
```
1. User opens Phantom Wallet
2. Sees: recent sends, status (QUEUED → DELIVERED), exchange rates
3. App calls: getClearinghouseStatus() + getExchangeRates()
```

---

## What Phantom Wallet Is NOT

- **Not a bank account.** No deposits held. No FDIC. Pure routing.
- **Not a crypto app.** Users never see ONESICAN, CHR, or any internal token.
- **Not a stablecoin.** NOVA-PESO is internal settlement unit only.
- **Not a WU clone.** WU is a corridor operator. Phantom Wallet is a settlement terminal.
- **Not Venmo.** Venmo is US-only bank-to-bank. Phantom Wallet is any-to-any.

---

## Fee Display

The UI must display the fee clearly:

```
Sending: 5,000 MXN
Fee: 7.29 MXN (0.146%)
They receive: ≈ $250 USD
Exchange rate: 1 USD = 19.88 MXN (live)
```

No hidden fees. No spread manipulation. One number. Always φ⁻⁴.

---

## "Powered by PARALLAX" Requirements

Per the PARALLAX Charter, Phantom Wallet must:
1. Show "Powered by PARALLAX" in the footer
2. Route all settlement through `phantom_transfer` canister
3. Never expose internal tokens to users
4. Display the 0.146% fee as a single clear number
5. Use `parallaxActor.ts` for all canister calls

---

## Technology Stack (CPL)

| Layer              | Language / Runtime       | File                                      |
|--------------------|--------------------------|-------------------------------------------|
| Backend canister   | Motoko                   | `src/phantom_transfer/main.mo`            |
| Canister actor SDK | TypeScript               | `src/frontend/src/canister/parallaxActor.ts` |
| UI shell           | TypeScript + React       | `src/frontend/src/phantom_wallet/PhantomWalletApp.tsx` |
| Landing page       | TypeScript + React + CSS-in-JS | `src/frontend/src/phantom_wallet/PhantomWalletLanding.tsx` |
| Runtime dashboard  | TypeScript + React       | `src/frontend/src/phantom_wallet/PhantomWalletDashboard.tsx` |
| PWA service worker | JavaScript               | `src/frontend/public/sw.js`               |
| PWA manifest       | JSON                     | `src/frontend/public/manifest.json`       |
| Build system       | Vite (TypeScript config) | `src/frontend/vite.config.ts`             |

This is CPL. No single language. Every layer uses what it is made for.

---

## Build Timeline

| Phase  | Deliverable                                      | Status    |
|--------|--------------------------------------------------|-----------|
| №33-35 | phantom_transfer canister — full clearinghouse   | ✅ Done   |
| №36    | PARALLAX PWA — settlement infrastructure UI      | ✅ Done   |
| №37    | Charters + Phantom Wallet consumer product       | 🔨 Now    |
| №38    | Claim link SMS/WhatsApp integration (off-chain bridge) | Next |
| TBD    | Phantom Bank — full banking product              | Mission   |

---

## The Name

**Phantom Wallet** — temporary name during the wallet phase.

The mission is **Phantom Bank**. When the product evolves from routing to banking — when people can hold balances, earn interest, get debit cards, and have full financial identity inside this system — it becomes Phantom Bank.

The wallet is the first step. The bank is where it goes.

---

## Charter Authority

This charter was written at Build №37, April 2026, by order of Alfredo Medina Hernandez, founder of Medina Tech, Dallas, Texas.

All product decisions about Phantom Wallet are governed by this charter and the PARALLAX Charter above it.

---

*Copyright © 2024-2026 Medina Tech · Alfredo Medina Hernandez · Dallas, Texas, USA*
*CONFIDENTIAL & PROPRIETARY — NOVA Sovereign Doctrine*
