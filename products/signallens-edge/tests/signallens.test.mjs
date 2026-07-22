import test from 'node:test';
import assert from 'node:assert/strict';
import { buildBrief, rankAndDedupe, searchGitHub, searchHackerNews, searchRss } from '../src/adapters.js';
import { handleRequest, runSearch, quoteRequest } from '../src/index.js';

function responseJson(body, status = 200) {
  return new Response(typeof body === 'string' ? body : JSON.stringify(body), { status, headers: { 'content-type': 'application/json' } });
}

function mockFetch(url) {
  const target = String(url);
  if (target.includes('hn.algolia.com')) return responseJson({ hits: [{ title: 'Agent data APIs are replacing subscriptions', url: 'https://example.com/hn', author: 'nova', created_at: '2026-07-22T00:00:00Z', points: 42, objectID: '1', num_comments: 7 }] });
  if (target.includes('api.github.com/search/repositories')) return responseJson({ items: [{ full_name: 'ItsNotAILABS/signallens-edge', html_url: 'https://github.com/ItsNotAILABS/signallens-edge', owner: { login: 'ItsNotAILABS' }, updated_at: '2026-07-22T00:00:00Z', stargazers_count: 100, description: 'Agent-ready public signal router', language: 'JavaScript', forks_count: 2, open_issues_count: 0 }] });
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
  assert.equal(rss.items.length, 1);
  assert.equal(items.length, 3);
  assert.equal(buildBrief('agent data', items).totalItems, 3);
});

test('runSearch returns receipts and ranked items', async () => {
  const result = await runSearch({ query: 'agent data', sources: ['hackernews', 'github', 'rss', 'web'], rssUrls: ['https://feed.test/rss'], urls: ['https://site.test'], limit: 10 }, {}, mockFetch);
  assert.equal(result.ok, true);
  assert.equal(result.items.length, 4);
  assert.equal(result.receipt.schema, 'signallens.receipt.v1');
  assert.equal(typeof result.receipt.hash, 'string');
});

test('worker exposes catalog, quote, search, brief, and auth boundary', async () => {
  const health = await handleRequest(new Request('https://signallens.test/health'));
  assert.equal((await health.json()).ok, true);
  const catalog = await handleRequest(new Request('https://signallens.test/v1/catalog'));
  assert.equal((await catalog.json()).product, 'SignalLens Edge');
  const denied = await handleRequest(new Request('https://signallens.test/v1/quote', { method: 'POST', body: '{}' }), { SIGNALLENS_TOKEN: 'secret' });
  assert.equal(denied.status, 401);
  const quote = await handleRequest(new Request('https://signallens.test/v1/quote', { method: 'POST', headers: { authorization: 'Bearer secret' }, body: JSON.stringify({ sources: ['github'] }) }), { SIGNALLENS_TOKEN: 'secret' });
  assert.equal((await quote.json()).quote.estimatedTotalUsd, 0);
});
