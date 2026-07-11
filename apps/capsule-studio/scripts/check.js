import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = path.resolve(__dirname, '..');
const required = ['server.js', 'package.json', 'public/index.html', 'public/styles.css', 'public/app.js', '.env.example'];
for (const rel of required) {
  if (!fs.existsSync(path.join(app, rel))) throw new Error(`missing ${rel}`);
}

const child = spawn(process.execPath, ['server.js'], { cwd: app, env: { ...process.env, PORT: '8799', HOST: '127.0.0.1', OPENAI_API_KEY: '' }, stdio: ['ignore', 'pipe', 'pipe'] });
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
  await wait(800);
  const health = await request('/api/health');
  if (!health.ok) throw new Error('health not ok');
  const aiStatus = await request('/api/ai/status');
  if (!Array.isArray(aiStatus.uses)) throw new Error('ai status missing uses');
  const created = await request('/api/workspaces', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ name: 'CI Website', template: 'web' }) });
  if (!created.id) throw new Error('workspace not created');
  const run = await request('/api/run', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id, file: 'index.html' }) });
  if (!run.ok || run.action !== 'preview') throw new Error('preview run failed');
  const generated = await request('/api/ai/build-app', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ prompt: 'Build a tiny app for CI validation' }) });
  if (!generated.ok || !generated.workspace?.id || !generated.deployment?.url) throw new Error('ai builder failed');
  const manifest = await request('/api/manifest', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id }) });
  if (!manifest.fileCount) throw new Error('manifest empty');
  const deploy = await request('/api/deploy/local', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id }) });
  if (!deploy.ok || !deploy.url) throw new Error('deploy failed');
  console.log(JSON.stringify({ ok: true, health, aiStatus, workspace: created.id, generated: generated.workspace.id, deploy: deploy.url }, null, 2));
} finally {
  child.kill('SIGTERM');
}
