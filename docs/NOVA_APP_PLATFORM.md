# NOVA App Platform

The NOVA App Platform is the first application platform layer for NOVA. It turns an OpenAI Platform key into a controlled application substrate instead of leaving the key as an isolated credential.

## Platform contract

The platform provides:

- App registry for NOVA applications.
- Operator console for local management.
- Server-side OpenAI gateway.
- Local vault storage.
- Receipt stream for auditability.
- Token-gated operator write routes.
- Deployment-lane placeholders for ICP and edge targets.

## Runtime

```bash
cd platform/nova-app-platform
npm install
npm test
npm start
```

Default URL:

```text
http://127.0.0.1:8899
```

## Required production environment

```text
OPENAI_API_KEY
NOVA_OPERATOR_TOKEN
NOVA_PLATFORM_VAULT
NOVA_OPENAI_MODEL
```

## Security boundary

The browser shell calls the local platform server. The OpenAI key stays in the server process only. Operator write routes require the `x-nova-operator-token` header. The default local token is for development and must be changed before deployment.

## Next integration lanes

1. Add real user accounts and sessions.
2. Add persistent SQLite or ICP-backed storage.
3. Connect NOVA Agent Council tools.
4. Add app-builder flow for generating new apps.
5. Add deployment adapter for ICP canisters.
6. Add deployment adapter for edge workers.
7. Add platform logs and admin audit dashboard.
