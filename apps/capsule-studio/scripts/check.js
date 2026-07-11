import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = path.resolve(__dirname, '..');
const required = [
  'server.js',
  'package.json',
  'public/index.html',
  'public/styles.css',
  'public/app.js',
  '.env.example',
  'src/config.js',
  'src/http.js',
  'src/router.js',
  'src/workspaceStore.js',
  'src/templateCatalog.js',
  'src/runner.js',
  'src/aiBuilder.js',
  'src/openaiClient.js',
  'src/manifest.js',
  'src/deployment.js',
  'src/auditLog.js'
];
for (const rel of required) {
  if (!fs.existsSync(path.join(app, rel))) throw new Error(`missing ${rel}`);
}

const dataDir = path.join(app, '.ci-capsule-data');
fs.rmSync(dataDir, { recursive: true, force: true });
const child = spawn(process.execPath, ['server.js'], { cwd: app, env: { ...process.env, PORT: '8799', HOST: '127.0.0.1', OPENAI_API_KEY: '', NOVA_CAPSULE_DATA: dataDir }, stdio: ['ignore', 'pipe', 'pipe'] });
child.stdout.on('data', () => {});
child.stderr.on('data', () => {});

async function wait(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }
async function request(pathname, options) {
  const res = await fetch(`http://127.0.0.1:8799${pathname}`, options);
  const text = await res.text();
  let data;
  try { data = JSON.parse(text); } catch { data = text; }
  if (!res.ok) throw new Error(`${pathname} failed: ${text}`);
  return data;
}

try {
  await wait(900);
  const health = await request('/api/health');
  if (!health.ok || !health.ai) throw new Error('health not ok');
  const templates = await request('/api/templates');
  if (!templates.templates.find(t => t.id === 'web')) throw new Error('templates missing web');
  const aiStatus = await request('/api/ai/status');
  if (!aiStatus.mode) throw new Error('ai status missing mode');

  const created = await request('/api/workspaces', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ name: 'CI Website', template: 'web' }) });
  if (!created.id || !created.entry) throw new Error('workspace not created');

  const files = await request(`/api/workspace/files?workspaceId=${encodeURIComponent(created.id)}`);
  if (!files.files.find(f => f.path === 'index.html')) throw new Error('workspace files missing index.html');

  const opened = await request(`/api/workspace/file?workspaceId=${encodeURIComponent(created.id)}&file=index.html`);
  if (!opened.content.includes('CI Website')) throw new Error('file read failed');

  const saved = await request('/api/workspace/file', { method: 'PUT', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id, file: 'app.js', content: "console.log('edited by CI');\n" }) });
  if (!saved.ok) throw new Error('file save failed');

  const run = await request('/api/run', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id, file: 'index.html' }) });
  if (!run.ok || run.action !== 'preview') throw new Error('preview run failed');

  const generated = await request('/api/ai/build-app', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ prompt: 'Build a tiny app for CI validation' }) });
  if (!generated.ok || !generated.workspace?.id || !generated.deployment?.url) throw new Error('ai builder failed');

  const manifest = await request('/api/manifest', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id }) });
  if (!manifest.fileCount || !manifest.totalBytes) throw new Error('manifest empty');

  const deploy = await request('/api/deploy/local', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id }) });
  if (!deploy.ok || !deploy.url) throw new Error('deploy failed');

  const audit = await request('/api/audit?limit=20');
  if (!Array.isArray(audit.events)) throw new Error('audit missing');

  console.log(JSON.stringify({ ok: true, health, aiStatus, templates: templates.templates.length, workspace: created.id, generated: generated.workspace.id, deploy: deploy.url, auditEvents: audit.events.length }, null, 2));
} finally {
  child.kill('SIGTERM');
  fs.rmSync(dataDir, { recursive: true, force: true });
}
