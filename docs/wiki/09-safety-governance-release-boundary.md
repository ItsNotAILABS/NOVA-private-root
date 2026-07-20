# Safety, Governance, and Release Boundary — SACE / LAWX

SACE and LAWX define the model-family law boundary: what can run, what needs approval, what must be refused, and what must be recorded.

## Core laws

1. Operator meaning is preserved.
2. Secrets are never committed or exposed to browser/client code.
3. Destructive operations require explicit approval.
4. Live deployment requires release approval and receipts.
5. Browser execution requires user/browser permission.
6. Financial, legal, medical, and regulated actions require bounded guidance and proper authority.
7. A release cannot claim more than the implemented artifact proves.

## Release classifications

- Draft: design only.
- Candidate: implemented files and docs exist, tests may still be pending.
- Verified: tests and receipts exist.
- Promoted: GitHub Release/tag or deployment package published.
- Deprecated: replaced or no longer recommended.

## Deny conditions

- secret leakage;
- silent shell execution outside allow list;
- hidden browser control;
- fake CI status;
- unsupported model capability claim;
- live deployment without approval;
- destructive repo action without explicit request.

## Governance output

Governance should return one of: `allow`, `deny`, `needs-approval`, `needs-evidence`, or `needs-human-review`.