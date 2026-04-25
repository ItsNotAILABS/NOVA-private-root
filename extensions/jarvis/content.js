/**
 * JARVIS — Content Script
 * Floating panel injected into every page.
 * Arc reactor indicator + thinking animation while Phantom AI reasons.
 */

(function() {
  'use strict';
  if (document.getElementById('jarvis-root')) return;

  /* ── Constants ─────────────────────────────────────────────────────────── */
  const PHI_INV = 0.6180339887498948482;
  let lastPulse  = null;
  let panelOpen  = false;

  /* ── Styles ────────────────────────────────────────────────────────────── */
  const style = document.createElement('style');
  style.textContent = `
    #jarvis-root { all: initial; }
    #jarvis-arc {
      position: fixed; bottom: 24px; right: 24px; z-index: 2147483647;
      width: 52px; height: 52px; cursor: pointer;
      background: radial-gradient(circle, rgba(0,212,255,0.15) 0%, rgba(0,0,20,0.95) 60%);
      border: 2px solid rgba(0,212,255,0.4);
      border-radius: 50%;
      box-shadow: 0 0 16px rgba(0,212,255,0.3), inset 0 0 16px rgba(0,212,255,0.1);
      display: flex; align-items: center; justify-content: center;
      font-size: 22px;
      transition: all .3s;
      user-select: none;
    }
    #jarvis-arc:hover { box-shadow: 0 0 28px rgba(0,212,255,0.6), inset 0 0 20px rgba(0,212,255,0.2); transform: scale(1.08); }
    #jarvis-arc.thinking { animation: jarvis-pulse 0.873s ease-in-out infinite; }
    @keyframes jarvis-pulse {
      0%   { box-shadow: 0 0 16px rgba(0,212,255,0.3); border-color: rgba(0,212,255,0.4); }
      50%  { box-shadow: 0 0 40px rgba(212,175,55,0.8); border-color: rgba(212,175,55,0.8); }
      100% { box-shadow: 0 0 16px rgba(0,212,255,0.3); border-color: rgba(0,212,255,0.4); }
    }
    #jarvis-beat {
      position: absolute; bottom: -4px; right: -4px;
      background: rgba(16,185,129,0.9); color: white;
      font-family: monospace; font-size: 8px;
      padding: 1px 3px; border-radius: 3px;
      pointer-events: none;
    }

    #jarvis-panel {
      position: fixed; bottom: 86px; right: 24px; z-index: 2147483646;
      width: 340px; max-height: 480px;
      background: rgba(5,5,15,0.97);
      border: 1px solid rgba(0,212,255,0.2);
      border-radius: 12px;
      box-shadow: 0 8px 40px rgba(0,0,0,0.6), 0 0 20px rgba(0,212,255,0.05);
      font-family: 'SF Mono','Fira Code',monospace;
      display: none; flex-direction: column;
      overflow: hidden;
    }
    #jarvis-panel.open { display: flex; }

    .jp-header {
      background: linear-gradient(135deg, rgba(0,212,255,0.08), rgba(212,175,55,0.05));
      padding: .6rem 1rem;
      border-bottom: 1px solid rgba(0,212,255,0.1);
      display: flex; align-items: center; justify-content: space-between;
    }
    .jp-title { color: #D4AF37; font-size: .75rem; font-weight: 700; letter-spacing: .1em; }
    .jp-close { color: #555; cursor: pointer; font-size: 14px; }
    .jp-close:hover { color: #fff; }

    .jp-thinking {
      padding: .5rem 1rem;
      background: rgba(0,0,0,0.2);
      border-bottom: 1px solid rgba(255,255,255,0.03);
      font-size: .55rem; color: #555;
      display: none;
    }
    .jp-thinking.active { display: flex; align-items: center; gap: .5rem; color: #D4AF37; }
    .jp-thinking-dots { animation: jp-dots 0.873s infinite; }
    @keyframes jp-dots { 0% { content: '.' } 33% { content: '..' } 66% { content: '...' } }

    .jp-arch-bar {
      display: flex; gap: .25rem; padding: .4rem 1rem;
      border-bottom: 1px solid rgba(255,255,255,0.03);
    }
    .jp-arch { font-size: .55rem; padding: .15rem .35rem; border-radius: 3px; color: #888; cursor: default; }

    .jp-brain {
      padding: .5rem 1rem;
      border-bottom: 1px solid rgba(255,255,255,0.03);
    }
    .jp-brain-row { display: flex; align-items: center; gap: .4rem; margin-bottom: 2px; }
    .jp-brain-name { font-size: .5rem; color: #444; width: 52px; }
    .jp-brain-bar { flex: 1; height: 2px; background: #111; border-radius: 1px; }
    .jp-brain-fill { height: 100%; background: #00D4FF; border-radius: 1px; transition: width .873s; }

    .jp-thoughts {
      flex: 1; overflow-y: auto; padding: .5rem 1rem;
      scrollbar-width: thin; scrollbar-color: #222 transparent;
    }
    .jp-thought {
      margin-bottom: .5rem; padding: .4rem .5rem;
      background: rgba(255,255,255,0.02);
      border-radius: 4px; border-left: 2px solid #333;
    }
    .jp-thought .arch { font-size: .5rem; color: #D4AF37; }
    .jp-thought .query { font-size: .58rem; color: #999; margin-top: .1rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .jp-thought .conf { font-size: .5rem; color: #666; }

    .jp-input-row {
      padding: .5rem 1rem;
      border-top: 1px solid rgba(255,255,255,0.04);
      display: flex; gap: .4rem;
    }
    .jp-input {
      flex: 1; background: rgba(255,255,255,0.04);
      border: 1px solid rgba(255,255,255,0.06); border-radius: 5px;
      color: #ddd; font-family: inherit; font-size: .6rem; padding: .3rem .5rem;
      outline: none;
    }
    .jp-input:focus { border-color: rgba(0,212,255,0.3); }
    .jp-send {
      background: rgba(0,212,255,0.1); border: 1px solid rgba(0,212,255,0.2);
      border-radius: 5px; color: #00D4FF; font-size: .55rem;
      padding: .3rem .5rem; cursor: pointer;
    }
    .jp-send:hover { background: rgba(0,212,255,0.2); }

    .jp-status-bar {
      padding: .25rem 1rem;
      font-size: .5rem; color: #333; letter-spacing: .05em;
      background: rgba(0,0,0,0.3);
      display: flex; justify-content: space-between;
    }
  `;
  document.head.appendChild(style);

  /* ── DOM ────────────────────────────────────────────────────────────────── */
  const root = document.createElement('div');
  root.id = 'jarvis-root';
  root.innerHTML = `
    <div id="jarvis-arc" title="JARVIS — Click to toggle">⚡<span id="jarvis-beat">0</span></div>
    <div id="jarvis-panel">
      <div class="jp-header">
        <div class="jp-title">⚡ JARVIS · PHANTOMA AI</div>
        <div class="jp-close" id="jp-close">✕</div>
      </div>
      <div class="jp-thinking" id="jp-thinking">
        <span>🧠 PHANTOM AI THINKING</span><span class="jp-thinking-dots">...</span>
      </div>
      <div class="jp-arch-bar" id="jp-arch-bar">
        <span class="jp-arch" title="Reasoning">🧠 RATIO</span>
        <span class="jp-arch" title="Creation">🎨 CREAT</span>
        <span class="jp-arch" title="Perception">📊 PERCP</span>
        <span class="jp-arch" title="Protection">🛡️ CUST</span>
        <span class="jp-arch" title="Command">🌀 IMPER</span>
      </div>
      <div class="jp-brain" id="jp-brain">
        ${['Sensory','Associative','Executive','Motor','Memory'].map((n,i) =>
          `<div class="jp-brain-row">
            <span class="jp-brain-name">${n.substring(0,5).toUpperCase()}</span>
            <div class="jp-brain-bar"><div class="jp-brain-fill" id="jpbf-${i}" style="width:0%"></div></div>
          </div>`).join('')}
      </div>
      <div class="jp-thoughts" id="jp-thoughts">
        <div style="font-size:.5rem;color:#333;text-align:center;padding:.5rem;">
          PHANTOM AI INITIALIZING…
        </div>
      </div>
      <div class="jp-input-row">
        <input class="jp-input" id="jp-input" placeholder="Ask JARVIS anything…" type="text">
        <button class="jp-send" id="jp-send">THINK</button>
      </div>
      <div class="jp-status-bar">
        <span id="jp-beat">BEAT 0</span>
        <span id="jp-cohere">COHERENCE —</span>
        <span id="jp-thoughts-count">THOUGHTS 0</span>
      </div>
    </div>
  `;
  document.body.appendChild(root);

  const arc    = document.getElementById('jarvis-arc');
  const panel  = document.getElementById('jarvis-panel');
  const close  = document.getElementById('jp-close');
  const input  = document.getElementById('jp-input');
  const send   = document.getElementById('jp-send');
  const think  = document.getElementById('jp-thinking');

  /* ── Toggle panel ───────────────────────────────────────────────────────── */
  arc.addEventListener('click', () => {
    panelOpen = !panelOpen;
    panel.className = panelOpen ? 'open' : '';
  });
  close.addEventListener('click', () => { panelOpen = false; panel.className = ''; });

  /* ── Send query ─────────────────────────────────────────────────────────── */
  function sendQuery() {
    const q = input.value.trim();
    if (!q) return;
    input.value = '';
    arc.classList.add('thinking');
    think.classList.add('active');
    chrome.runtime.sendMessage({ type: 'THINK', query: q }, response => {
      arc.classList.remove('thinking');
      think.classList.remove('active');
      if (response && response.thought) renderThought(response.thought);
    });
  }
  send.addEventListener('click', sendQuery);
  input.addEventListener('keydown', e => { if (e.key === 'Enter') sendQuery(); });

  /* ── Render thought ─────────────────────────────────────────────────────── */
  function renderThought(t) {
    const el = document.createElement('div');
    el.className = 'jp-thought';
    el.style.borderLeftColor = t.architecture ? t.architecture.color : '#333';
    el.innerHTML = `
      <div class="arch">${t.architecture ? t.architecture.icon : '🧠'} ${t.arch || 'RATIONIS'}</div>
      <div class="query">${(t.query || '').substring(0, 80)}</div>
      <div class="conf">CONFIDENCE ${t.reflection ? t.reflection.confidence : '—'} · ${t.reflection ? t.reflection.reflection.substring(0,40) : ''}</div>
    `;
    const container = document.getElementById('jp-thoughts');
    container.insertBefore(el, container.firstChild);
    while (container.children.length > 8) container.removeChild(container.lastChild);
  }

  /* ── Listen for pulses ──────────────────────────────────────────────────── */
  chrome.runtime.onMessage.addListener(msg => {
    if (!msg || msg.type !== 'JARVIS_PULSE') return;
    lastPulse = msg;

    /* Beat */
    const beatEl = document.getElementById('jarvis-beat');
    if (beatEl) beatEl.textContent = msg.beat;
    const beatEl2 = document.getElementById('jp-beat');
    if (beatEl2) beatEl2.textContent = 'BEAT ' + msg.beat;

    /* Brain bars */
    if (msg.brain && msg.brain.regions) {
      msg.brain.regions.forEach((r, i) => {
        const bar = document.getElementById('jpbf-' + i);
        if (bar) bar.style.width = (r.activation * 100).toFixed(0) + '%';
      });
    }

    /* Coherence */
    const cEl = document.getElementById('jp-cohere');
    if (cEl && msg.brain) cEl.textContent = 'COHERE ' + (msg.brain.coherenceField || 0).toFixed(3);

    /* Thoughts count */
    const tcEl = document.getElementById('jp-thoughts-count');
    if (tcEl && msg.phantom) tcEl.textContent = 'THOUGHTS ' + msg.phantom.totalThoughts;

    /* Auto-render recent thought */
    if (msg.phantom && msg.phantom.recentThoughts && msg.phantom.recentThoughts.length > 0) {
      const latest = msg.phantom.recentThoughts[0];
      if (latest && (!lastPulse || lastPulse.beat !== msg.beat)) {
        /* Only render every few beats to avoid spam */
        if (msg.beat % 5 === 0 && latest.query) renderThought(latest);
      }
    }
  });

})();
