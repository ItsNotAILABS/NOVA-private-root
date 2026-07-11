# NOVA Capsule Studio

NOVA Capsule Studio is the production app for live polyglot coding sessions.

It creates coding workspaces, runs supported languages, previews frontend websites, generates hash manifests, and deploys local static previews from a real browser UI.

## Run locally

```bash
cd apps/capsule-studio
npm start
```

Open:

```text
http://127.0.0.1:8787
```

## Run with Docker

```bash
cd apps/capsule-studio
docker compose up --build
```

Open:

```text
http://127.0.0.1:8787
```

## App capabilities

- Create workspaces from the browser.
- Generate Web and Python capsule projects.
- Run source files through the server runtime.
- Preview HTML projects.
- Generate manifests.
- Deploy local static websites under `/deployed/<workspace>/index.html`.
- Store workspace data under `.nova-capsule-studio` or `NOVA_CAPSULE_DATA`.

## API

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

## Supported language lanes

- Python
- MATLAB / Octave
- Java
- C
- C++
- JavaScript
- HTML / CSS / Frontend
- Rust
- Go

Runner availability depends on the host/container toolchain. Missing compilers are reported as runtime errors instead of being hidden.

## Production boundary

This app deploys locally and containerizes cleanly. Public cloud deployment is not claimed until the target environment is configured and the workflow runs against it.
