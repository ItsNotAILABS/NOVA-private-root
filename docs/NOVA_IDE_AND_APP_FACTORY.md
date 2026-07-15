# NOVA IDE and App Factory Runtime

This build turns the NOVA App Platform into a local-first IDE and app factory surface.

## Operator surfaces

- `/ide` opens the browser IDE.
- `/api/ide/status` reports IDE runtime health, templates, lanes, and workspace count.
- `/api/ide/workspaces` lists workspaces.
- `/api/ide/workspace/:id/files` lists workspace files.
- `/api/ide/workspace/:id/file?file=path` reads a file.
- `PUT /api/ide/workspace/:id/file` writes a file.
- `POST /api/apps/generate` builds a working app from prompt.
- `GET /api/apps/templates` lists app templates.
- `POST /api/quality/check-workspace` runs the production gate.
- `POST /api/apps/package` prepares a deployment manifest.

## Runtime modules

- `FileSystemVault` provides safe workspace file storage under the NOVA platform vault.
- `WorkspaceManager` creates, hydrates, lists, reads, writes, and hashes workspaces.
- `AppFactory` generates runnable apps with manifest, README, entrypoint, styles/scripts, and tests.
- `QualityGate` rejects missing manifests, missing README files, missing runnable entrypoints, missing tests, and likely secrets.
- `DeploymentPlanner` creates package manifests for local preview, static export, PWA export, extension packaging, node service packaging, ICP package preparation, and NOVA capsules.
- `NovaIDERuntime` orchestrates the workspace manager, app factory, quality gate, deployment planner, and receipt emission.

## App classes

Current generation templates:

- static web app
- dashboard app
- browser extension app
- Node service app
- agent tool app

## Receipts

The IDE emits receipts for:

- workspace creation
- file saves
- app generation
- quality checks
- workspace packaging

The receipt chain stays in the platform vault through the existing receipt writer.

## Boundaries

- The IDE writes files into local vault workspaces only.
- The app factory creates runnable source files, not live deployments.
- The deployment planner creates manifests and packages, but live deployment lanes remain behind operator approval.
- No browser/client code receives `OPENAI_API_KEY`.
- Shell/build execution is intentionally not added here; the next phase should add a command runner boundary with allow-listed commands, timeouts, receipts, and output capture.

## Local run

```bash
cd platform/nova-app-platform
npm install
npm test
npm start
```

Open:

```text
http://127.0.0.1:8899/ide
```

## Definition of done for this phase

- Create a workspace.
- Generate a working app.
- Edit files.
- Run the quality gate.
- Prepare a package manifest.
- Emit receipts.
