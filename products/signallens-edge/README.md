# SignalLens Edge

**SignalLens Edge** is a Cloudflare Worker API that gives AI agents a pay-per-request public-source intelligence layer without forcing users into large monthly scraping subscriptions.

It is not a clone of Monid or Apify. It is a different product:

- It starts with public and operator-supplied sources.
- It normalizes results into one agent-ready format.
- It quotes cost before execution.
- It produces request receipts.
- It exposes an MCP/skill-style manifest.
- It can be extended with paid providers later, but the core runtime does not require a subscription.

## No login bypass

SignalLens does **not** bypass logins, paywalls, robots, private accounts, platform rate limits, or anti-abuse systems. The value is routing, normalization, pricing, caching posture, receipts, and agent usability across compliant sources.

## Cloudflare Worker endpoints

```text
GET  /health
GET  /v1/catalog
GET  /mcp/manifest
POST /v1/quote
POST /v1/search
POST /v1/brief
```

## Sources in v0.1

```text
hackernews  Public HN Algolia search
GitHub      Public GitHub Search API or operator-provided token
rss         Caller/operator supplied RSS and Atom feeds
web         Metadata fetch for explicit URLs only
```

## Example request

```bash
curl -s https://YOUR-WORKER.workers.dev/v1/brief \
  -H 'content-type: application/json' \
  -H 'authorization: Bearer YOUR_SIGNALLENS_TOKEN' \
  -d '{
    "query": "AI coding agents",
    "sources": ["hackernews", "github", "rss"],
    "rssUrls": ["https://hnrss.org/frontpage"],
    "limit": 10
  }'
```

## Deploy

```bash
cd products/signallens-edge
npm test
npm run validate
wrangler secret put SIGNALLENS_TOKEN
wrangler secret put GITHUB_TOKEN
wrangler deploy --config wrangler.toml.example
```

## Market position

Subscription tools sell monthly access. SignalLens sells agent-ready intelligence calls:

```text
query -> quote -> execute -> normalize -> rank -> brief -> receipt
```

This makes it useful for:

- founder market research
- AI-agent trend briefs
- competitor tracking
- launch monitoring
- repo/product discovery
- sales and content research
- internal agent workflows

## Boundary

The runtime can read public sources and operator-provided feeds. It can produce briefs and receipts. It cannot guarantee access to every platform, cannot impersonate users, and cannot perform unrestricted scraping.
