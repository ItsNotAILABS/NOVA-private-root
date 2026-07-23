# SignalLens Edge Launch Copy

## One-line

AI agents should not need $199/month subscriptions or one-size-fits-all search pipes to read public signals.

## Short post

We built SignalLens Edge: a Cloudflare Worker API that lets AI agents query public signals, receive a price quote, normalize results, generate a specialized sourced brief, and emit a receipt.

No login bypass. No fake magic. No monthly subscription required by the core runtime.

It starts with Hacker News, GitHub, RSS/Atom, and explicit URL metadata. Provider adapters can be added later, but the product surface is already useful today for market research, launch monitoring, competitor tracking, research workflows, enterprise assistants, compute teams, construction operators, and independent developers.

```text
query -> vertical -> quote -> execute -> normalize -> vertical-rank -> brief -> receipt
```

## Vertical post

Generic search is not enough for AI agents.

A founder, a physicist, a platform engineer, a construction PM, a finance infrastructure analyst, and an enterprise employee do not need the same brief.

SignalLens Edge now ships vertical modes:

```text
business
physics
compute
enterprise
developer
finance
construction
general
```

Same API. Different ranking, source posture, brief shape, and next-action framing.

## Positioning

Monid routes paid tools. Apify sells actors and infrastructure. SignalLens Edge is the small, ownable agent-intelligence layer you can deploy to your own Cloudflare account and expose as an API.

## Demo prompts

```text
Business: Find public signals about AI-agent pricing and give me competitive movement, customer relevance, and sales actions.
```

```text
Physics: Find public signals about WebGPU physics simulation and separate methods, evidence quality, and open questions.
```

```text
Compute: Find public signals about Cloudflare Durable Objects for AI agents and return architecture implications and migration actions.
```

```text
Construction: Find public signals about hotel renovation vendors and summarize cost, schedule, and procurement risk.
```

## Product boundary

SignalLens does not bypass logins, paywalls, private accounts, robots, or platform rate limits. It is a compliant public-source routing, specialization, and briefing API.
