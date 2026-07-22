export const SOURCE_PRICES = {
  hackernews: { unit: 'request', amountUsd: 0, note: 'Public HN Algolia API. User pays Cloudflare compute only.' },
  github: { unit: 'request', amountUsd: 0, note: 'GitHub public Search API or operator-provided token. No token is embedded.' },
  rss: { unit: 'feed', amountUsd: 0, note: 'Public RSS/Atom feeds supplied by the operator or caller.' },
  web: { unit: 'request', amountUsd: 0, note: 'Metadata fetch only. No anti-bot bypass or authenticated scraping.' },
  bring_your_provider: { unit: 'provider_call', amountUsd: null, note: 'External provider cost is passed through from the provider quote.' }
};

export function quoteRequest({ sources = [], limit = 10, providerQuotes = [] } = {}) {
  const normalizedSources = [...new Set((sources.length ? sources : ['hackernews', 'github', 'rss']).map(String))];
  const internal = normalizedSources.map((source) => ({ source, ...(SOURCE_PRICES[source] || SOURCE_PRICES.bring_your_provider) }));
  const external = providerQuotes.map((quote) => ({
    provider: String(quote.provider || 'unknown'),
    endpoint: String(quote.endpoint || 'unknown'),
    amountUsd: Number(quote.amountUsd || 0),
    currency: String(quote.currency || 'USD')
  }));
  const externalUsd = external.reduce((sum, quote) => sum + quote.amountUsd, 0);
  return {
    schema: 'signallens.quote.v1',
    sources: internal,
    limit: Number(limit || 10),
    estimatedInternalUsd: 0,
    estimatedExternalUsd: Number(externalUsd.toFixed(6)),
    estimatedTotalUsd: Number(externalUsd.toFixed(6)),
    posture: 'pay-per-request-ready; no subscription required by SignalLens core',
    boundary: 'SignalLens does not bypass platform login, paywall, robots, or rate-limit controls.'
  };
}
