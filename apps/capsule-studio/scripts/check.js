import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = path.resolve(__dirname, '..');
const required = ['server.js', 'package.json', 'public/index.html', 'public/styles.css', 'public/app.js'];
for (const rel of required) {
  if (!fs.existsSync(path.join(app, rel))) throw new Error(`missing ${rel}`);
}

const child = spawn(process.execPath, ['server.js'], { cwd: app, env: { ...process.env, PORT: '8799', HOST: '127.0.0.1' }, stdio: ['ignore', 'pipe', 'pipe'] });
let stdout = '', stderr = '';
child.stdout.on('data', d => stdout += d.toString());
child.stderr.on('data', d => stderr += d.toString());

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
  const created = await request('/api/workspaces', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ name: 'CI Website', template: 'web' }) });
  if (!created.id) throw new Error('workspace not created');
  const run = await request('/api/run', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id, file: 'index.html' }) });
  if (!run.ok || run.action !== 'preview') throw new Error('preview run failed');
  const manifest = await request('/api/manifest', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id }) });
  if (!manifest.fileCount) throw new Error('manifest empty');
  const deploy = await request('/api/deploy/local', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ workspaceId: created.id }) });
  if (!deploy.ok || !deploy.url) throw new Error('deploy failed');
  console.log(JSON.stringify({ ok: true, health, workspace: created.id, deploy: deploy.url }, null, 2));
} finally {
  child.kill('SIGTERM');
}
