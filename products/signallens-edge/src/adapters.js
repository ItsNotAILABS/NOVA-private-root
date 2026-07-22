const DEFAULT_LIMIT = 10;
const MAX_LIMIT = 50;

export function normalizeQuery(query) {
  return String(query || '').replace(/\s+/g, ' ').trim().slice(0, 240);
}

export function normalizeLimit(limit) {
  const value = Number(limit || DEFAULT_LIMIT);
  return Math.max(1, Math.min(MAX_LIMIT, Number.isFinite(value) ? value : DEFAULT_LIMIT));
}

export async function sha256(value) {
  const encoder = new TextEncoder();
  const bytes = encoder.encode(typeof value === 'string' ? value : JSON.stringify(value));
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return Array.from(new Uint8Array(digest)).map((byte) => byte.toString(16).padStart(2, '0')).join('');
}

function stripHtml(value = '') {
  return String(value).replace(/<[^>]+>/g, ' ').replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/\s+/g, ' ').trim();
}

function item({ source, title, url, author, publishedAt, score = 0, text = '', raw = {} }) {
  return {
    schema: 'signallens.item.v1',
    source,
    title: stripHtml(title).slice(0, 300),
    url: String(url || '').slice(0, 1000),
    author: String(author || '').slice(0, 160),
    publishedAt: publishedAt || null,
    score: Number(score || 0),
    text: stripHtml(text).slice(0, 1200),
    raw
  };
}

export async function searchHackerNews(fetcher, query, limit = DEFAULT_LIMIT) {
  const q = normalizeQuery(query);
  const response = await fetcher(`https://hn.algolia.com/api/v1/search?query=${encodeURIComponent(q)}&tags=story&hitsPerPage=${normalizeLimit(limit)}`);
  if (!response.ok) return { source: 'hackernews', ok: false, status: response.status, items: [] };
  const body = await response.json();
  const items = (body.hits || []).slice(0, normalizeLimit(limit)).map((hit) => item({
    source: 'hackernews',
    title: hit.title || hit.story_title,
    url: hit.url || `https://news.ycombinator.com/item?id=${hit.objectID}`,
    author: hit.author,
    publishedAt: hit.created_at,
    score: hit.points || 0,
    text: hit._highlightResult?.title?.value || hit.title || '',
    raw: { objectID: hit.objectID, comments: hit.num_comments || 0 }
  }));
  return { source: 'hackernews', ok: true, status: 200, items };
}

export async function searchGitHub(fetcher, query, limit = DEFAULT_LIMIT, token = '') {
  const q = normalizeQuery(query);
  const headers = { accept: 'application/vnd.github+json', 'user-agent': 'signallens-edge', 'x-github-api-version': '2022-11-28' };
  if (token) headers.authorization = `Bearer ${token}`;
  const response = await fetcher(`https://api.github.com/search/repositories?q=${encodeURIComponent(q)}&sort=updated&order=desc&per_page=${normalizeLimit(limit)}`, { headers });
  if (!response.ok) return { source: 'github', ok: false, status: response.status, items: [] };
  const body = await response.json();
  const items = (body.items || []).slice(0, normalizeLimit(limit)).map((repo) => item({
    source: 'github',
    title: repo.full_name,
    url: repo.html_url,
    author: repo.owner?.login,
    publishedAt: repo.updated_at,
    score: repo.stargazers_count || 0,
    text: repo.description || '',
    raw: { language: repo.language, forks: repo.forks_count, openIssues: repo.open_issues_count }
  }));
  return { source: 'github', ok: true, status: 200, items };
}

function parseFeed(xml, feedUrl, query, limit) {
  const normalized = normalizeQuery(query).toLowerCase();
  const blocks = [...String(xml || '').matchAll(/<(item|entry)\b[\s\S]*?<\/\1>/gi)].map((match) => match[0]);
  return blocks.map((block) => {
    const pick = (names) => {
      for (const name of names) {
        const found = block.match(new RegExp(`<${name}[^>]*>([\\s\\S]*?)<\\/${name}>`, 'i'));
        if (found) return stripHtml(found[1].replace(/<!\[CDATA\[|\]\]>/g, ''));
      }
      return '';
    };
    const title = pick(['title']);
    const text = pick(['description', 'summary', 'content']);
    const link = block.match(/<link[^>]+href=["']([^"']+)["']/i)?.[1] || pick(['link', 'guid']);
    return item({ source: 'rss', title, url: link || feedUrl, author: pick(['author', 'dc:creator']), publishedAt: pick(['pubDate', 'updated', 'published']) || null, score: 0, text, raw: { feedUrl } });
  }).filter((entry) => !normalized || `${entry.title} ${entry.text}`.toLowerCase().includes(normalized)).slice(0, normalizeLimit(limit));
}

export async function searchRss(fetcher, urls = [], query = '', limit = DEFAULT_LIMIT) {
  const feeds = Array.isArray(urls) ? urls.slice(0, 10) : [];
  const results = [];
  for (const feedUrl of feeds) {
    try {
      const response = await fetcher(String(feedUrl), { headers: { accept: 'application/rss+xml, application/atom+xml, text/xml, */*' } });
      if (!response.ok) continue;
      results.push(...parseFeed(await response.text(), String(feedUrl), query, limit));
    } catch {
      // Feed failure should not fail the whole intelligence run.
    }
  }
  return { source: 'rss', ok: true, status: 200, items: results.slice(0, normalizeLimit(limit)) };
}

export async function fetchWebMetadata(fetcher, urls = [], limit = DEFAULT_LIMIT) {
  const results = [];
  for (const url of (Array.isArray(urls) ? urls : []).slice(0, normalizeLimit(limit))) {
    try {
      const response = await fetcher(String(url), { headers: { accept: 'text/html, text/plain, */*' } });
      if (!response.ok) continue;
      const text = (await response.text()).slice(0, 100000);
      const title = text.match(/<title[^>]*>([\s\S]*?)<\/title>/i)?.[1] || String(url);
      const description = text.match(/<meta[^>]+name=["']description["'][^>]+content=["']([^"']+)["']/i)?.[1] || '';
      results.push(item({ source: 'web', title, url, text: description, raw: { status: response.status } }));
    } catch {
      // continue
    }
  }
  return { source: 'web', ok: true, status: 200, items: results };
}

export function rankAndDedupe(groups = [], limit = DEFAULT_LIMIT) {
  const seen = new Set();
  return groups.flatMap((group) => group.items || [])
    .filter((entry) => {
      const key = (entry.url || entry.title).toLowerCase();
      if (!key || seen.has(key)) return false;
      seen.add(key);
      return true;
    })
    .sort((a, b) => (b.score - a.score) || String(b.publishedAt || '').localeCompare(String(a.publishedAt || '')))
    .slice(0, normalizeLimit(limit));
}

export function buildBrief(query, items = []) {
  const bySource = items.reduce((acc, entry) => ({ ...acc, [entry.source]: (acc[entry.source] || 0) + 1 }), {});
  const top = items.slice(0, 8).map((entry, index) => ({ rank: index + 1, source: entry.source, title: entry.title, url: entry.url, signal: entry.text || entry.title }));
  return {
    schema: 'signallens.brief.v1',
    query: normalizeQuery(query),
    totalItems: items.length,
    sources: bySource,
    top,
    summary: top.length ? `Found ${items.length} public signals across ${Object.keys(bySource).join(', ')} for: ${normalizeQuery(query)}` : `No public signals found for: ${normalizeQuery(query)}`,
    boundary: 'Public or operator-supplied sources only; no login bypass or authenticated scraping.'
  };
}
