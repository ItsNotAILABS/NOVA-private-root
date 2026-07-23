import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';

const cwd = process.cwd();
const base = fs.existsSync(path.join(cwd, 'src/index.js')) ? cwd : path.join(cwd, 'products/signallens-edge');
const required = [
  'package.json',
  'src/index.js',
  'src/adapters.js',
  'src/pricing.js',
  'src/verticals.js',
  'tests/signallens.test.mjs',
  'wrangler.toml.example',
  'README.md',
  'docs/VERTICALS.md'
];

for (const file of required) assert.ok(fs.existsSync(path.join(base, file)), `missing ${file}`);
const index = fs.readFileSync(path.join(base, 'src/index.js'), 'utf8');
for (const token of ['handleRequest', '/v1/search', '/v1/brief', '/v1/quote', '/v1/verticals', '/v1/vertical-brief', '/mcp/manifest', 'receipt']) assert.ok(index.includes(token), `missing ${token}`);
assert.ok(!/OPENAI_API_KEY\s*=|ANTHROPIC_API_KEY\s*=|APIFY_TOKEN\s*=|PRIVATE KEY/.test(index), 'runtime must not hard-code provider secrets');
const verticals = fs.readFileSync(path.join(base, 'src/verticals.js'), 'utf8');
for (const token of ['business', 'physics', 'compute', 'enterprise', 'developer', 'finance', 'construction', 'applyVerticalRanking']) assert.ok(verticals.includes(token), `vertical missing ${token}`);
const readme = fs.readFileSync(path.join(base, 'README.md'), 'utf8');
for (const token of ['SignalLens Edge', 'No login bypass', 'Cloudflare Worker', 'pay-per-request']) assert.ok(readme.includes(token), `README missing ${token}`);
const docs = fs.readFileSync(path.join(base, 'docs/VERTICALS.md'), 'utf8');
for (const token of ['Business Intelligence', 'Physics and Research Intelligence', 'Compute and Infrastructure Intelligence', 'Enterprise Work Intelligence']) assert.ok(docs.includes(token), `vertical docs missing ${token}`);
const banned = [/guaranteed access to every platform/i, /evade rate limits/i, /scrape private data/i, /investment advice/i];
for (const pattern of banned) assert.equal(pattern.test(`${readme}\n${docs}`), false, `banned claim found ${pattern}`);
console.log(JSON.stringify({ ok: true, product: 'signallens-edge', checked: required.length, verticals: 8 }, null, 2));
