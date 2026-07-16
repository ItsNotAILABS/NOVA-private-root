# PARALLAX TradingView, MCP, Bots, and Wallet Platform

PARALLAX now exposes an operational paper/testnet integration layer for experienced traders to create bots, receive TradingView alerts, invoke the platform through MCP clients, register public wallet addresses, and prepare externally signed transaction intents.

## TradingView webhook

Start the platform with at least one authentication mechanism:

```bash
PARALLAX_TRADINGVIEW_TOKEN=replace-me npm start
```

TradingView webhook URL:

```text
POST http://HOST:8940/api/tradingview/webhook
```

Header:

```text
x-parallax-webhook-token: replace-me
```

Example alert JSON:

```json
{
  "alert_id": "btc-15m-001",
  "symbol": "BTC-USD",
  "action": "buy",
  "price": 64120.5,
  "notional": 2500,
  "strategy_id": "strategy_momentum_alpha",
  "bot_id": "bot_optional",
  "timeframe": "15m"
}
```

The webhook validates the request, normalizes the alert, persists it, routes it into the signal/risk/order/clearing workflow, and writes a chained receipt. It does not submit live broker orders.

An alternative HMAC signature can be sent through `x-parallax-signature`, generated with `PARALLAX_TRADINGVIEW_SECRET` over the exact raw request body.

## Bot factory

```text
GET   /api/bots
POST  /api/bots
PATCH /api/bots/:id
```

Example:

```json
{
  "name": "BTC Momentum Desk",
  "trigger": "tradingview",
  "strategy_id": "strategy_momentum_alpha",
  "symbols": ["BTC-USD"],
  "default_notional": 2500,
  "actions": ["request-signal", "evaluate-risk", "propose-paper-order"],
  "mode": "paper"
}
```

## MCP server

Run the command center first, then start the stdio MCP server:

```bash
npm start
npm run mcp
```

Optional:

```bash
PARALLAX_URL=http://127.0.0.1:8940 npm run mcp
```

Published tools:

- `parallax_health`
- `list_agents`
- `create_bot`
- `run_automation`
- `register_wallet`
- `create_wallet_intent`
- `ecosystem_status`

## Wallet registry

```text
GET  /api/wallets
POST /api/wallets
POST /api/wallets/intents
```

Only public addresses and metadata are stored. Private keys, mnemonics, and seed phrases are rejected.

Example registration:

```json
{
  "name": "ICP Test Wallet",
  "network": "internet-computer",
  "address": "public-address-only",
  "environment": "testnet"
}
```

Transaction intents are unsigned preparation records that always require external signing and human approval. Mainnet submission and custody remain disabled.

## Current execution boundary

Operational now:

- authenticated TradingView alert ingestion
- bot and agent configuration
- deterministic signal and risk workflows
- paper-order and simulated settlement flows
- MCP tool access
- public-address wallet registry
- testnet/paper transaction-intent preparation
- chained receipts and persisted state

Not activated:

- private-key custody
- seed storage
- direct live broker routing
- automatic mainnet wallet signing
- public token sale
- autonomous live trading

Those require broker-specific adapters, user credentials stored in an external secret manager, deployment security, audit logs, account-level permissions, and explicit live-trading approval gates.
