# SNS---TOKEN Root Import Map

Status: internal feeder candidate  
Feeder repo: `ItsNotAILABS/SNS---TOKEN`  
Root repo: `ItsNotAILABS/NOVA-private-root`

## Purpose

This import map defines how the SNS/token repository can feed the NOVA root without collapsing repository boundaries.

The root should not blindly absorb token code, governance claims, or market language. It should receive structured, reviewable artifacts: manifests, safe docs, release receipts, governance summaries, and operator-ready maps.

## Importable artifacts

```text
bridge/feeder-manifest.json -> integrations/feeder-repos/sns-token/feeder-manifest.snapshot.json
bridge/ROOT_FEED_RECEIPT.md -> integrations/feeder-repos/sns-token/ROOT_FEED_RECEIPT.md
docs/public/* -> docs/integrations/sns-token/public/
docs/governance/* -> docs/integrations/sns-token/governance/
protocols/public/* -> protocols/feeder-imports/sns-token/public/
```

## Denied imports

```text
.env files
private keys
wallet seed phrases
unverified investment claims
promises of token value or profit
unguarded deployment scripts
unsafe cyber material
```

## Gate mapping

```text
GATE_IDENTITY   -> confirm feeder repo and branch
GATE_USER_LANE  -> founder/operator only until public package is approved
GATE_CAPABILITY -> restrict to manifest/docs/receipts/governance summaries
GATE_PROOF      -> require receipt before root accepts feed
GATE_CYBER      -> required if security, wallet, network, or key handling appears
```

## NOVA / CAIN / ORO route

```text
NOVA: registers the feeder and imports approved manifests.
CAIN: rejects unsafe token claims, secret exposure, and unsupported security claims.
ORO: turns approved artifacts into public docs, demo lanes, and operator handoff packages.
```

## Release posture

This feed is private/internal until the feeder repo has a public-safe package. Public language must avoid guaranteed returns, guaranteed governance outcomes, or claims that imply regulated financial advice.
