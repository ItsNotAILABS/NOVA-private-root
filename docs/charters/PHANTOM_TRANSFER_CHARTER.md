# phantom_transfer Charter
## The NOVA Sovereign Clearinghouse Canister
### Medina Tech · Dallas, Texas · 2026 · CONFIDENTIAL & PROPRIETARY

---

## What phantom_transfer Is

`phantom_transfer` is the **on-chain runtime** of PARALLAX. It is the Motoko canister on the Internet Computer that executes all settlement operations: ingesting fiat, routing exits, generating claim links, tracking identities, recording every movement in the quipu_ledger, and managing the Group E liquidity pool.

This is not an abstraction. This is the real code that runs. When Phantom Wallet sends a remittance, this canister executes it. When a claim link is redeemed, this canister settles it. It is the heart of the financial system.

---

## Build History

| Build | Key Additions                                                                                              |
|-------|------------------------------------------------------------------------------------------------------------|
| №33   | 4 rails (FIAT/INTERNAL/CRYPTO/PHANTOM), heartbeat auto-expiry, Group E liquidity, commitment-reveal stealth |
| №34   | User identity, claim links, fiat exit queue, oracle rate system, ETH_L2 support                           |
| №35   | `sendRemittance` (Tier 1/5 single-call path), GBP/JPY/BRL rates, `setFiatRatesExtended`, totalRemittances |
| №36   | PARALLAX PWA frontend, TypeScript actor (`parallaxActor.ts`), `getQueuedExits` IDL fix                    |

---

## Architecture

```
phantom_transfer (Motoko canister on ICP)
│
├── Section 1-3:   Core types, constants, state
├── Section 4:     User identity + linked accounts
├── Section 5:     FIAT rail — ingestFiatPayment, NOVA-PESO peg
├── Section 6:     INTERNAL rail — ONESICAN/CHR/GOL/ORS
├── Section 7:     CRYPTO rail — BTC/ETH/SOL/ICP/MATIC
├── Section 8:     PHANTOM rail — commitment-reveal stealth
├── Section 9:     Core transfer — initiateTransfer/confirm/cancel
├── Section 10:    Heartbeat — auto-expire stale PHANTOM transfers
├── Section 11:    Status — getClearinghouseStatus
├── Section 12:    Oracle rates — setExchangeRate, getExchangeRates
├── Section 13:    Claim links — generateClaimLink, redeemClaimLink
├── Section 14:    Fiat exit — exitToFiat, getQueuedExits
├── Section 15:    ETH_L2 support
└── Section 16:    sendRemittance — single-call Tier 1/5 family path
```

---

## Public API (Build №35)

### Queries (fast, no state change)
| Function                   | Returns                        | Purpose                               |
|----------------------------|--------------------------------|---------------------------------------|
| `getClearinghouseStatus()` | `ClearinghouseStatus`          | Full clearinghouse snapshot           |
| `getExchangeRates()`       | `[ExchangeRate]`               | 6-currency live rates                 |
| `getQueuedExits(limit)`    | `[QueuedExit]`                 | Pending fiat exit queue               |
| `getRailStatus(rail)`      | `{rail, volume, count, avgFee}`| Per-rail volume/health                |

### Updates (state-changing calls)
| Function                                       | Key Args                                      | Purpose                             |
|------------------------------------------------|-----------------------------------------------|-------------------------------------|
| `registerUser(label)`                          | label: Text                                   | Create PARALLAX identity            |
| `linkAccount(railType, ref, currency, ...)`    | rail+ref+currency+balance+label               | Link bank/card to identity          |
| `ingestFiatPayment(currency, amtCents, ...)`   | currency+cents+paymentRef+note                | Convert fiat → ONESICAN             |
| `sendRemittance(fromCurrency, amtCents, ...)`  | from+amount+cardRef+to+toRef+toRefType+note   | One-call: card → fiat exit/claim    |
| `exitToFiat(amtOnesican, currency, rail, ...)` | onesican+currency+rail+destRef+note           | Queue fiat exit                     |
| `generateClaimLink(amtOnesican, currency, ...)` | onesican+currency+redeemMethod+note          | Create codeless pickup link         |
| `redeemClaimLink(claimCode, method, ref)`      | claimCode+redeemMethod+redeemRef              | Settle claim to recipient           |
| `setExchangeRate(currency, rate)`              | currency+ratePerCent                          | Sovereign/oracle rate update        |
| `setFiatRatesExtended(gbp, jpy, brl)`          | gbp+jpy+brl rates                             | Extended currency rate set          |

---

## State Variables

| Variable              | Type             | Purpose                                      |
|-----------------------|------------------|----------------------------------------------|
| `totalTransfers`      | Nat              | Lifetime transfer count                      |
| `totalTransfersSettled` | Nat            | Settled count                                |
| `totalRemittances`    | Nat              | `sendRemittance()` call count (Build №35)    |
| `totalFiatIngested`   | Nat              | ONESICAN minted from fiat (in cents)         |
| `totalFeesCollected`  | Nat              | Cumulative φ⁻⁴ fees in ONESICAN             |
| `liquidityPool`       | Nat              | ONESICAN backed by Group E neurons           |
| `groupENeurons`       | Nat              | Count of Group E neurons                     |
| `registeredUsers`     | Nat              | Identity count                               |
| `linkedAccountsTotal` | Nat              | Linked rail accounts                         |
| `claimsGenerated`     | Nat              | Claim links generated                        |
| `claimsRedeemed`      | Nat              | Claim links settled                          |
| `exitsQueued`         | Nat              | Fiat exits pending delivery                  |
| `exitsDelivered`      | Nat              | Fiat exits completed                         |

---

## Fee Model

All fiat settlement operations charge:
```
fee = amount × φ⁻⁴ = amount × 0.14589803375031546%
```

PHANTOM (stealth) transfers charge:
```
fee = amount × φ⁻³ = amount × 0.23606797749978967%
```

Fees are deducted from ONESICAN settlement pool and recorded in `totalFeesCollected`.

---

## The sendRemittance Flow (Section 16 — Build №35)

This is the critical Tier 1/5 path — the one Phantom Wallet uses:

```
User calls sendRemittance(
  fromCurrency: "MXN",
  amountCents:  500_000,       // 5,000 MXN
  fromCardRef:  "CARD-TOKEN",  // tokenized card reference
  toCurrency:   "USD",
  toRef:        "routing+acct",
  toRefType:    "BANK_ACH",
  note:         "para mi hermana"
)

PARALLAX internally:
  1. _getFiatRate("MXN") → convert cents to ONESICAN
  2. Apply φ⁻⁴ fee
  3. _inferExitRail("BANK_ACH") → "ACH"
  4. If toRefType == "PHONE" or "CLAIM_LINK" → generateClaimLink()
  5. Else → exitToFiat() → queue ACH exit
  6. Increment totalRemittances
  7. Return: txId, exitId, claimCode, fiatIn, onesicansNet, fiatOut, fee
```

---

## Heartbeat Behavior

The canister heartbeat runs every ~2 seconds (ICP system timer).

Every tick it:
1. Checks for stale PHANTOM transfers (>24h since commit) and auto-expires them
2. Increments the internal tick counter

---

## Liquidity Model

The clearinghouse liquidity pool (`liquidityPool`) is backed by:
- **70 Group E neurons** from the 1,000-neuron `neuron_fleet`
- These neurons stake governance rewards that flow into the ONESICAN settlement pool
- Group E exists solely to back PARALLAX clearinghouse liquidity

---

## Canister Registration

| Config    | Canister ID             | Build Language |
|-----------|-------------------------|----------------|
| `nova.json` (sovereign) | `phantom_transfer` | Motoko |
| `dfx.json` (ICP deploy) | `phantom_transfer` | Motoko |
| Local dfx default | `br5f7-7uaaa-aaaaa-qaaca-cai` | — |

---

## TypeScript SDK

The `parallaxActor.ts` file in `src/frontend/src/canister/` is the typed TypeScript adapter for this canister. It uses `@dfinity/agent` with a full Candid IDL matching every function signature above.

---

*Copyright © 2024-2026 Medina Tech · Alfredo Medina Hernandez · Dallas, Texas, USA*
*CONFIDENTIAL & PROPRIETARY — NOVA Sovereign Doctrine*
