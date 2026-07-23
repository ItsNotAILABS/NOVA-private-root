# SignalLens Edge Vertical Specialization

SignalLens Edge is now designed as a vertical intelligence router, not only a general public-source search API. The same deployed Cloudflare Worker can serve different agent modes for businesses, scientific teams, compute teams, independent developers, construction operators, finance infrastructure teams, and enterprise employees.

## Shared operating model

```text
query + vertical -> source policy -> public-source retrieval -> normalization -> vertical ranking -> specialized brief -> receipt
```

Every vertical keeps the same safety boundary:

- Public or operator-supplied sources only.
- No login bypass.
- No paywall bypass.
- No private account scraping.
- No platform rate-limit evasion.
- No hidden provider secrets in source code.

## API additions

```text
GET  /v1/verticals
POST /v1/vertical-brief
```

Existing endpoints now accept an optional `vertical` field:

```json
{
  "query": "Cloudflare Workers agent APIs",
  "vertical": "compute",
  "limit": 10,
  "sources": ["github", "hackernews", "rss", "web"]
}
```

## Verticals

### Business Intelligence

For founders, sales teams, operators, consultants, investors, and enterprise analysts.

Use cases:

- Market monitoring.
- Competitor movement.
- Vendor intelligence.
- GTM and customer signal briefs.
- Account preparation for sales or consulting.

Output sections:

```text
market_signals
competitive_movement
customer_relevance
sales_or_operator_actions
```

### Physics and Research Intelligence

For researchers, science teams, physics students, technical founders, and lab operators.

Use cases:

- Track public research signals.
- Find methods, assumptions, and evidence quality.
- Route paper/code/dataset links into an agent workflow.
- Separate speculation from experimental claims.

Output sections:

```text
research_claims
methods
evidence_quality
open_questions
implementation_paths
```

### Compute and Infrastructure Intelligence

For developers, DevOps teams, platform engineers, AI labs, and CTOs.

Use cases:

- Runtime and infrastructure monitoring.
- Benchmark and CI signal aggregation.
- Model-serving and edge-compute tracking.
- Migration and implementation brief generation.

Output sections:

```text
technical_signals
architecture_implications
benchmark_or_ci_evidence
migration_actions
```

### Enterprise Work Intelligence

For employees, managers, IT teams, compliance teams, and enterprise AI platform teams.

Use cases:

- Internal AI assistant enrichment from public sources.
- Vendor and risk monitoring.
- Policy and security update briefs.
- Decision support without private-data scraping.

Output sections:

```text
executive_summary
risk_boundary
vendor_or_policy_impact
recommended_internal_actions
```

### Independent Developer Intelligence

For solo builders, indie hackers, open-source maintainers, and agent developers.

Use cases:

- Find implementation examples.
- Track open-source releases.
- Extract build patterns.
- Generate practical next steps for a project.

Output sections:

```text
repos
implementation_patterns
risks
build_next_steps
```

### Finance and Market Infrastructure Intelligence

For trading infrastructure teams, fintech builders, treasury teams, and analysts.

Use cases:

- Market infrastructure signal routing.
- Payment rail and stablecoin infrastructure monitoring.
- Risk, policy, and technical change briefs.
- Fintech API and repo tracking.

Boundary: this vertical is for public infrastructure intelligence, not financial advice.

Output sections:

```text
market_infrastructure_signals
risk_notes
technical_or_policy_change
operator_actions
```

### Construction and Field Operations Intelligence

For contractors, estimators, PMs, owners, suppliers, and construction operators.

Use cases:

- Vendor and material signals.
- Bid and procurement context.
- Safety and field operations updates.
- Project-risk summaries from operator-supplied URLs and feeds.

Output sections:

```text
project_or_vendor_signals
cost_schedule_risk
field_actions
procurement_notes
```

## Agent positioning

SignalLens can now be marketed as a specialization layer for any AI agent:

```text
Agents do not need one generic search pipe.
They need task-aware intelligence modes.
SignalLens gives the same API business mode, physics mode, compute mode, enterprise mode, developer mode, finance mode, and construction mode.
```

## Deployment posture

The product remains Cloudflare-native. One Worker can expose the general API and all vertical modes. The owner can deploy it once, attach a token, meter usage upstream, and sell it as a domain-specific API product.
