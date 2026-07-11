# Capsule Studio AI App Builder

Capsule Studio is now the app you open and work inside. The OpenAI key is used by the server only. The browser never sees the key.

## Open the app

```bash
cd apps/capsule-studio
npm start
```

Open:

```text
http://127.0.0.1:8787
```

## Put the OpenAI key in the app

Create the local env file:

```bash
cd apps/capsule-studio
cp .env.example .env
```

Put the key in `.env`:

```text
OPENAI_API_KEY=sk-proj-your-key
OPENAI_MODEL=gpt-4.1-mini
```

Do not paste the key into chat and do not commit `.env`.

## Use it

1. Open Capsule Studio in the browser.
2. Find **AI App Builder**.
3. Type the app you want.
4. Click **Build App**.
5. Capsule Studio creates a workspace, writes files, deploys it locally, and opens the app.

## API routes

```text
GET  /api/ai/status
POST /api/ai/build-app
```

`POST /api/ai/build-app` body:

```json
{
  "prompt": "Build a polished dashboard for a construction company that tracks active projects, crews, revenue, and safety."
}
```

Result:

```json
{
  "ok": true,
  "workspace": {
    "id": "...",
    "preview": "/preview/.../index.html",
    "deployed": "/deployed/.../index.html"
  },
  "deployment": {
    "url": "/deployed/.../index.html"
  }
}
```

## Fallback mode

If `OPENAI_API_KEY` is missing, Capsule Studio still builds a local fallback app. This prevents demos from dead-ending while the key is being configured.

## Use cases now available

- Build landing pages from a prompt.
- Build dashboards from a prompt.
- Generate app prototypes while sitting with a user.
- Preview the app in the browser.
- Open the generated app on the phone through the Expo mobile lane.
- Generate hash manifests and local deployments.
