const browserAIState = { token: localStorage.getItem("nova_operator_token") || "", session: localStorage.getItem("nova_platform_session") || "" };
const $ = (id) => document.getElementById(id);

async function api(path, options = {}) {
  const headers = { "content-type": "application/json", ...(options.headers || {}) };
  if (browserAIState.session) headers.authorization = `Bearer ${browserAIState.session}`;
  if (!browserAIState.session && browserAIState.token) headers["x-nova-operator-token"] = browserAIState.token;
  const response = await fetch(path, { ...options, headers });
  const payload = await response.json().catch(() => ({ ok: false, error: "invalid_json" }));
  if (!response.ok) throw new Error(payload.error || `http_${response.status}`);
  return payload;
}

function pageSnapshot() {
  const headings = [...document.querySelectorAll("h1,h2,h3")].slice(0, 20).map((node) => ({ tag: node.tagName, text: node.innerText.slice(0, 120) }));
  return {
    title: document.title,
    url: location.href,
    text: document.body.innerText.slice(0, 5000),
    headings,
    wordCount: document.body.innerText.split(/\s+/).filter(Boolean).length,
    linkCount: document.querySelectorAll("a").length,
    imageCount: document.querySelectorAll("img").length
  };
}

async function refresh() {
  const status = await api("/api/browser-ai/status");
  $("status").textContent = JSON.stringify(status.browserAI, null, 2);
  $("agents").innerHTML = status.browserAI.agents.map((agent) => `<p><strong>${agent.name}</strong><br><small>${agent.domain}</small></p>`).join("");
  const history = await api("/api/browser-ai/history");
  $("history").textContent = JSON.stringify(history.history.slice(0, 8), null, 2);
}

async function runCommand() {
  const input = $("command").value.trim();
  if (!input) return;
  const payload = { input, context: { source: "browser-ai-page", page: pageSnapshot() } };
  const result = await api("/api/browser-ai/command", { method: "POST", body: JSON.stringify(payload) });
  $("result").textContent = JSON.stringify(result, null, 2);
  await refresh();
}

async function sendSnapshot() {
  const result = await api("/api/browser-ai/page-snapshot", { method: "POST", body: JSON.stringify({ page: pageSnapshot() }) });
  $("result").textContent = JSON.stringify(result, null, 2);
  await refresh();
}

window.addEventListener("nova-platform-bridge-ready", () => console.log("NOVA platform bridge ready"));
$("run").addEventListener("click", () => runCommand().catch((error) => $("result").textContent = error.message));
$("snapshot").addEventListener("click", () => sendSnapshot().catch((error) => $("result").textContent = error.message));
refresh().catch((error) => $("status").textContent = error.message);
