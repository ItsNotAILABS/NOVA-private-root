# PARALLAX Trading Platform

A trader-facing PARALLAX application for TradingView chart access, authenticated TradingView alert ingestion, bot and strategy creation, governed paper execution, portfolio tracking, wallet registration, unsigned transaction-intent preparation, and cryptographic receipts.

## Run

```bash
cd apps/parallax-trading-platform
PARALLAX_TRADINGVIEW_TOKEN=replace-this-token npm start
```

Open:

```text
http://127.0.0.1:8960
```

Validation:

```bash
npm run check
npm test
```

## Product surfaces

- Overview dashboard
- Embedded TradingView market chart
- Authenticated TradingView webhook intake
- Bot Studio
- Strategy registry
- Order blotter and approval lane
- Paper fills and portfolio positions
- Non-custodial wallet registry
- Unsigned wallet transaction intents
- Connections view
- SHA-256 receipt ledger

## TradingView alert setup

Use this webhook URL after exposing the local server through a TLS reverse proxy or approved tunnel:

```text
https://YOUR_HOST/api/tradingview/webhook
```

Configure the same token in the server environment and the alert request header:

```bash
PARALLAX_TRADINGVIEW_TOKEN=replace-this-token
```

Example payload:

```json
{
  "alert_id": "btc-breakout-001",
  "symbol": "BTCUSD",
  "action": "buy",
  "price": 64250.20,
  "timeframe": "15",
  "strategy_id": "strat_momentum",
  "bot_id": "bot_alpha",
  "notional": 2500
}
```

The webhook performs:

```text
request authentication
→ payload normalization
→ strategy and bot resolution
→ signal creation
→ risk evaluation
→ paper order
→ paper fill or approval queue
→ portfolio update
→ chained receipt
```

## Main APIs

```text
GET   /api/health
GET   /api/dashboard
GET   /api/state
GET   /api/markets
GET   /api/portfolio
GET   /api/strategies
POST  /api/strategies
PATCH /api/strategies/:id
GET   /api/bots
POST  /api/bots
PATCH /api/bots/:id
POST  /api/bots/:id/run
POST  /api/tradingview/webhook
GET   /api/alerts
GET   /api/orders
POST  /api/orders/:id/approve
GET   /api/fills
GET   /api/wallets
POST  /api/wallets
POST  /api/wallets/intents
GET   /api/connections
GET   /api/receipts
GET   /api/activity
PATCH /api/settings
```

## Environment

```text
PARALLAX_PLATFORM_HOST
PARALLAX_PLATFORM_PORT
PARALLAX_DATA_DIR
PARALLAX_TRADINGVIEW_TOKEN
PARALLAX_TRADINGVIEW_SECRET
PARALLAX_PUBLIC_ORIGINS
PARALLAX_SESSION_SECRET
```

## What is operational

The application is usable locally for creating strategies and bots, viewing TradingView charts, receiving authenticated TradingView alerts, executing governed paper workflows, approving larger paper orders, tracking positions, registering public wallet addresses, preparing unsigned intents, and reviewing receipts.

## Production boundary

This application does not claim a TradingView broker integration partnership. The embedded chart and webhook alert path are separate from TradingView's formal broker integration program.

The platform does not store private keys, seed phrases, or mnemonics. It does not sign mainnet transactions. It does not activate direct live broker execution, custody, public token sales, or autonomous mainnet trading.

Moving from paper operation to live execution requires broker-specific adapters, external secret storage, account authorization, idempotency, reconciliation, kill switches, monitoring, audit review, and an explicit operator-controlled promotion gate.
