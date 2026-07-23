const DEFAULT_VERTICAL = 'general';

export const VERTICALS = {
  general: {
    id: 'general',
    name: 'General Agent Intelligence',
    audience: 'AI agents, independent builders, operators, and product teams',
    description: 'General public-signal routing for agents that need quick situational awareness without a subscription stack.',
    defaultSources: ['hackernews', 'github'],
    defaultRssUrls: [],
    promptHints: ['Summarize what changed', 'Find credible sources', 'Extract useful links'],
    scoringWeights: { freshness: 1, authority: 1, technical: 1, commercial: 1, scientific: 1 },
    outputSections: ['signals', 'why_it_matters', 'links', 'next_actions'],
    examples: ['AI agent pricing', 'new browser automation APIs', 'Cloudflare Workers tools']
  },
  business: {
    id: 'business',
    name: 'Business Intelligence',
    audience: 'founders, sales teams, operators, consultants, investors, and enterprise analysts',
    description: 'Market, competitor, customer, vendor, and GTM monitoring for business workflows.',
    defaultSources: ['github', 'hackernews', 'rss', 'web'],
    defaultRssUrls: [],
    promptHints: ['Track competitor movement', 'Find buying signals', 'Summarize market shifts', 'Prepare account briefs'],
    scoringWeights: { freshness: 1.3, authority: 1.1, technical: 0.8, commercial: 1.6, scientific: 0.5 },
    outputSections: ['market_signals', 'competitive_movement', 'customer_relevance', 'sales_or_operator_actions'],
    examples: ['construction technology procurement', 'AI agent platforms pricing', 'competitor launch monitoring']
  },
  physics: {
    id: 'physics',
    name: 'Physics and Research Intelligence',
    audience: 'researchers, science teams, physics students, technical founders, and lab operators',
    description: 'Scientific-signal routing for papers, lab notes, code repositories, public datasets, and research discussions.',
    defaultSources: ['github', 'rss', 'web'],
    defaultRssUrls: [],
    promptHints: ['Find methods and assumptions', 'Separate speculation from evidence', 'Extract equations and experimental claims'],
    scoringWeights: { freshness: 1, authority: 1.5, technical: 1.4, commercial: 0.4, scientific: 1.8 },
    outputSections: ['research_claims', 'methods', 'evidence_quality', 'open_questions', 'implementation_paths'],
    examples: ['fast radio bursts machine learning', 'WebGPU physics simulation', 'quantum error correction repositories']
  },
  compute: {
    id: 'compute',
    name: 'Compute and Infrastructure Intelligence',
    audience: 'developers, DevOps teams, platform engineers, AI labs, and CTOs',
    description: 'Infrastructure, runtime, benchmark, model-serving, edge-compute, and systems engineering signal routing.',
    defaultSources: ['github', 'hackernews', 'rss', 'web'],
    defaultRssUrls: [],
    promptHints: ['Identify implementation choices', 'Find benchmark evidence', 'Track runtime changes', 'Prepare migration notes'],
    scoringWeights: { freshness: 1.2, authority: 1.2, technical: 1.8, commercial: 0.8, scientific: 0.9 },
    outputSections: ['technical_signals', 'architecture_implications', 'benchmark_or_ci_evidence', 'migration_actions'],
    examples: ['Cloudflare Durable Objects', 'WebGPU inference', 'GitHub Actions CI failures']
  },
  enterprise: {
    id: 'enterprise',
    name: 'Enterprise Work Intelligence',
    audience: 'employees, managers, IT teams, legal/compliance teams, and enterprise AI platform teams',
    description: 'Company-safe public intelligence for employees and internal AI assistants without private-data scraping.',
    defaultSources: ['github', 'rss', 'web'],
    defaultRssUrls: [],
    promptHints: ['Prepare decision brief', 'Extract risks', 'Map vendor options', 'Keep compliance boundary explicit'],
    scoringWeights: { freshness: 1, authority: 1.5, technical: 1, commercial: 1.3, scientific: 0.7 },
    outputSections: ['executive_summary', 'risk_boundary', 'vendor_or_policy_impact', 'recommended_internal_actions'],
    examples: ['vendor risk monitoring', 'policy updates for AI use', 'enterprise browser security']
  },
  developer: {
    id: 'developer',
    name: 'Independent Developer Intelligence',
    audience: 'solo builders, indie hackers, open-source maintainers, and agent developers',
    description: 'Low-cost build intelligence for developers who need API-ready signals without buying a tool stack.',
    defaultSources: ['github', 'hackernews', 'rss'],
    defaultRssUrls: [],
    promptHints: ['Find implementation examples', 'Track issues and releases', 'Extract repo patterns', 'Generate build checklist'],
    scoringWeights: { freshness: 1.2, authority: 1, technical: 1.6, commercial: 1, scientific: 0.6 },
    outputSections: ['repos', 'implementation_patterns', 'risks', 'build_next_steps'],
    examples: ['MCP server examples', 'Cloudflare Worker API templates', 'agent tool manifests']
  },
  finance: {
    id: 'finance',
    name: 'Finance and Market Infrastructure Intelligence',
    audience: 'trading infra teams, fintech builders, treasury teams, and analysts',
    description: 'Public market-infrastructure, payments, crypto, risk, and fintech signal routing. Not investment advice.',
    defaultSources: ['github', 'rss', 'web'],
    defaultRssUrls: [],
    promptHints: ['Extract infrastructure changes', 'Separate public evidence from speculation', 'Track policy and risk'],
    scoringWeights: { freshness: 1.5, authority: 1.4, technical: 1.1, commercial: 1.3, scientific: 0.6 },
    outputSections: ['market_infrastructure_signals', 'risk_notes', 'technical_or_policy_change', 'operator_actions'],
    examples: ['stablecoin rails', 'market data APIs', 'clearinghouse automation']
  },
  construction: {
    id: 'construction',
    name: 'Construction and Field Operations Intelligence',
    audience: 'contractors, estimators, PMs, owners, suppliers, and construction operators',
    description: 'Public and operator-supplied signal routing for bids, vendors, materials, safety, scheduling, and field operations.',
    defaultSources: ['rss', 'web', 'github'],
    defaultRssUrls: [],
    promptHints: ['Find vendor signals', 'Summarize scope risk', 'Track materials and labor notes', 'Prepare operator brief'],
    scoringWeights: { freshness: 1.3, authority: 1.2, technical: 0.8, commercial: 1.6, scientific: 0.3 },
    outputSections: ['project_or_vendor_signals', 'cost_schedule_risk', 'field_actions', 'procurement_notes'],
    examples: ['hotel renovation vendors', 'demountable walls market', 'construction safety updates']
  }
};

export function normalizeVertical(value) {
  const key = String(value || DEFAULT_VERTICAL).toLowerCase().replace(/[^a-z0-9_-]/g, '');
  return VERTICALS[key] ? key : DEFAULT_VERTICAL;
}

export function getVertical(value) {
  return VERTICALS[normalizeVertical(value)];
}

export function listVerticals() {
  return Object.values(VERTICALS).map(({ id, name, audience, description, defaultSources, outputSections, examples }) => ({
    id,
    name,
    audience,
    description,
    defaultSources,
    outputSections,
    examples
  }));
}

function textSignals(entry) {
  const text = `${entry.title || ''} ${entry.text || ''} ${entry.url || ''}`.toLowerCase();
  return {
    freshness: entry.publishedAt ? 1 : 0,
    authority: /official|docs|documentation|github|arxiv|doi|sec|gov|cloudflare|research|standard/.test(text) ? 1 : 0,
    technical: /api|sdk|github|code|runtime|worker|benchmark|model|inference|ci|deploy|compute|system/.test(text) ? 1 : 0,
    commercial: /pricing|customer|market|sales|vendor|launch|contract|enterprise|business|revenue|subscription/.test(text) ? 1 : 0,
    scientific: /paper|physics|experiment|equation|simulation|dataset|research|arxiv|lab|measurement/.test(text) ? 1 : 0
  };
}

export function scoreForVertical(entry, verticalInput) {
  const vertical = getVertical(verticalInput);
  const signals = textSignals(entry);
  const weighted = Object.entries(vertical.scoringWeights).reduce((sum, [key, weight]) => sum + (signals[key] || 0) * weight, 0);
  return Number(((entry.score || 0) + weighted * 10).toFixed(4));
}

export function applyVerticalRanking(items = [], verticalInput = DEFAULT_VERTICAL, limit = 10) {
  const vertical = getVertical(verticalInput);
  return items
    .map((entry) => ({ ...entry, vertical: vertical.id, verticalScore: scoreForVertical(entry, vertical.id) }))
    .sort((a, b) => (b.verticalScore - a.verticalScore) || String(b.publishedAt || '').localeCompare(String(a.publishedAt || '')))
    .slice(0, limit);
}

export function buildVerticalBrief(query, items = [], verticalInput = DEFAULT_VERTICAL) {
  const vertical = getVertical(verticalInput);
  const top = items.slice(0, 8).map((entry, index) => ({
    rank: index + 1,
    source: entry.source,
    title: entry.title,
    url: entry.url,
    verticalScore: entry.verticalScore,
    signal: entry.text || entry.title
  }));
  const sections = Object.fromEntries(vertical.outputSections.map((section) => [section, []]));
  for (const entry of top) {
    const summary = `${entry.source}: ${entry.title}`;
    const target = vertical.outputSections[Math.min(top.indexOf(entry), vertical.outputSections.length - 1)] || 'signals';
    sections[target].push(summary);
  }
  return {
    schema: 'signallens.vertical_brief.v1',
    query: String(query || '').slice(0, 240),
    vertical: { id: vertical.id, name: vertical.name, audience: vertical.audience, description: vertical.description },
    totalItems: items.length,
    top,
    sections,
    promptHints: vertical.promptHints,
    summary: top.length ? `${vertical.name}: found ${items.length} ranked public signals for ${String(query || '').slice(0, 160)}.` : `${vertical.name}: no public signals found for ${String(query || '').slice(0, 160)}.`,
    boundary: 'Public or operator-supplied sources only; no login bypass, paywall bypass, private account access, or rate-limit evasion.'
  };
}
