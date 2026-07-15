# SNS---TOKEN Root Feed Receipt

Receipt type: `nova.root-feeder.receipt.v1`  
Root repo: `ItsNotAILABS/NOVA-private-root`  
Feeder repo: `ItsNotAILABS/SNS---TOKEN`  
Status: feeder candidate registered

## Registered facts

- The SNS/token repo is available to the GitHub connector.
- The NOVA root repo is the canonical system spine.
- This receipt does not import runtime token code.
- This receipt only establishes the feed contract and review path.

## Root artifacts added

```text
integrations/feeder-repos/README.md
integrations/feeder-repos/root-feeder-registry.json
integrations/feeder-repos/sns-token/ROOT_IMPORT_MAP.md
integrations/feeder-repos/sns-token/ROOT_FEED_RECEIPT.md
```

## Decision

```json
{
  "decision": "allow_feeder_registration",
  "runtimeImport": false,
  "requiresFeederManifest": true,
  "requiresPublicSafeReview": true,
  "requiresSecretScanBeforeRuntimeImport": true
}
```

## Boundary

No token value claims, investment claims, secret material, wallet keys, or unguarded deployment scripts are accepted into root.
