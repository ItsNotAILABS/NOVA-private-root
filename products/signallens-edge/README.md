# SignalLens Edge

**SignalLens Edge** is a Cloudflare Worker API that gives AI agents a pay-per-request public-source intelligence layer without forcing users into large monthly scraping subscriptions.

It is not a clone of Monid or Apify. It is a different product:

- It starts with public and operator-supplied sources.
- It normalizes results into one agent-ready format.
- It quotes cost before execution.
- It produces request receipts.
- It exposes an MCP/skill-style manifest.
- It specializes the same API for different work domains.
- It can be extended with paid providers later, but the core runtime does not require a subscription.

## No login bypass

SignalLens does **not** bypass logins, paywalls, robots, private accounts, platform rate limits, or anti-abuse systems. The value is routing, normalization, pricing, ranking, receipts, and agent usability across compliant sources.

## Cloudflare Worker endpoints

```text
GET  /health
GET  /v1/catalog
GET  /v1/verticals
GET  /mcp/manifest
POST /v1/quote
POST /v1/search
POST /v1/brief
POST /v1/vertical-brief
```

## Sources in v0.1

```text
hackernews  Public HN Algolia search
GitHub      Public GitHub Search API or operator-provided token
rss         Caller/operator supplied RSS and Atom feeds
web         Metadata fetch for explicit URLs only
```

## Specialized verticals

SignalLens can now run the same query through specialized agent modes:

```text
general       General agent intelligence
business      Market, competitor, customer, vendor, and GTM intelligence
physics       Research, lab, paper, dataset, and scientific evidence intelligence
compute       Runtime, benchmark, infrastructure, model-serving, and CI intelligence
enterprise    Company-safe public intelligence for employees and internal assistants
developer     Build intelligence for independent developers and open-source maintainers
finance       Market infrastructure, fintech, payment rails, risk, and policy signals
construction  Vendor, material, safety, bid, schedule, and field-operations signals
```

See `docs/VERTICALS.md` for the vertical program.

## Example request

```bash
curl -s https://YOUR-WORKER.workers.dev/v1/vertical-brief \
  -H 'content-type: application/json' \
  -H 'authorization: Bearer YOUR_SIGNALLENS_TOKEN' \
  -d '{
    "query": "AI coding agents",
    "vertical": "developer",
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
query -> vertical -> quote -> execute -> normalize -> vertical-rank -> brief -> receipt
```

This makes it useful for:

- founder market research
- sales and account intelligence
- scientific and physics research assistants
- compute and infrastructure teams
- enterprise internal AI assistants
- independent developer workflows
- finance infrastructure monitoring
- construction field and procurement intelligence
- competitor tracking
- launch monitoring
- repo/product discovery

## Boundary

The runtime can read public sources and operator-provided feeds. It can produce specialized briefs and receipts. It cannot guarantee access to every platform, cannot impersonate users, cannot provide regulated financial advice, and cannot perform unrestricted scraping.
