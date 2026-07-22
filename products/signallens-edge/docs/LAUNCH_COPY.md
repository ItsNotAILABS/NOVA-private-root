# SignalLens Edge Launch Copy

## One-line

AI agents should not need $199/month subscriptions to read the public web.

## Short post

We built SignalLens Edge: a Cloudflare Worker API that lets AI agents query public signals, receive a price quote, normalize results, generate a sourced brief, and emit a receipt.

No login bypass. No fake magic. No monthly subscription required by the core runtime.

It starts with Hacker News, GitHub, RSS/Atom, and explicit URL metadata. Provider adapters can be added later, but the product surface is already useful today for market research, launch monitoring, competitor tracking, and agent workflows.

```text
query -> quote -> execute -> normalize -> rank -> brief -> receipt
```

## Positioning

Monid routes paid tools. Apify sells actors and infrastructure. SignalLens Edge is the small, ownable agent-intelligence layer you can deploy to your own Cloudflare account and expose as an API.

## Demo prompt

```text
Find public signals about AI coding agents from Hacker News, GitHub, and these RSS feeds. Return the top 10, group by source, and give me a launch brief with citations and a receipt.
```

## Product boundary

SignalLens does not bypass logins, paywalls, private accounts, robots, or platform rate limits. It is a compliant public-source routing and briefing API.
