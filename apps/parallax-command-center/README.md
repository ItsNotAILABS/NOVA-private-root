# PARALLAX Agentic Command Center

PARALLAX is a local-first agentic trading operations platform for designing strategies, creating AI agents, running governed automation workflows, producing paper-market decisions, clearing simulated fills, and recording tamper-evident receipts.

The command center coordinates three runtime agents:

- `NOVA-HFT` — market interpretation, strategy selection, signal generation, backtests, and paper-order proposals.
- `ARGOS-CLEAR` — risk-aware clearing, simulated fills, receipt chaining, settlement records, and runtime accounting.
- `PLAX-SNS-GOV` — token-policy boundaries, governance review, proposal control, and notary preparation.

## Operational application surfaces

- command overview and market board
- portfolio and paper P&L
- AI agent creation dashboard
- strategy creation and deterministic backtesting
- workflow composition
- automated signal-to-receipt execution
- governed paper-order ticket
- human approval lane for larger notionals
- runtime tokenomics accounting
- governance decision console
- hash-chained receipt ledger
- three-repository federation configuration

## Working automation loop

The application now executes the complete bounded workflow instead of only storing workflow definitions:

```text
market snapshot
→ NOVA-HFT signal evaluation
→ strategy and notional risk evaluation
→ paper-order creation or denial
→ optional human approval
→ ARGOS-CLEAR simulated fill
→ receipt-chain append
→ PXAI / PXGPU / PXCRED / PXBYTE / PXNOVA / PXRCPT accounting
```

Run one workflow:

```bash
curl -X POST http://127.0.0.1:8940/api/automation/run \
  -H "content-type: application/json" \
  -d '{"strategy_id":"strategy_momentum_alpha","symbol":"BTC-USD","notional":10000,"mode":"paper"}'
```

The result contains the generated signal, risk decision, paper order, optional simulated fill, participating agents, completed stages, runtime status, token accounting, and receipt hash.

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

The smoke test boots the application, creates a strategy, runs the three-agent automation workflow, verifies receipt creation, confirms order-notional enforcement, and confirms live-mode rejection.

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
GET  /api/automation/runs
POST /api/automation/run
POST /api/orders
POST /api/orders/:id/approve
POST /api/backtests
POST /api/governance/evaluate
GET  /api/receipts
```

## Federation

Set these variables when sibling runtimes expose reachable authenticated APIs:

```bash
PARALLAX_CLEARINGHOUSE_URL=http://127.0.0.1:8950
PARALLAX_HFT_URL=http://127.0.0.1:8951
PARALLAX_SNS_URL=http://127.0.0.1:8952
npm start
```

The command center remains the operator-level orchestration surface. The Clearinghouse repo is the settlement and proof authority, the AIHFT repo is the strategy and market-runtime lane, and SNS---TOKEN is the governance and token-law lane.

## Release status

Implemented and locally executable:

- persistent agent, strategy, workflow, order, fill, and receipt state
- deterministic signal agent
- governance-aware risk agent
- paper-order construction
- approval threshold routing
- paper-ledger clearing
- receipt-chain verification
- runtime accounting
- API and browser dashboard

Still requiring external integration and audited deployment work:

- authenticated federation adapters between the three repositories
- live market-data adapter verification
- broker sandbox adapters
- exchange-specific paper accounts
- identity and tenant separation
- secrets management
- observability and alerting
- backup and recovery
- legal and compliance review before any live financial activity

## Hard production boundary

This code does not activate or claim:

- private-key custody
- live broker routing
- autonomous live trading
- public token sales or redeemability
- regulated exchange, fund, broker, bank, or custodian operation
- guaranteed trading returns

The release target is a professional agentic paper-trading and research platform first. Live financial execution remains a separately authorized, integrated, tested, and audited gate.
