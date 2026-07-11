import fsp from 'node:fs/promises';
import path from 'node:path';
import { spawn } from 'node:child_process';
import crypto from 'node:crypto';
import { config } from './config.js';
import { workspacePath, readWorkspace } from './workspaceStore.js';
import { safeJoin } from './http.js';
import { writeAudit } from './auditLog.js';

export const languageRegistry = Object.freeze([
  { id: 'python', label: 'Python', ext: ['.py'], preview: false },
  { id: 'matlab', label: 'MATLAB / Octave', ext: ['.m'], preview: false },
  { id: 'java', label: 'Java', ext: ['.java'], preview: false },
  { id: 'cpp', label: 'C++', ext: ['.cpp', '.cc', '.cxx'], preview: false },
  { id: 'c', label: 'C', ext: ['.c'], preview: false },
  { id: 'javascript', label: 'JavaScript', ext: ['.js', '.mjs'], preview: true },
  { id: 'html', label: 'HTML / CSS / Frontend', ext: ['.html', '.css'], preview: true },
  { id: 'rust', label: 'Rust', ext: ['.rs'], preview: false },
  { id: 'go', label: 'Go', ext: ['.go'], preview: false }
]);

export function detectLanguage(file) {
  const ext = path.extname(file).toLowerCase();
  return languageRegistry.find((lang) => lang.ext.includes(ext));
}

function runProcess(cmd, args, cwd, timeout = config.runTimeoutMs) {
  return new Promise((resolve) => {
    const child = spawn(cmd, args, { cwd, shell: false });
    let stdout = '';
    let stderr = '';
    const timer = setTimeout(() => {
      child.kill('SIGKILL');
      resolve({ ok: false, stdout, stderr, code: 124, message: 'timeout' });
    }, timeout);
    child.stdout.on('data', (data) => { stdout += data.toString(); });
    child.stderr.on('data', (data) => { stderr += data.toString(); });
    child.on('error', (err) => {
      clearTimeout(timer);
      resolve({ ok: false, stdout, stderr: `${stderr}${err.message}`, code: 127, message: 'runner unavailable' });
    });
    child.on('close', (code) => {
      clearTimeout(timer);
      resolve({ ok: code === 0, stdout, stderr, code, message: code === 0 ? 'complete' : 'failed' });
    });
  });
}

async function writeRunReceipt(workspace, payload) {
  const body = {
    schema: 'nova.capsule-studio.run-receipt.v2',
    id: crypto.randomUUID(),
    ...payload
  };
  const dir = path.join(workspace, '.nova', 'receipts');
  await fsp.mkdir(dir, { recursive: true });
  await fsp.writeFile(path.join(dir, `${Date.now()}-${body.action}.json`), JSON.stringify(body, null, 2), 'utf8');
  return body;
}

export async function runFile(workspaceId, file) {
  const workspace = workspacePath(workspaceId);
  const target = safeJoin(workspace, file);
  const lang = detectLanguage(file);
  const startedAt = new Date().toISOString();
  if (!lang) return writeRunReceipt(workspace, { ok: false, action: 'run', file, startedAt, endedAt: new Date().toISOString(), message: 'unsupported language' });
  try { await fsp.access(target); } catch { return writeRunReceipt(workspace, { ok: false, action: 'run', language: lang.id, file, startedAt, endedAt: new Date().toISOString(), message: 'file not found' }); }
  if (lang.id === 'html') {
    const meta = await readWorkspace(workspaceId);
    return writeRunReceipt(workspace, { ok: true, action: 'preview', language: lang.id, file, startedAt, endedAt: new Date().toISOString(), preview: `/preview/${workspaceId}/${file || meta.entry || 'index.html'}`, message: 'preview ready' });
  }
  const buildDir = path.join(workspace, '.nova', 'build');
  await fsp.mkdir(buildDir, { recursive: true });
  let result = { ok: false, stdout: '', stderr: '', message: 'runner unavailable' };
  if (lang.id === 'python') result = await runProcess('python3', [target], workspace);
  else if (lang.id === 'javascript') result = await runProcess('node', [target], workspace);
  else if (lang.id === 'cpp' || lang.id === 'c') {
    const bin = path.join(buildDir, 'program');
    const compiler = lang.id === 'cpp' ? 'c++' : 'cc';
    const standard = lang.id === 'cpp' ? '-std=c++17' : '-std=c11';
    const compiled = await runProcess(compiler, [standard, '-O2', target, '-o', bin], workspace);
    result = compiled.ok ? await runProcess(bin, [], workspace) : compiled;
  } else if (lang.id === 'java') {
    const compiled = await runProcess('javac', [target], workspace);
    result = compiled.ok ? await runProcess('java', [path.basename(target, '.java')], workspace) : compiled;
  } else if (lang.id === 'go') {
    const bin = path.join(buildDir, 'program');
    const compiled = await runProcess('go', ['build', '-o', bin, target], workspace);
    result = compiled.ok ? await runProcess(bin, [], workspace) : compiled;
  } else if (lang.id === 'rust') {
    const bin = path.join(buildDir, 'program');
    const compiled = await runProcess('rustc', [target, '-O', '-o', bin], workspace);
    result = compiled.ok ? await runProcess(bin, [], workspace) : compiled;
  }
  const receipt = await writeRunReceipt(workspace, { ok: result.ok, action: 'run', language: lang.id, file, startedAt, endedAt: new Date().toISOString(), stdout: result.stdout, stderr: result.stderr, message: result.message });
  await writeAudit('workspace.file.run', { workspaceId, file, ok: result.ok, language: lang.id });
  return receipt;
}
