import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const required = [
  'integrations/cloudflare-brain-fleet/src/index.js',
  'integrations/cloudflare-brain-fleet/wrangler.toml.example',
  'integrations/cloudflare-brain-fleet/README.md',
  'integrations/cloudflare-brain-fleet/schemas/brain-fleet.schema.json',
  'docs/CLOUDFLARE_BRAIN_FLEET.md'
];

for (const file of required) assert.ok(fs.existsSync(path.join(root, file)), `missing ${file}`);
const worker = fs.readFileSync(path.join(root, 'integrations/cloudflare-brain-fleet/src/index.js'), 'utf8');
for (const token of ['BrainCoordinator', 'Durable Objects', 'BRAIN_COORDINATOR', 'receipt', 'claim', 'heartbeat']) {
  assert.ok(worker.includes(token), `worker missing ${token}`);
}
assert.ok(!/OPENAI_API_KEY|ANTHROPIC_API_KEY|GITHUB_TOKEN\s*=|PRIVATE KEY/.test(worker), 'worker must not contain secrets');
const schema = JSON.parse(fs.readFileSync(path.join(root, 'integrations/cloudflare-brain-fleet/schemas/brain-fleet.schema.json'), 'utf8'));
assert.equal(schema.$id, 'nova.edge.brain_fleet.schema.v1');
assert.ok(schema.properties.brains);
assert.ok(schema.properties.tasks);
const docs = required.map((file) => fs.readFileSync(path.join(root, file), 'utf8')).join('\n');
const banned = [/guaranteed autonomous repair/i, /unrestricted repository write/i, /secret exfiltration/i, /live deployment without approval/i];
for (const pattern of banned) assert.equal(pattern.test(docs), false, `banned claim found ${pattern}`);
console.log(JSON.stringify({ ok: true, checked: required.length, harness: 'cloudflare-brain-fleet' }, null, 2));
