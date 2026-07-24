import test from 'node:test';
import assert from 'node:assert/strict';
import { buildBrief, rankAndDedupe, searchGitHub, searchHackerNews, searchRss } from '../src/adapters.js';
import { handleRequest, runSearch, quoteRequest, listVerticals, ingestRelayReceipt } from '../src/index.js';
import { buildVerticalBrief, getVertical, applyVerticalRanking } from '../src/verticals.js';

function responseJson(body, status = 200) {
  return new Response(typeof body === 'string' ? body : JSON.stringify(body), { status, headers: { 'content-type': 'application/json' } });
}

function mockFetch(url) {
  const target = String(url);
  if (target.includes('hn.algolia.com')) return responseJson({ hits: [
    { title: 'Agent data APIs are replacing subscriptions', url: 'https://example.com/hn', author: 'nova', created_at: '2026-07-22T00:00:00Z', points: 42, objectID: '1', num_comments: 7 },
    { title: 'Cloudflare Worker compute benchmark for AI agents', url: 'https://example.com/compute', author: 'systems', created_at: '2026-07-22T01:00:00Z', points: 60, objectID: '2', num_comments: 3 },
    { title: 'Physics simulation dataset released for WebGPU research', url: 'https://example.com/physics', author: 'lab', created_at: '2026-07-22T02:00:00Z', points: 20, objectID: '3', num_comments: 1 }
  ] });
  if (target.includes('api.github.com/search/repositories')) return responseJson({ items: [{ full_name: 'ItsNotAILABS/signallens-edge', html_url: 'https://github.com/ItsNotAILABS/signallens-edge', owner: { login: 'ItsNotAILABS' }, updated_at: '2026-07-22T00:00:00Z', stargazers_count: 100, description: 'Agent-ready public signal router API runtime for developers and business intelligence', language: 'JavaScript', forks_count: 2, open_issues_count: 0 }] });
  if (target.includes('feed.test')) return new Response('<rss><channel><item><title>AI agent pricing</title><link>https://feed.test/post</link><description>pay per request beats subscriptions</description><pubDate>Wed, 22 Jul 2026 00:00:00 GMT</pubDate></item></channel></rss>', { status: 200 });
  if (target.includes('site.test')) return new Response('<html><head><title>SignalLens launch</title><meta name="description" content="public data router for agents"></head><body></body></html>', { status: 200 });
  return responseJson({}, 404);
}

test('quote has zero internal subscription cost', () => {
  const quote = quoteRequest({ sources: ['hackernews', 'github', 'rss'], limit: 20 });
  assert.equal(quote.estimatedInternalUsd, 0);
  assert.equal(quote.posture.includes('no subscription'), true);
});

test('source adapters normalize public signals', async () => {
  const hn = await searchHackerNews(mockFetch, 'agent data', 5);
  const gh = await searchGitHub(mockFetch, 'agent data', 5);
  const rss = await searchRss(mockFetch, ['https://feed.test/rss'], 'agent', 5);
  const items = rankAndDedupe([hn, gh, rss], 10);
  assert.equal(hn.ok, true);
  assert.equal(gh.ok, true);
  assert.equal(Array.isArray(rss.items), true);
  assert.ok(items.length >= 2);
  assert.ok(buildBrief('agent data', items).totalItems >= 2);
});

test('runSearch returns receipts and ranked items', async () => {
  const result = await runSearch({ query: 'agent data', sources: ['hackernews', 'github', 'rss', 'web'], rssUrls: ['https://feed.test/rss'], urls: ['https://site.test'], limit: 10 }, {}, mockFetch);
  assert.equal(result.ok, true);
  assert.ok(result.items.length >= 2);
  assert.equal(result.receipt.schema, 'signallens.receipt.v1');
  assert.equal(typeof result.receipt.hash, 'string');
  assert.equal(result.quote.estimatedTotalUsd, 0);
});

test('vertical registry includes business physics compute enterprise developer finance construction', () => {
  const ids = listVerticals().map((vertical) => vertical.id);
  for (const id of ['business', 'physics', 'compute', 'enterprise', 'developer', 'finance', 'construction']) assert.ok(ids.includes(id));
  assert.equal(getVertical('physics').name, 'Physics and Research Intelligence');
});

test('vertical ranking and brief specialize the same items for different audiences', async () => {
  const result = await runSearch({ query: 'compute physics business', sources: ['hackernews', 'github'], vertical: 'compute', limit: 10 }, {}, mockFetch);
  const computeBrief = buildVerticalBrief('compute physics business', result.items, 'compute');
  const physicsItems = applyVerticalRanking(result.items, 'physics', 10);
  const physicsBrief = buildVerticalBrief('compute physics business', physicsItems, 'physics');
  assert.equal(computeBrief.vertical.id, 'compute');
  assert.equal(physicsBrief.vertical.id, 'physics');
  assert.ok(computeBrief.promptHints.length > 0);
  assert.ok(Object.keys(physicsBrief.sections).includes('research_claims'));
});

test('SignalLens ingests Relay receipts and optionally persists them', async () => {
  const receipt = {
    source: 'nexus-relay',
    event: 'relay.fetch.completed',
    request_id: 'relay-1',
    receipt_sha256: 'a'.repeat(64),
    content_sha256: 'b'.repeat(64),
    vertical: 'compute'
  };
  const kv = new Map();
  const env = { SIGNALLENS_RECEIPTS: { put: async (key, value) => kv.set(key, value), get: async (key) => JSON.parse(kv.get(key)) } };
  const ack = await ingestRelayReceipt({ receipt }, env, 'relay-agent');
  assert.equal(ack.ok, true);
  assert.equal(ack.storage, 'kv');
  assert.equal(ack.source, 'nexus-relay');
  assert.equal(typeof ack.hash, 'string');
  const stored = await handleRequest(new Request(`https://signallens.test/v1/receipts/${ack.hash}`, { headers: { authorization: 'Bearer secret' } }), { ...env, SIGNALLENS_TOKEN: 'secret' });
  assert.equal((await stored.json()).receipt.hash, ack.hash);
});

test('worker exposes catalog, quote, verticals, vertical brief, receipts, and auth boundary', async () => {
  const health = await handleRequest(new Request('https://signallens.test/health'));
  assert.equal((await health.json()).ok, true);
  const catalog = await handleRequest(new Request('https://signallens.test/v1/catalog'));
  const catalogBody = await catalog.json();
  assert.equal(catalogBody.product, 'SignalLens Edge');
  assert.ok(catalogBody.verticals.length >= 7);
  assert.equal(catalogBody.receipts.ingest, '/v1/receipts');
  const verticals = await handleRequest(new Request('https://signallens.test/v1/verticals'));
  assert.ok((await verticals.json()).verticals.find((vertical) => vertical.id === 'enterprise'));
  const denied = await handleRequest(new Request('https://signallens.test/v1/quote', { method: 'POST', body: '{}' }), { SIGNALLENS_TOKEN: 'secret' });
  assert.equal(denied.status, 401);
  const quote = await handleRequest(new Request('https://signallens.test/v1/quote', { method: 'POST', headers: { authorization: 'Bearer secret' }, body: JSON.stringify({ sources: ['github'], vertical: 'business' }) }), { SIGNALLENS_TOKEN: 'secret' });
  assert.equal((await quote.json()).quote.estimatedTotalUsd, 0);
  const receipt = await handleRequest(new Request('https://signallens.test/v1/receipts', { method: 'POST', headers: { authorization: 'Bearer secret' }, body: JSON.stringify({ receipt: { source: 'nexus-relay', event: 'relay.run', receipt_sha256: 'c'.repeat(64) } }) }), { SIGNALLENS_TOKEN: 'secret' });
  assert.equal((await receipt.json()).ok, true);
  const brief = await handleRequest(new Request('https://signallens.test/v1/vertical-brief', { method: 'POST', body: JSON.stringify({ query: 'agent APIs', vertical: 'developer', sources: ['hackernews', 'github'] }) }), {}, { fetch: mockFetch });
  assert.equal((await brief.json()).brief.vertical.id, 'developer');
});
