const api = async (path, options = {}) => {
  const response = await fetch(path, {
    ...options,
    headers:{ 'content-type':'application/json', ...(options.headers || {}) }
  });
  const payload = await response.json();
  if (!response.ok) throw new Error(payload.error || `request failed (${response.status})`);
  return payload;
};

const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, char => ({ '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;' }[char]));
const content = () => document.querySelector('#content');
const title = () => document.querySelector('#pageTitle');

function badge(value) {
  return `<span class="pill">${escapeHtml(value)}</span>`;
}

function metric(label, value, detail) {
  return `<article class="card"><div class="sub">${escapeHtml(label)}</div><div class="metric">${escapeHtml(value)}</div><div class="sub">${escapeHtml(detail)}</div></article>`;
}

function connectionCard(profile) {
  const config = Object.entries(profile.config || {}).map(([key, value]) => `<div class="row"><span>${escapeHtml(key)}</span><b>${escapeHtml(value)}</b></div>`).join('');
  return `<article class="card"><div class="row"><div><b>${escapeHtml(profile.label)}</b><div class="sub">${escapeHtml(profile.provider)} · ${escapeHtml(profile.environment)}</div></div>${badge(profile.status)}</div><div class="list" style="margin-top:14px">${config || '<div class="sub">No configuration fields.</div>'}</div><div class="actions" style="margin-top:14px"><button data-test-connection="${profile.id}">Test connection</button></div>${profile.last_test ? `<pre class="terminal">${escapeHtml(JSON.stringify(profile.last_test, null, 2))}</pre>` : ''}</article>`;
}

async function renderBackend() {
  title().textContent = 'Backend Operations';
  content().innerHTML = '<article class="card"><h3>Loading backend runtime…</h3></article>';
  try {
    const [platform, jobs, adapters, events, reconciliations] = await Promise.all([
      api('/api/v1/platform'),
      api('/api/v1/jobs'),
      api('/api/v1/adapters'),
      api('/api/v1/events?limit=30'),
      api('/api/v1/reconciliations')
    ]);
    const p = platform.platform;
    const profiles = p.connections.profiles || [];
    content().innerHTML = `
      <section class="hero">
        <div class="eyebrow">BACKEND-FIRST CONTROL PLANE</div>
        <h2>Every interface is now backed by a governed runtime contract.</h2>
        <p>API authentication, durable jobs, adapter profiles, TradingView links, connection tests, event history, idempotent mutations, reconciliation, atomic persistence, and cryptographic receipts.</p>
        <div class="actions"><button class="primary" id="openTradingViewNative">Open TradingView</button><button id="runReconciliation">Run reconciliation</button><button id="createAutomation">Create bot automation</button><button id="addConnection">Add connection</button></div>
      </section>
      <div class="grid kpis">
        ${metric('Schema', p.schema, p.execution_mode)}
        ${metric('Jobs', p.runtime.jobs.total, `${p.runtime.jobs.enabled} enabled`)}
        ${metric('Connections', p.connections.total, `${p.connections.online} online`)}
        ${metric('Receipt chain', p.receipt_chain_valid ? 'VERIFIED' : 'INVALID', 'SHA-256 linked')}
      </div>
      <div class="grid two" style="margin-top:18px">
        <article class="card"><h3>Automation Jobs</h3>${jobs.jobs.length ? jobs.jobs.map(job => `<div class="row"><div><b>${escapeHtml(job.name)}</b><div class="sub">${escapeHtml(job.schedule)} · ${job.run_count} runs · ${job.failure_count} failures</div></div><div class="actions">${badge(job.enabled ? 'enabled' : 'paused')}<button data-run-job="${job.id}">Run</button></div></div>`).join('') : '<p class="sub">No durable jobs yet.</p>'}</article>
        <article class="card"><h3>Runtime Status</h3><pre class="terminal">${escapeHtml(JSON.stringify(p.runtime, null, 2))}</pre></article>
      </div>
      <h2 style="margin-top:24px">Connection Profiles</h2>
      <div class="grid three">${profiles.length ? profiles.map(connectionCard).join('') : '<article class="card"><h3>No profiles configured</h3><p class="sub">Add TradingView, Alpaca paper, IBKR gateway, Coinbase, Kraken, or MT5 bridge metadata using secret references.</p></article>'}</div>
      <div class="grid two" style="margin-top:18px">
        <article class="card"><h3>Adapter Catalog</h3>${adapters.adapters.map(adapter => `<div class="row"><div><b>${escapeHtml(adapter.id.toUpperCase())}</b><div class="sub">${escapeHtml(adapter.type)} · ${adapter.capabilities.join(', ')}</div></div>${badge(adapter.live_execution ? 'live' : 'gated')}</div>`).join('')}</article>
        <article class="card"><h3>Recent Backend Events</h3>${events.events.length ? events.events.map(event => `<div class="row"><div><b>${escapeHtml(event.topic)}</b><div class="sub">${new Date(event.created_at).toLocaleString()}</div></div>${badge(event.metadata?.actor || 'system')}</div>`).join('') : '<p class="sub">No backend events yet.</p>'}</article>
      </div>
      <article class="card" style="margin-top:18px"><h3>Reconciliation Reports</h3>${reconciliations.reconciliations.length ? reconciliations.reconciliations.map(report => `<div class="row"><div><b>${escapeHtml(report.status)}</b><div class="sub">recorded ${report.recorded_nav} · computed ${report.computed_nav} · difference ${report.difference}</div></div>${badge(new Date(report.created_at).toLocaleString())}</div>`).join('') : '<p class="sub">Run the first portfolio reconciliation.</p>'}</article>
    `;
    wireBackendActions(platform);
  } catch (error) {
    content().innerHTML = `<article class="card"><h3>Backend unavailable</h3><pre class="terminal">${escapeHtml(error.message)}</pre></article>`;
  }
}

function promptJson(titleText, defaults) {
  const text = window.prompt(`${titleText}\nEdit JSON:`, JSON.stringify(defaults, null, 2));
  if (!text) return null;
  return JSON.parse(text);
}

function wireBackendActions(platform) {
  document.querySelector('#openTradingViewNative')?.addEventListener('click', async () => {
    const result = await api('/api/v1/tradingview/link?symbol=COINBASE:BTCUSD&interval=15');
    window.open(result.url, '_blank', 'noopener,noreferrer');
  });
  document.querySelector('#runReconciliation')?.addEventListener('click', async () => {
    await api('/api/v1/reconciliations', { method:'POST', body:'{}' });
    await renderBackend();
  });
  document.querySelector('#createAutomation')?.addEventListener('click', async () => {
    const state = await api('/api/state');
    const bot = state.state.bots[0];
    const input = promptJson('Create durable automation', { name:`${bot?.name || 'Bot'} automation`, bot_id:bot?.id, schedule:'manual', enabled:true, max_attempts:3, payload:{ notional:1000 } });
    if (!input) return;
    await api('/api/v1/jobs', { method:'POST', body:JSON.stringify(input) });
    await renderBackend();
  });
  document.querySelector('#addConnection')?.addEventListener('click', async () => {
    const input = promptJson('Add connection profile', { provider:'tradingview', label:'TradingView', environment:'paper', config:{ webhook_token_ref:'env:PARALLAX_TRADINGVIEW_TOKEN' } });
    if (!input) return;
    await api('/api/v1/connections', { method:'POST', body:JSON.stringify(input) });
    await renderBackend();
  });
  document.querySelectorAll('[data-run-job]').forEach(button => button.addEventListener('click', async () => {
    await api(`/api/v1/jobs/${button.dataset.runJob}/run`, { method:'POST', body:'{}' });
    await renderBackend();
  }));
  document.querySelectorAll('[data-test-connection]').forEach(button => button.addEventListener('click', async () => {
    try { await api(`/api/v1/connections/${button.dataset.testConnection}/test`, { method:'POST', body:'{}' }); }
    catch (error) { console.warn(error.message); }
    await renderBackend();
  }));
}

function installBackendNavigation() {
  const nav = document.querySelector('#nav');
  if (!nav || nav.querySelector('[data-backend-console]')) return;
  const button = document.createElement('button');
  button.className = 'nav-item';
  button.dataset.backendConsole = 'true';
  button.textContent = 'Backend';
  button.addEventListener('click', event => {
    event.preventDefault();
    document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
    button.classList.add('active');
    renderBackend();
  });
  nav.appendChild(button);
}

const observer = new MutationObserver(installBackendNavigation);
observer.observe(document.documentElement, { childList:true, subtree:true });
installBackendNavigation();
