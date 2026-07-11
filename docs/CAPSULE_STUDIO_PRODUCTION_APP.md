# Capsule Studio Production App

Capsule Studio is the production application surface for the NOVA polyglot coding capsule.

The previous capsule layer established the runtime foundation. This app turns it into an actual product surface with a web UI, server API, local deployment path, Docker runtime, and CI.

## App path

```text
apps/capsule-studio
```

## Start commands

Local:

```bash
cd apps/capsule-studio
npm start
```

Docker:

```bash
cd apps/capsule-studio
docker compose up --build
```

## Open

```text
http://127.0.0.1:8787
```

## Product flows

1. Create workspace.
2. Select project type.
3. Run source file.
4. Preview frontend artifact.
5. Generate manifest.
6. Deploy local static output.
7. Use Docker for repeatable runtime.

## Runtime routes

```text
GET  /api/health
GET  /api/languages
GET  /api/workspaces
POST /api/workspaces
POST /api/run
POST /api/manifest
POST /api/deploy/local
GET  /preview/:workspaceId/:file
GET  /deployed/:workspaceId/:file
```

## CI

Workflow:

```text
.github/workflows/capsule-studio.yml
```

It runs:

```bash
npm run check
docker build -f apps/capsule-studio/Dockerfile -t nova-capsule-studio:ci .
```

## Production boundary

This is a real runnable app with local deployment and containerized runtime. External public deployment requires a configured target such as a server, Pages, Cloudflare, Fly, Render, Railway, Kubernetes, or an internal Medina runtime. The app is ready for that next target-specific deployment step.
