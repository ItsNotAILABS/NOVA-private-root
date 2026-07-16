# PARALLAX Ecosystem Runtime

The command center now acts as the control plane for four explicitly registered services:

1. PARALLAX Agentic Command Center
2. NOVA-HFT Runtime
3. ARGOS-CLEAR Clearinghouse
4. PLAX-SNS-GOV

## Runtime APIs

```text
GET  /api/ecosystem
GET  /api/ecosystem/status
POST /api/ecosystem/actions
```

`GET /api/ecosystem` returns the service registry and configured federation URLs.

`GET /api/ecosystem/status` performs bounded health probes against configured sibling runtimes.

`POST /api/ecosystem/actions` dispatches only allow-listed paper/testnet actions:

```text
hft.backtest.request
hft.signal.request
clearing.paper-settlement.request
sns.policy-evaluation.request
sns.proposal.request
```

## Authentication envelope

Set a shared secret on each runtime:

```bash
PARALLAX_FEDERATION_SECRET=replace-with-secret
```

Outbound requests carry:

```text
x-parallax-timestamp
x-parallax-signature
x-parallax-runtime
```

The signature is HMAC-SHA256 over:

```text
timestamp + "." + request-body
```

Sibling services must verify the signature, reject stale timestamps, and refuse actions outside their own allow-list.

## Configuration

```bash
PARALLAX_HFT_URL=http://127.0.0.1:8951
PARALLAX_CLEARINGHOUSE_URL=http://127.0.0.1:8950
PARALLAX_SNS_URL=http://127.0.0.1:8952
PARALLAX_FEDERATION_SECRET=local-shared-secret
npm start
```

## Boundary

The ecosystem transport is operational, but only paper/testnet actions are allowed. Live broker routing, custody, public token sales, mainnet autonomous trading, and regulated financial execution remain disabled deployment gates.
