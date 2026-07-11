const $ = (id) => document.getElementById(id);
const state = { workspaces: [], platformOnline: false, platformSession: null };
const state = { workspaces: [], activeWorkspaceId: null, activeFile: null };
const log = (value) => { $('log').textContent = typeof value === 'string' ? value : JSON.stringify(value, null, 2); };
const platformLog = (value) => { const el = $('platformLog'); if (el) el.textContent = typeof value === 'string' ? value : JSON.stringify(value, null, 2); };

async function api(path, options = {}) {
  const res = await fetch(path, { headers: { 'content-type': 'application/json' }, ...options });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || data.message || 'request failed');
  return data;
}

function bridge() {
  return window.NOVAPlatformBridge || null;
}

async function refreshPlatform() {
  const b = bridge();
  if (!b) {
    state.platformOnline = false;
    $('platformStatus').textContent = 'Platform bridge not loaded. Start NOVA App Platform on port 8899.';
    platformLog('bridge not loaded');
    return;
  }
  const health = await b.health();
  state.platformOnline = health.ok;
  $('platformStatus').textContent = health.ok
    ? `ONLINE · ${health.payload.platform.name} · OpenAI ${health.payload.openai.configured ? 'ready' : 'not configured'}`
    : `OFFLINE · ${health.payload?.error || 'platform unavailable'}`;
  platformLog(health.payload);
}

async function connectPlatform() {
  const token = $('operatorToken').value.trim();
  if (!token) return platformLog('operator token required');
  const result = await bridge().login(token, 'capsule-studio');
  if (result.ok) state.platformSession = result.payload.session;
  platformLog(result.payload);
  await refreshPlatform();
}

async function sendPlatformReceipt(type = 'capsule_studio_event', payload = {}) {
  const b = bridge();
  if (!b) return platformLog('bridge not loaded');
  const result = await b.receipt(type, { surface: 'capsule-studio', ...payload });
  platformLog(result.payload);
  return result;
}

async function refresh() {
  const health = await api('/api/health');
  $('serverStatus').textContent = health.ok ? 'LIVE' : 'DOWN';
  $('serverMeta').textContent = `${health.app} v${health.version}`;
  $('aiMeta').textContent = `AI: ${health.ai?.configured ? 'OPENAI KEY CONNECTED' : 'fallback mode'} · ${health.ai?.model || 'local'}`;

  const langs = await api('/api/languages');
  $('languages').innerHTML = langs.languages.map(l => `<span class="chip">${escapeHtml(l.label)}</span>`).join('');

  const templates = await api('/api/templates');
  $('templates').innerHTML = templates.templates.map(t => `<span class="chip">${t.label}</span>`).join('');

  const { workspaces } = await api('/api/workspaces');
  state.workspaces = workspaces;
  $('workspaces').innerHTML = workspaces.length ? workspaces.map(renderWorkspace).join('') : '<p>No workspaces yet. Build one with AI or create a template.</p>';
  log({ health, workspace_count: workspaces.length, platform_online: state.platformOnline });
}

function escapeHtml(value = '') {
  return String(value).replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
}

function renderWorkspace(ws) {
  const sample = ws.entry || (ws.template === 'python' ? 'hello.py' : ws.template === 'cpp' ? 'main.cpp' : ws.template === 'java' ? 'Main.java' : 'index.html');
  return `<article class="workspace">
    <h3>${escapeHtml(ws.name)}</h3>
    <p><strong>${escapeHtml(ws.template || 'workspace')}</strong> · ${escapeHtml(ws.source || 'template')}<br>${escapeHtml(ws.id)}</p>
    <div class="row">
      <button onclick="selectWorkspace('${ws.id}')">Edit</button>
      <button onclick="runFile('${ws.id}','${sample}')" class="secondary">Run</button>
      <button onclick="manifest('${ws.id}')" class="secondary">Manifest</button>
      <button onclick="deploy('${ws.id}')" class="secondary">Deploy Local</button>
      <a class="button" href="/preview/${ws.id}/${sample}" target="_blank">Preview</a>
      <a class="button" href="/deployed/${ws.id}/${sample}" target="_blank">Open Deployed</a>
    </div>
  </article>`;
}

function escapeHtml(value = '') {
  return String(value).replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
}

async function createWorkspace(template) {
  const name = template === 'web' ? 'Website Capsule' : `${template.toUpperCase()} Capsule`;
  const data = await api('/api/workspaces', { method: 'POST', body: JSON.stringify({ name, template }) });
  await sendPlatformReceipt('capsule_workspace_created', { id: data.id, name, template }).catch(() => null);
  log(data);
  await refresh();
  await selectWorkspace(data.id);
}

async function registerWorkspaceWithPlatform(workspaceId) {
  const ws = state.workspaces.find((item) => item.id === workspaceId);
  if (!ws) return platformLog('workspace not found');
  const result = await sendPlatformReceipt('capsule_workspace_registered', {
    id: ws.id,
    name: ws.name,
    template: ws.template,
    entry: ws.entry || 'index.html'
  });
  return result;
}

async function buildAiApp() {
  const prompt = $('aiPrompt').value.trim();
  if (!prompt) return log('Type the app you want first.');
  $('buildAiApp').disabled = true;
  $('buildAiApp').textContent = 'Building...';
  try {
    const data = await api('/api/ai/build-app', { method: 'POST', body: JSON.stringify({ prompt }) });
    await sendPlatformReceipt('capsule_ai_app_built', { prompt, workspace: data.workspace?.id, deployed: Boolean(data.deployment?.url) }).catch(() => null);
    log(data);
    await refresh();
    await selectWorkspace(data.workspace.id);
    if (data.deployment?.url) window.open(data.deployment.url, '_blank');
  } finally {
    $('buildAiApp').disabled = false;
    $('buildAiApp').textContent = 'Build App';
  }
}

async function selectWorkspace(workspaceId) {
  state.activeWorkspaceId = workspaceId;
  const ws = state.workspaces.find(w => w.id === workspaceId) || { id: workspaceId, name: workspaceId };
  $('editorTitle').textContent = ws.name;
  $('editorMeta').textContent = `${ws.id} · ${ws.template || 'workspace'} · ${ws.source || 'operator'}`;
  const data = await api(`/api/workspace/files?workspaceId=${encodeURIComponent(workspaceId)}`);
  $('fileList').innerHTML = data.files.map(file => `<button class="fileButton" onclick="openFile('${workspaceId}','${file.path}')">${escapeHtml(file.path)} <small>${file.bytes}b</small></button>`).join('') || 'No files.';
  const entry = ws.entry || data.files[0]?.path || 'index.html';
  if (entry) await openFile(workspaceId, entry);
}

async function openFile(workspaceId, file) {
  state.activeWorkspaceId = workspaceId;
  state.activeFile = file;
  $('activeFile').value = file;
  const data = await api(`/api/workspace/file?workspaceId=${encodeURIComponent(workspaceId)}&file=${encodeURIComponent(file)}`);
  $('fileContent').value = data.content;
  log({ opened: file, workspaceId });
}

async function saveFile() {
  if (!state.activeWorkspaceId) return log('Select a workspace first.');
  const file = $('activeFile').value.trim();
  if (!file) return log('Enter a file path.');
  const data = await api('/api/workspace/file', { method: 'PUT', body: JSON.stringify({ workspaceId: state.activeWorkspaceId, file, content: $('fileContent').value }) });
  log(data);
  await selectWorkspace(state.activeWorkspaceId);
}

async function loadActiveFile() {
  if (!state.activeWorkspaceId) return log('Select a workspace first.');
  await openFile(state.activeWorkspaceId, $('activeFile').value.trim());
}

async function runActiveFile() {
  if (!state.activeWorkspaceId) return log('Select a workspace first.');
  await runFile(state.activeWorkspaceId, $('activeFile').value.trim());
}

async function runFile(workspaceId, file) {
  const data = await api('/api/run', { method: 'POST', body: JSON.stringify({ workspaceId, file }) });
  await sendPlatformReceipt('capsule_file_run', { workspaceId, file, ok: data.ok !== false }).catch(() => null);
  log(data);
}

async function manifest(workspaceId) {
  const data = await api('/api/manifest', { method: 'POST', body: JSON.stringify({ workspaceId }) });
  await sendPlatformReceipt('capsule_manifest_generated', { workspaceId }).catch(() => null);
  log(data);
}

async function deploy(workspaceId) {
  const data = await api('/api/deploy/local', { method: 'POST', body: JSON.stringify({ workspaceId }) });
  await sendPlatformReceipt('capsule_local_deploy', { workspaceId, url: data.url || null }).catch(() => null);
  log(data);
  if (data.url) window.open(data.url, '_blank');
}

$('createWeb').addEventListener('click', () => createWorkspace('web'));
$('createPython').addEventListener('click', () => createWorkspace('python'));
$('refresh').addEventListener('click', async () => { await refreshPlatform().catch(() => null); await refresh(); });
$('connectPlatform').addEventListener('click', () => connectPlatform().catch(err => platformLog(err.message)));
$('sendPlatformReceipt').addEventListener('click', () => sendPlatformReceipt('capsule_operator_ping', { at: new Date().toISOString() }).catch(err => platformLog(err.message)));
$('buildAiApp').addEventListener('click', buildAiApp);
$('saveFile').addEventListener('click', saveFile);
$('loadFile').addEventListener('click', loadActiveFile);
$('runActive').addEventListener('click', runActiveFile);
$('samplePrompt').addEventListener('click', () => {
  $('aiPrompt').value = 'Build a polished dashboard app for a construction company that tracks active projects, revenue, crew status, safety, and next actions.';
});

window.addEventListener('nova-platform-bridge-ready', () => refreshPlatform().catch(err => platformLog(err.message)));
refreshPlatform().catch(err => platformLog(err.message)).finally(() => refresh().catch(err => log(err.message)));
