const $ = (id) => document.getElementById(id);
const state = { workspaces: [], platformOnline: false, platformSession: null };
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
  $('aiMeta').textContent = `AI: ${health.ai ? 'OPENAI KEY CONNECTED' : 'fallback mode'} · ${health.model}`;

  const langs = await api('/api/languages');
  $('languages').innerHTML = langs.languages.map(l => `<span class="chip">${escapeHtml(l.label)}</span>`).join('');

  const { workspaces } = await api('/api/workspaces');
  state.workspaces = workspaces;
  $('workspaces').innerHTML = workspaces.length ? workspaces.map(renderWorkspace).join('') : '<p>No workspaces yet. Build one with AI or create a template.</p>';
  log({ health, workspace_count: workspaces.length, platform_online: state.platformOnline });
}

function escapeHtml(value = '') {
  return String(value).replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
}

function renderWorkspace(ws) {
  const sample = ws.template === 'python' ? 'hello.py' : ws.template === 'cpp' ? 'main.cpp' : ws.template === 'java' ? 'Main.java' : 'index.html';
  return `<article class="workspace">
    <h3>${escapeHtml(ws.name)}</h3>
    <p><strong>${escapeHtml(ws.template || 'workspace')}</strong> · ${escapeHtml(ws.source || 'template')}<br>${escapeHtml(ws.id)}</p>
    <div class="row">
      <button onclick="runFile('${ws.id}','${sample}')">Run</button>
      <button onclick="manifest('${ws.id}')" class="secondary">Manifest</button>
      <button onclick="deploy('${ws.id}')" class="secondary">Deploy Local</button>
      <button onclick="registerWorkspaceWithPlatform('${ws.id}')" class="secondary">Register Platform</button>
      <a class="button" href="/preview/${ws.id}/index.html" target="_blank">Preview</a>
      <a class="button" href="/deployed/${ws.id}/index.html" target="_blank">Open Deployed</a>
    </div>
  </article>`;
}

async function createWorkspace(template) {
  const name = template === 'web' ? 'Website Capsule' : `${template.toUpperCase()} Capsule`;
  const data = await api('/api/workspaces', { method: 'POST', body: JSON.stringify({ name, template }) });
  await sendPlatformReceipt('capsule_workspace_created', { id: data.id, name, template }).catch(() => null);
  log(data);
  await refresh();
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
    if (data.deployment?.url) window.open(data.deployment.url, '_blank');
  } finally {
    $('buildAiApp').disabled = false;
    $('buildAiApp').textContent = 'Build App';
  }
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
$('samplePrompt').addEventListener('click', () => {
  $('aiPrompt').value = 'Build a polished dashboard app for a construction company that tracks active projects, revenue, crew status, safety, and next actions.';
});

window.addEventListener('nova-platform-bridge-ready', () => refreshPlatform().catch(err => platformLog(err.message)));
refreshPlatform().catch(err => platformLog(err.message)).finally(() => refresh().catch(err => log(err.message)));
