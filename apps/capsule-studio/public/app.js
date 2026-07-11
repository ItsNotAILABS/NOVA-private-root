const $ = (id) => document.getElementById(id);
const log = (value) => { $('log').textContent = typeof value === 'string' ? value : JSON.stringify(value, null, 2); };

async function api(path, options = {}) {
  const res = await fetch(path, { headers: { 'content-type': 'application/json' }, ...options });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || data.message || 'request failed');
  return data;
}

async function refresh() {
  const health = await api('/api/health');
  $('serverStatus').textContent = health.ok ? 'LIVE' : 'DOWN';
  $('serverMeta').textContent = `${health.app} v${health.version}`;
  $('aiMeta').textContent = `AI: ${health.ai ? 'OPENAI KEY CONNECTED' : 'fallback mode'} · ${health.model}`;

  const langs = await api('/api/languages');
  $('languages').innerHTML = langs.languages.map(l => `<span class="chip">${l.label}</span>`).join('');

  const { workspaces } = await api('/api/workspaces');
  $('workspaces').innerHTML = workspaces.length ? workspaces.map(renderWorkspace).join('') : '<p>No workspaces yet. Build one with AI or create a template.</p>';
  log({ health, workspace_count: workspaces.length });
}

function renderWorkspace(ws) {
  const sample = ws.template === 'python' ? 'hello.py' : ws.template === 'cpp' ? 'main.cpp' : ws.template === 'java' ? 'Main.java' : 'index.html';
  return `<article class="workspace">
    <h3>${ws.name}</h3>
    <p><strong>${ws.template || 'workspace'}</strong> · ${ws.source || 'template'}<br>${ws.id}</p>
    <div class="row">
      <button onclick="runFile('${ws.id}','${sample}')">Run</button>
      <button onclick="manifest('${ws.id}')" class="secondary">Manifest</button>
      <button onclick="deploy('${ws.id}')" class="secondary">Deploy Local</button>
      <a class="button" href="/preview/${ws.id}/index.html" target="_blank">Preview</a>
      <a class="button" href="/deployed/${ws.id}/index.html" target="_blank">Open Deployed</a>
    </div>
  </article>`;
}

async function createWorkspace(template) {
  const name = template === 'web' ? 'Website Capsule' : `${template.toUpperCase()} Capsule`;
  const data = await api('/api/workspaces', { method: 'POST', body: JSON.stringify({ name, template }) });
  log(data);
  await refresh();
}

async function buildAiApp() {
  const prompt = $('aiPrompt').value.trim();
  if (!prompt) return log('Type the app you want first.');
  $('buildAiApp').disabled = true;
  $('buildAiApp').textContent = 'Building...';
  try {
    const data = await api('/api/ai/build-app', { method: 'POST', body: JSON.stringify({ prompt }) });
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
  log(data);
}

async function manifest(workspaceId) {
  const data = await api('/api/manifest', { method: 'POST', body: JSON.stringify({ workspaceId }) });
  log(data);
}

async function deploy(workspaceId) {
  const data = await api('/api/deploy/local', { method: 'POST', body: JSON.stringify({ workspaceId }) });
  log(data);
  if (data.url) window.open(data.url, '_blank');
}

$('createWeb').addEventListener('click', () => createWorkspace('web'));
$('createPython').addEventListener('click', () => createWorkspace('python'));
$('refresh').addEventListener('click', refresh);
$('buildAiApp').addEventListener('click', buildAiApp);
$('samplePrompt').addEventListener('click', () => {
  $('aiPrompt').value = 'Build a polished dashboard app for a construction company that tracks active projects, revenue, crew status, safety, and next actions.';
});
refresh().catch(err => log(err.message));
