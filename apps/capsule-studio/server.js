import http from 'node:http';
import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '../..');
const APP_PUBLIC = path.join(__dirname, 'public');
const DATA_ROOT = process.env.NOVA_CAPSULE_DATA || path.join(ROOT, '.nova-capsule-studio');
const WORKSPACES = path.join(DATA_ROOT, 'workspaces');
const DEPLOYMENTS = path.join(DATA_ROOT, 'deployments');
const PORT = Number(process.env.PORT || 8787);
const HOST = process.env.HOST || '127.0.0.1';

const languages = [
  { id: 'python', label: 'Python', ext: ['.py'], run: ['python3'], preview: false, wasm: 'pyodide-or-micropython' },
  { id: 'matlab', label: 'MATLAB / Octave', ext: ['.m'], run: ['octave', '--quiet'], preview: false, wasm: 'octave-host-bridge' },
  { id: 'java', label: 'Java', ext: ['.java'], compile: ['javac'], run: ['java'], preview: false, wasm: 'teavm-or-jvm-bridge' },
  { id: 'cpp', label: 'C++', ext: ['.cpp', '.cc', '.cxx'], compile: ['c++', '-std=c++17', '-O2'], run: [], preview: false, wasm: 'emscripten-or-wasi' },
  { id: 'c', label: 'C', ext: ['.c'], compile: ['cc', '-std=c11', '-O2'], run: [], preview: false, wasm: 'emscripten-or-wasi' },
  { id: 'javascript', label: 'JavaScript', ext: ['.js', '.mjs'], run: ['node'], preview: true, wasm: 'browser-or-node' },
  { id: 'html', label: 'HTML / CSS / Frontend', ext: ['.html', '.css'], preview: true, wasm: 'browser-native' },
  { id: 'rust', label: 'Rust', ext: ['.rs'], compile: ['rustc'], run: [], preview: false, wasm: 'wasm32-wasi' },
  { id: 'go', label: 'Go', ext: ['.go'], compile: ['go', 'build'], run: [], preview: false, wasm: 'tinygo-or-go-wasm' }
];

function json(res, code, payload) {
  const body = JSON.stringify(payload, null, 2);
  res.writeHead(code, { 'content-type': 'application/json; charset=utf-8', 'cache-control': 'no-store' });
  res.end(body);
}

function text(res, code, body, type = 'text/plain; charset=utf-8') {
  res.writeHead(code, { 'content-type': type, 'cache-control': 'no-store' });
  res.end(body);
}

function slug(input) {
  return String(input || 'nova-project').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '') || 'nova-project';
}

function safeJoin(root, rel = '') {
  const target = path.resolve(root, rel);
  if (!target.startsWith(path.resolve(root))) throw new Error('path escapes root');
  return target;
}

async function ensureDirs() {
  await fsp.mkdir(WORKSPACES, { recursive: true });
  await fsp.mkdir(DEPLOYMENTS, { recursive: true });
}

async function readJson(req) {
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  if (!chunks.length) return {};
  return JSON.parse(Buffer.concat(chunks).toString('utf8'));
}

function detectLanguage(file) {
  const ext = path.extname(file).toLowerCase();
  return languages.find(lang => lang.ext.includes(ext));
}

async function listWorkspaces() {
  await ensureDirs();
  const names = await fsp.readdir(WORKSPACES, { withFileTypes: true });
  const records = [];
  for (const entry of names) {
    if (!entry.isDirectory()) continue;
    const metaPath = path.join(WORKSPACES, entry.name, '.nova', 'workspace.json');
    try { records.push(JSON.parse(await fsp.readFile(metaPath, 'utf8'))); } catch { records.push({ id: entry.name, name: entry.name, path: path.join(WORKSPACES, entry.name) }); }
  }
  return records;
}

async function createWorkspace(name = 'nova-project', template = 'web') {
  await ensureDirs();
  const id = `${Date.now()}-${slug(name)}`;
  const workspace = path.join(WORKSPACES, id);
  await fsp.mkdir(path.join(workspace, '.nova', 'receipts'), { recursive: true });
  await writeTemplate(workspace, template);
  const meta = { id, name, template, path: workspace, preview: `/preview/${id}/index.html`, createdAt: new Date().toISOString(), status: 'active' };
  await fsp.writeFile(path.join(workspace, '.nova', 'workspace.json'), JSON.stringify(meta, null, 2));
  return meta;
}

async function writeTemplate(workspace, template) {
  const files = template === 'python' ? {
    'hello.py': "print('hello from NOVA Capsule Studio')\n"
  } : template === 'cpp' ? {
    'main.cpp': '#include <iostream>\nint main(){ std::cout << "hello from NOVA Capsule Studio\\n"; return 0; }\n'
  } : template === 'java' ? {
    'Main.java': 'public class Main { public static void main(String[] args){ System.out.println("hello from NOVA Capsule Studio"); } }\n'
  } : {
    'index.html': '<!doctype html><html><head><meta charset="utf-8"><title>NOVA Preview</title><link rel="stylesheet" href="styles.css"></head><body><main><p>NOVA Capsule Studio</p><h1>Live Preview</h1><script src="app.js"></script></main></body></html>',
    'styles.css': 'body{margin:0;background:#020617;color:#f8fafc;font-family:system-ui}main{padding:64px}p{color:#38bdf8;text-transform:uppercase;letter-spacing:.18em}h1{font-size:72px}',
    'app.js': "console.log('NOVA Capsule Studio preview live');\n"
  };
  for (const [name, content] of Object.entries(files)) {
    const target = safeJoin(workspace, name);
    await fsp.mkdir(path.dirname(target), { recursive: true });
    await fsp.writeFile(target, content);
  }
}

function runProcess(cmd, args, cwd, timeout = 30000) {
  return new Promise(resolve => {
    const child = spawn(cmd, args, { cwd, shell: false });
    let stdout = '', stderr = '';
    const timer = setTimeout(() => { child.kill('SIGKILL'); resolve({ ok: false, stdout, stderr, code: 124, message: 'timeout' }); }, timeout);
    child.stdout.on('data', d => stdout += d.toString());
    child.stderr.on('data', d => stderr += d.toString());
    child.on('error', err => { clearTimeout(timer); resolve({ ok: false, stdout, stderr: stderr + err.message, code: 127, message: 'runner unavailable' }); });
    child.on('close', code => { clearTimeout(timer); resolve({ ok: code === 0, stdout, stderr, code, message: code === 0 ? 'complete' : 'failed' }); });
  });
}

async function runFile(workspaceId, file) {
  const workspace = safeJoin(WORKSPACES, workspaceId);
  const target = safeJoin(workspace, file);
  const lang = detectLanguage(file);
  const startedAt = new Date().toISOString();
  if (!lang) return receipt(workspace, { ok: false, action: 'run', file, startedAt, endedAt: new Date().toISOString(), message: 'unsupported language' });
  try { await fsp.access(target); } catch { return receipt(workspace, { ok: false, action: 'run', language: lang.id, file, startedAt, endedAt: new Date().toISOString(), message: 'file not found' }); }
  if (lang.id === 'html') return receipt(workspace, { ok: true, action: 'preview', language: lang.id, file, startedAt, endedAt: new Date().toISOString(), preview: `/preview/${workspaceId}/${file}`, message: 'preview ready' });
  const buildDir = path.join(workspace, '.nova', 'build');
  await fsp.mkdir(buildDir, { recursive: true });
  let result;
  if (lang.id === 'cpp' || lang.id === 'c') {
    const bin = path.join(buildDir, 'program');
    const compiler = lang.id === 'cpp' ? 'c++' : 'cc';
    const standard = lang.id === 'cpp' ? '-std=c++17' : '-std=c11';
    const compiled = await runProcess(compiler, [standard, '-O2', target, '-o', bin], workspace);
    result = compiled.ok ? await runProcess(bin, [], workspace) : compiled;
  } else if (lang.id === 'java') {
    const compiled = await runProcess('javac', [target], workspace);
    result = compiled.ok ? await runProcess('java', [path.basename(target, '.java')], workspace) : compiled;
  } else if (lang.id === 'python') result = await runProcess('python3', [target], workspace);
  else if (lang.id === 'javascript') result = await runProcess('node', [target], workspace);
  else if (lang.id === 'matlab') result = await runProcess('octave', ['--quiet', target], workspace);
  else if (lang.id === 'rust') {
    const bin = path.join(buildDir, 'program');
    const compiled = await runProcess('rustc', [target, '-O', '-o', bin], workspace);
    result = compiled.ok ? await runProcess(bin, [], workspace) : compiled;
  } else if (lang.id === 'go') {
    const bin = path.join(buildDir, 'program');
    const compiled = await runProcess('go', ['build', '-o', bin, target], workspace);
    result = compiled.ok ? await runProcess(bin, [], workspace) : compiled;
  }
  return receipt(workspace, { ok: result.ok, action: 'run', language: lang.id, file, startedAt, endedAt: new Date().toISOString(), stdout: result.stdout, stderr: result.stderr, message: result.message });
}

async function receipt(workspace, payload) {
  const body = { schema: 'nova.capsule-studio.receipt.v1', id: crypto.randomUUID(), ...payload };
  const dir = path.join(workspace, '.nova', 'receipts');
  await fsp.mkdir(dir, { recursive: true });
  await fsp.writeFile(path.join(dir, `${Date.now()}-${body.action}.json`), JSON.stringify(body, null, 2));
  return body;
}

async function manifest(workspaceId) {
  const workspace = safeJoin(WORKSPACES, workspaceId);
  const files = [];
  async function walk(dir) {
    for (const entry of await fsp.readdir(dir, { withFileTypes: true })) {
      const p = path.join(dir, entry.name);
      if (entry.isDirectory()) await walk(p);
      else {
        const data = await fsp.readFile(p);
        files.push({ path: path.relative(workspace, p), bytes: data.length, sha256: crypto.createHash('sha256').update(data).digest('hex') });
      }
    }
  }
  await walk(workspace);
  const body = { schema: 'nova.capsule-studio.manifest.v1', workspaceId, generatedAt: new Date().toISOString(), fileCount: files.length, files };
  await fsp.writeFile(path.join(workspace, '.nova', 'hash-manifest.json'), JSON.stringify(body, null, 2));
  return body;
}

async function deployLocal(workspaceId) {
  const workspace = safeJoin(WORKSPACES, workspaceId);
  const target = path.join(DEPLOYMENTS, workspaceId);
  await fsp.rm(target, { recursive: true, force: true });
  await fsp.mkdir(target, { recursive: true });
  for (const name of await fsp.readdir(workspace)) {
    if (name === '.nova') continue;
    await fsp.cp(path.join(workspace, name), path.join(target, name), { recursive: true });
  }
  const m = await manifest(workspaceId);
  const packet = { schema: 'nova.capsule-studio.local-deployment.v1', ok: true, workspaceId, target, url: `/deployed/${workspaceId}/index.html`, manifest: m, deployedAt: new Date().toISOString() };
  await fsp.writeFile(path.join(workspace, '.nova', 'deployment.json'), JSON.stringify(packet, null, 2));
  return packet;
}

async function serveStatic(res, root, rel) {
  try {
    const target = safeJoin(root, rel || 'index.html');
    const data = await fsp.readFile(target);
    const ext = path.extname(target);
    const type = ext === '.html' ? 'text/html; charset=utf-8' : ext === '.css' ? 'text/css; charset=utf-8' : ext === '.js' ? 'application/javascript; charset=utf-8' : 'application/octet-stream';
    res.writeHead(200, { 'content-type': type, 'cache-control': 'no-store' });
    res.end(data);
  } catch { text(res, 404, 'not found'); }
}

const server = http.createServer(async (req, res) => {
  try {
    await ensureDirs();
    const url = new URL(req.url, `http://${req.headers.host}`);
    if (url.pathname === '/api/health') return json(res, 200, { ok: true, app: 'NOVA Capsule Studio', version: '0.1.0', production: true });
    if (url.pathname === '/api/languages') return json(res, 200, { languages });
    if (url.pathname === '/api/workspaces' && req.method === 'GET') return json(res, 200, { workspaces: await listWorkspaces() });
    if (url.pathname === '/api/workspaces' && req.method === 'POST') { const body = await readJson(req); return json(res, 201, await createWorkspace(body.name, body.template)); }
    if (url.pathname === '/api/run' && req.method === 'POST') { const body = await readJson(req); return json(res, 200, await runFile(body.workspaceId, body.file)); }
    if (url.pathname === '/api/manifest' && req.method === 'POST') { const body = await readJson(req); return json(res, 200, await manifest(body.workspaceId)); }
    if (url.pathname === '/api/deploy/local' && req.method === 'POST') { const body = await readJson(req); return json(res, 200, await deployLocal(body.workspaceId)); }
    if (url.pathname.startsWith('/preview/')) { const [, , workspaceId, ...parts] = url.pathname.split('/'); return serveStatic(res, safeJoin(WORKSPACES, workspaceId), parts.join('/') || 'index.html'); }
    if (url.pathname.startsWith('/deployed/')) { const [, , workspaceId, ...parts] = url.pathname.split('/'); return serveStatic(res, safeJoin(DEPLOYMENTS, workspaceId), parts.join('/') || 'index.html'); }
    return serveStatic(res, APP_PUBLIC, url.pathname.slice(1) || 'index.html');
  } catch (err) { return json(res, 500, { ok: false, error: err.message }); }
});

server.listen(PORT, HOST, () => console.log(`NOVA Capsule Studio live at http://${HOST}:${PORT}`));
