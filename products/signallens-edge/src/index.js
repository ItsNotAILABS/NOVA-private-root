import { buildBrief, fetchWebMetadata, normalizeLimit, normalizeQuery, rankAndDedupe, searchGitHub, searchHackerNews, searchRss, sha256 } from './adapters.js';
import { quoteRequest, SOURCE_PRICES } from './pricing.js';

const JSON_HEADERS = { 'content-type': 'application/json; charset=utf-8', 'cache-control': 'no-store' };
const CORS_HEADERS = {
  'access-control-allow-origin': '*',
  'access-control-allow-methods': 'GET,POST,OPTIONS',
  'access-control-allow-headers': 'content-type,authorization,x-signallens-token,x-signallens-actor'
};
const MAX_BODY_BYTES = 96 * 1024;

function json(body, status = 200) {
  return new Response(JSON.stringify(body, null, 2), { status, headers: { ...JSON_HEADERS, ...CORS_HEADERS } });
}

async function readJson(request) {
  const declared = Number(request.headers.get('content-length') || 0);
  if (declared > MAX_BODY_BYTES) throw Object.assign(new Error('body_too_large'), { status: 413 });
  const text = await request.text();
  if (!text.trim()) return {};
  if (new TextEncoder().encode(text).byteLength > MAX_BODY_BYTES) throw Object.assign(new Error('body_too_large'), { status: 413 });
  try { return JSON.parse(text); } catch { throw Object.assign(new Error('invalid_json'), { status: 400 }); }
}

function requireToken(request, env) {
  const expected = env.SIGNALLENS_TOKEN;
  if (!expected) return { ok: true, actor: 'local-dev' };
  const token = request.headers.get('authorization')?.replace(/^Bearer\s+/i, '') || request.headers.get('x-signallens-token');
  if (token !== expected) return { ok: false, response: json({ ok: false, error: 'unauthorized' }, 401) };
  return { ok: true, actor: request.headers.get('x-signallens-actor') || 'operator' };
}

function catalog() {
  return {
    ok: true,
    schema: 'signallens.catalog.v1',
    product: 'SignalLens Edge',
    tagline: 'Pay-per-request public-source intelligence API for AI agents.',
    tools: [
      { name: 'quote', method: 'POST', path: '/v1/quote', description: 'Estimate request cost before execution.' },
      { name: 'search_public_signals', method: 'POST', path: '/v1/search', description: 'Search and normalize public or operator-supplied sources.' },
      { name: 'brief_public_signals', method: 'POST', path: '/v1/brief', description: 'Return ranked items plus a sourced brief.' },
      { name: 'mcp_manifest', method: 'GET', path: '/mcp/manifest', description: 'Expose agent-tool metadata for MCP/skill clients.' }
    ],
    sources: SOURCE_PRICES,
    boundary: 'SignalLens does not bypass logins, paywalls, robots, platform rate limits, or private data boundaries.'
  };
}

function mcpManifest(request) {
  const origin = new URL(request.url).origin;
  return {
    schema: 'signallens.mcp_manifest.v1',
    name: 'SignalLens Edge',
    description: 'Agent-ready public-source intelligence router with quotes, receipts, normalized results, and briefs.',
    baseUrl: origin,
    tools: [
      {
        name: 'signallens_quote',
        endpoint: `${origin}/v1/quote`,
        inputSchema: { type: 'object', properties: { sources: { type: 'array', items: { type: 'string' } }, limit: { type: 'number' } } }
      },
      {
        name: 'signallens_search',
        endpoint: `${origin}/v1/search`,
        inputSchema: { type: 'object', required: ['query'], properties: { query: { type: 'string' }, sources: { type: 'array', items: { type: 'string' } }, limit: { type: 'number' }, rssUrls: { type: 'array', items: { type: 'string' } }, urls: { type: 'array', items: { type: 'string' } } } }
      },
      {
        name: 'signallens_brief',
        endpoint: `${origin}/v1/brief`,
        inputSchema: { type: 'object', required: ['query'], properties: { query: { type: 'string' }, sources: { type: 'array', items: { type: 'string' } }, limit: { type: 'number' }, rssUrls: { type: 'array', items: { type: 'string' } }, urls: { type: 'array', items: { type: 'string' } } } }
      }
    ]
  };
}

async function runSearch(body, env, fetcher = fetch) {
  const query = normalizeQuery(body.query);
  if (!query && !Array.isArray(body.urls)) throw Object.assign(new Error('query_required'), { status: 400 });
  const limit = normalizeLimit(body.limit || 10);
  const sources = [...new Set((Array.isArray(body.sources) && body.sources.length ? body.sources : ['hackernews', 'github']).map(String))];
  const groups = [];
  if (sources.includes('hackernews')) groups.push(await searchHackerNews(fetcher, query, limit));
  if (sources.includes('github')) groups.push(await searchGitHub(fetcher, query, limit, env.GITHUB_TOKEN || ''));
  if (sources.includes('rss')) groups.push(await searchRss(fetcher, body.rssUrls || [], query, limit));
  if (sources.includes('web')) groups.push(await fetchWebMetadata(fetcher, body.urls || [], limit));
  const items = rankAndDedupe(groups, limit);
  const receipt = {
    schema: 'signallens.receipt.v1',
    query,
    sources,
    limit,
    itemCount: items.length,
    groups: groups.map((group) => ({ source: group.source, ok: group.ok, status: group.status, count: group.items?.length || 0 })),
    createdAt: new Date().toISOString()
  };
  receipt.hash = await sha256(receipt);
  return { ok: true, schema: 'signallens.search.v1', query, quote: quoteRequest({ sources, limit, providerQuotes: body.providerQuotes || [] }), receipt, items };
}

export async function handleRequest(request, env = {}, ctx = {}) {
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
  const url = new URL(request.url);
  try {
    if (request.method === 'GET' && url.pathname === '/health') return json({ ok: true, service: 'signallens-edge', schema: 'signallens.health.v1' });
    if (request.method === 'GET' && url.pathname === '/v1/catalog') return json(catalog());
    if (request.method === 'GET' && url.pathname === '/mcp/manifest') return json(mcpManifest(request));
    const auth = requireToken(request, env);
    if (!auth.ok) return auth.response;
    if (request.method === 'POST' && url.pathname === '/v1/quote') return json({ ok: true, quote: quoteRequest(await readJson(request)) });
    if (request.method === 'POST' && url.pathname === '/v1/search') return json(await runSearch(await readJson(request), env));
    if (request.method === 'POST' && url.pathname === '/v1/brief') {
      const body = await readJson(request);
      const result = await runSearch(body, env);
      return json({ ...result, schema: 'signallens.brief_response.v1', brief: buildBrief(body.query, result.items) });
    }
    return json({ ok: false, error: 'not_found' }, 404);
  } catch (error) {
    return json({ ok: false, error: error.message || 'internal_error' }, error.status || 400);
  }
}

export default { fetch: handleRequest };
export { runSearch, catalog, mcpManifest, quoteRequest };
