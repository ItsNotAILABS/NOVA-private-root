# Capsule Studio Maturity Pass

This pass converts Capsule Studio from a working prototype app into a more maintainable production surface.

## Maturity goals

- Split the monolithic server into focused modules.
- Add workspace file APIs so generated apps can be edited inside the system.
- Add a template catalog instead of inline ad hoc files.
- Add audit logging for server, workspace, run, manifest, deploy, and AI events.
- Add stronger CI smoke tests that exercise the real product loop.
- Keep OpenAI server-side only.
- Preserve local fallback mode so demos do not dead-end when a key is not present.

## New server modules

```text
apps/capsule-studio/src/config.js
apps/capsule-studio/src/http.js
apps/capsule-studio/src/router.js
apps/capsule-studio/src/workspaceStore.js
apps/capsule-studio/src/templateCatalog.js
apps/capsule-studio/src/runner.js
apps/capsule-studio/src/manifest.js
apps/capsule-studio/src/deployment.js
apps/capsule-studio/src/openaiClient.js
apps/capsule-studio/src/aiBuilder.js
apps/capsule-studio/src/auditLog.js
```

## New API routes

```text
GET  /api/templates
GET  /api/audit?limit=100
GET  /api/workspace/files?workspaceId=...
GET  /api/workspace/file?workspaceId=...&file=...
PUT  /api/workspace/file
POST /api/ai/explain
```

Existing routes remain:

```text
GET  /api/health
GET  /api/languages
GET  /api/workspaces
POST /api/workspaces
POST /api/run
POST /api/manifest
POST /api/deploy/local
GET  /api/ai/status
POST /api/ai/build-app
GET  /preview/:workspaceId/:file
GET  /deployed/:workspaceId/:file
```

## UI upgrades

The browser app now has a real workspace editor:

- select a workspace
- list files
- open a file
- edit file content
- save file content
- run the active file
- deploy locally
- preview and open deployed apps
- show language and template catalogs

## CI upgrades

The smoke check now verifies:

- required modules exist
- server boots
- health endpoint returns AI status
- template catalog is available
- workspace creation works
- file listing works
- file reading works
- file saving works
- HTML preview run works
- AI builder fallback works without a key
- manifest generation works
- local deploy works
- audit events exist

## Security boundary

- `OPENAI_API_KEY` is never committed.
- Browser calls server routes only.
- OpenAI calls run server-side.
- Workspace paths are resolved through root-safe joins.
- File edits remain inside workspace boundaries.
