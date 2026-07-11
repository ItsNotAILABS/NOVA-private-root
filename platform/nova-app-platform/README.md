# NOVA App Platform

A local-first platform shell for NOVA applications.

This is not just an API key wrapper. It is the platform layer that hosts app registration, operator access, OpenAI gateway calls, local vault storage, receipts, and a browser console.

## Surfaces

- Operator console at `http://127.0.0.1:8899`
- Public health check: `/api/health`
- App registry: `/api/apps`
- Dashboard contract: `/api/dashboard`
- Operator write route: `/api/operator/register-app`
- Receipt route: `/api/operator/receipt`
- OpenAI gateway route: `/api/ai/respond`

## Local start

```bash
cd platform/nova-app-platform
npm install
npm test
npm start
```

Open:

```text
http://127.0.0.1:8899
```

## Environment

```bash
OPENAI_API_KEY=your_openai_key
NOVA_OPERATOR_TOKEN=change_this_local_operator_token
NOVA_OPENAI_MODEL=gpt-5.5
NOVA_PLATFORM_PORT=8899
```

The OpenAI key stays server-side. The browser never receives the key.

## Boundary

- No client-side API keys.
- Operator token required for write and AI routes.
- Receipts are produced for operator events and AI calls.
- Live deploy lanes are disabled by default.
- Local vault writes go under `.nova-platform-vault` unless `NOVA_PLATFORM_VAULT` is set.
