# PARALLAX Agentic Command Center

A local-first operator surface for the three-agent PARALLAX platform:

- `ARGOS-CLEAR` — clearing, settlement, receipts, proof room, tokenomics gates
- `NOVA-HFT` — market intelligence, strategy, signal, backtest, paper-order proposals
- `PLAX-SNS-GOV` — token law, governance proposals, upgrade boundaries, notary preparation

## Included surfaces

- command overview and market board
- portfolio and paper P&L
- AI agent creation dashboard
- strategy creation and deterministic backtest lane
- visual workflow composition
- governed paper-order ticket
- runtime tokenomics accounting
- governance decision console
- hash-chained receipt ledger
- three-repository federation configuration

## Run

```bash
cd apps/parallax-command-center
npm start
```

Open `http://127.0.0.1:8940`.

## Validate

```bash
npm run check
npm test
```

## Federation

Set these when the sibling runtimes expose reachable APIs:

```bash
PARALLAX_CLEARINGHOUSE_URL=http://127.0.0.1:8950
PARALLAX_HFT_URL=http://127.0.0.1:8951
PARALLAX_SNS_URL=http://127.0.0.1:8952
npm start
```

The command center reports configured federation endpoints through `/api/health`. Until those runtimes are reachable, this application operates as a persistent local paper/testnet command surface.

## API

```text
GET  /api/health
GET  /api/state
GET  /api/markets
GET  /api/agents
POST /api/agents
GET  /api/strategies
POST /api/strategies
GET  /api/workflows
POST /api/workflows
POST /api/orders
POST /api/backtests
POST /api/governance/evaluate
GET  /api/receipts
```

## Production boundary

The application is operational local software, but its financial execution boundary remains intentionally constrained:

- paper trading only
- testnet and internal-credit accounting only
- no private-key custody
- no broker routing
- no autonomous live trading
- no public token sale or redeemability claim
- no regulated fund, exchange, bank, broker, or custodian claim

The next deployment gate is to connect the three repo agents through authenticated runtime adapters and verify each external action with receipts.
