# NOVA IDE and App Factory Runtime

This build turns the NOVA App Platform into a local-first IDE and app factory surface.

## Operator surfaces

- `/ide` opens the browser IDE.
- `/api/ide/status` reports IDE runtime health, commercial controls, templates, lanes, and workspace count.
- `/api/ide/workspaces` lists workspaces.
- `/api/ide/workspace/:id/files` lists workspace files.
- `/api/ide/workspace/:id/file?file=path` reads a file.
- `PUT /api/ide/workspace/:id/file` writes a file and requires operator auth.
- `POST /api/apps/generate` builds a working app from prompt and requires operator auth.
- `GET /api/apps/templates` lists app templates.
- `GET /api/ide/commands` lists allow-listed command boundary actions.
- `POST /api/ide/workspace/:id/run` runs an allow-listed validation command with timeout, output capture, output hashing, audit, and receipt emission.
- `POST /api/quality/check-workspace` runs the production gate.
- `POST /api/apps/package` prepares a deployment manifest and requires operator auth.
- `POST /api/commercial/readiness` scores the workspace against commercial readiness controls.
- `GET /api/ide/audit` returns the audit trail and requires operator auth.

## Runtime modules

- `FileSystemVault` provides safe workspace file storage under the NOVA platform vault.
- `WorkspaceManager` creates, hydrates, lists, reads, writes, and hashes workspaces.
- `AppFactory` generates runnable apps with manifest, README, entrypoint, styles/scripts, and tests.
- `QualityGate` rejects missing manifests, missing README files, missing runnable entrypoints, missing tests, and likely secrets.
- `CommandRunnerBoundary` runs only allow-listed validation commands, never arbitrary shell input.
- `AuditLog` writes hash-chained audit events for runtime, workspace, file, generation, command, package, and readiness activity.
- `CommercialReadinessGate` combines quality, docs, command-run evidence, package manifests, and secret scanning into a commercial-grade score.
- `DeploymentPlanner` creates package manifests for local preview, static export, PWA export, extension packaging, node service packaging, ICP package preparation, and NOVA capsules.
- `NovaIDERuntime` orchestrates the workspace manager, app factory, quality gate, deployment planner, command runner, audit log, readiness gate, and receipt emission.

## Commercial controls

Commercial grade means the IDE has explicit controls before it claims an app is ready:

- operator-authenticated write/generate/run/package/audit routes
- bounded local file writes
- safe path validation
- secret scanning
- manifest and README requirements
- runnable entrypoint requirement
- validation test requirement
- allow-listed command runner only
- timeout-killed command execution
- captured stdout/stderr with output hashes
- package manifest hash
- commercial readiness report hash
- hash-chained receipts and audit records

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
- command runs
- workspace packaging
- commercial readiness checks

The receipt chain stays in the platform vault through the existing receipt writer.

## Boundaries

- The IDE writes files into local vault workspaces only.
- The app factory creates runnable source files, not live deployments.
- The command runner runs allow-listed validations only; there is no arbitrary shell prompt.
- The deployment planner creates manifests and packages, but live deployment lanes remain behind operator approval.
- No browser/client code receives `OPENAI_API_KEY`.

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

Default local operator token unless overridden:

```text
local-operator-token
```

## Definition of done for this phase

- Create a workspace.
- Generate a working app.
- Edit files.
- Run the quality gate.
- Run an allow-listed validation command.
- Prepare a package manifest.
- Produce a commercial readiness score.
- Emit receipts and audit records.
