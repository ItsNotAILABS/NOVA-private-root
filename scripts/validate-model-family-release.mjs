import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const required = [
  'docs/wiki/README.md',
  'docs/wiki/Home.md',
  'docs/wiki/02-model-cards.md',
  'docs/wiki/03-coding-agent-model.md',
  'docs/wiki/04-tasking-mission-model.md',
  'docs/wiki/05-creation-app-factory-model.md',
  'docs/wiki/06-orchestration-model.md',
  'docs/wiki/07-talking-conversation-model.md',
  'docs/wiki/08-computation-proof-model.md',
  'docs/wiki/09-safety-governance-release-boundary.md',
  'docs/wiki/10-ide-browser-ai-platform-integration.md',
  'docs/wiki/11-operations-runbook.md',
  'docs/wiki/12-release-registry.md',
  'docs/releases/model-family/v1.0.0/RELEASE.md',
  'docs/releases/model-family/v1.0.0/release-manifest.json',
  'docs/releases/model-family/v1.0.0/PRODUCTION_READINESS.md',
  'docs/releases/model-family/v1.0.0/TASK_CAPABILITY_MATRIX.md',
  'docs/releases/model-family/v1.0.0/TRAINING_AND_EVALUATION_BOUNDARY.md',
  'docs/releases/model-family/v1.0.0/ECOSYSTEM_FEEDER_REGISTRY.md'
];

for (const file of required) assert.ok(fs.existsSync(path.join(root, file)), `missing ${file}`);

const manifestPath = path.join(root, 'docs/releases/model-family/v1.0.0/release-manifest.json');
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
assert.equal(manifest.schema, 'nova-model-family-release-manifest-v1');
assert.equal(manifest.release, 'nova-model-family-v1.0.0');
assert.equal(manifest.status, 'production-harness');
assert.ok(Array.isArray(manifest.models) && manifest.models.length >= 12);
assert.ok(Array.isArray(manifest.production_controls) && manifest.production_controls.length >= 8);
assert.ok(Array.isArray(manifest.task_capabilities) && manifest.task_capabilities.length >= 8);
assert.ok(Array.isArray(manifest.evidence) && manifest.evidence.length >= 10);
assert.equal(manifest.boundary_claims.no_consciousness_claim, true);
assert.equal(manifest.boundary_claims.no_unapproved_live_deployment, true);
assert.equal(manifest.boundary_claims.no_secret_exposure, true);

const banned = [
  /claims consciousness/i,
  /fully autonomous legal agent/i,
  /guaranteed profit/i,
  /unrestricted live deployment/i,
  /secret key included/i,
  /api key included/i
];
for (const file of required) {
  const text = fs.readFileSync(path.join(root, file), 'utf8');
  for (const pattern of banned) assert.equal(pattern.test(text), false, `${file} contains banned phrase ${pattern}`);
}

console.log(JSON.stringify({ ok: true, checked: required.length, release: manifest.release, status: manifest.status }, null, 2));
