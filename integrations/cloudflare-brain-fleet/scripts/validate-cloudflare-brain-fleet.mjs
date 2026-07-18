import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '../../..');
const required = [
  'integrations/cloudflare-brain-fleet/src/index.js',
  'integrations/cloudflare-brain-fleet/package.json',
  'integrations/cloudflare-brain-fleet/tests/brain-fleet.test.mjs',
  'integrations/cloudflare-brain-fleet/wrangler.toml.example',
  'integrations/cloudflare-brain-fleet/README.md',
  'integrations/cloudflare-brain-fleet/schemas/brain-fleet.schema.json',
  'docs/CLOUDFLARE_BRAIN_FLEET.md'
];

for (const file of required) assert.ok(fs.existsSync(path.join(root, file)), `missing ${file}`);
const worker = fs.readFileSync(path.join(root, 'integrations/cloudflare-brain-fleet/src/index.js'), 'utf8');
const tests = fs.readFileSync(path.join(root, 'integrations/cloudflare-brain-fleet/tests/brain-fleet.test.mjs'), 'utf8');
for (const token of ['BrainCoordinator', 'BRAIN_COORDINATOR', 'performTask', 'repo.ci', 'repo.repair-plan', 'execute', 'leases.recovered', 'scheduler.tick', 'previousHash']) {
  assert.ok(worker.includes(token), `worker missing ${token}`);
}
for (const token of ['seeded.body.created.length, 71', 'task.result.tags.includes', 'lease ownership', 'performTask creates deterministic repair plans']) {
  assert.ok(tests.includes(token), `test missing ${token}`);
}
assert.ok(!/OPENAI_API_KEY\s*=|ANTHROPIC_API_KEY\s*=|GITHUB_TOKEN\s*=|PRIVATE KEY/.test(worker), 'worker must not contain hard-coded secrets');
const schema = JSON.parse(fs.readFileSync(path.join(root, 'integrations/cloudflare-brain-fleet/schemas/brain-fleet.schema.json'), 'utf8'));
assert.equal(schema.$id, 'nova.edge.brain_fleet.schema.v1');
assert.ok(schema.properties.brains);
assert.ok(schema.properties.tasks);
assert.ok(schema.properties.receipts);
const docs = required.map((file) => fs.readFileSync(path.join(root, file), 'utf8')).join('\n');
const banned = [/guaranteed autonomous repair/i, /unrestricted repository write/i, /secret exfiltration/i, /live deployment without approval/i];
for (const line of docs.split('\n')) {
  const negated = /\b(no|not|never|without|does not|cannot|operator-controlled|approval required)\b/i.test(line);
  for (const pattern of banned) assert.equal(pattern.test(line) && !negated, false, `banned affirmative claim found ${pattern}: ${line}`);
}
console.log(JSON.stringify({ ok: true, checked: required.length, harness: 'cloudflare-brain-fleet-runtime' }, null, 2));
