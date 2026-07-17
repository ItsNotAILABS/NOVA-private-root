# IDE, Browser AI, and App Platform Integration

This page defines how the model family connects to the current NOVA platform build.

## Surfaces

- NOVA IDE: `/ide`
- Browser AI: `/browser-ai` when present in platform branch
- App Platform APIs: `/api/apps`, `/api/ide/*`, `/api/browser-ai/*`, `/api/quality/*`, `/api/apps/package`
- Receipts: `/api/receipts`

## Integration map

| Surface | Model family owners |
|---|---|
| IDE workspace | CORPUS, CODEX, CREATIO |
| App generation | CREATIO, MATHESIS |
| Quality gate | MATHESIS, TEST/BENC, SACE |
| Browser page ingestion | SENSUS |
| Browser action planning | SENSUS, ORCHESTRA, SACE |
| Command runner boundary | CORPUS, SACE, MATHESIS |
| Release packaging | PORT, LAWX |
| Operator conversation | VOX, ORIGO |

## Runtime rule

The model family routes through surfaces. It should not blur planning, execution, and release. Planning can be model-driven. Execution must be bounded. Release must be auditable.

## Commercial requirement

The platform must always expose enough status for an operator to know: what exists, what ran, what failed, what is packaged, what is approved, and what is not yet released.