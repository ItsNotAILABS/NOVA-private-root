const statusEl = document.getElementById("status");
const appsEl = document.getElementById("apps");
const gatewayEl = document.getElementById("gateway");
const promptEl = document.getElementById("prompt");

async function json(path, options) {
  const res = await fetch(path, options);
  return res.json();
}

function renderApps(apps) {
  appsEl.innerHTML = apps.map((app) => `
    <div class="app-card">
      <strong>${app.name}</strong>
      <span>${app.id}</span>
      <small>${app.description}</small>
    </div>
  `).join("");
}

async function refresh() {
  const dashboard = await json("/api/dashboard");
  statusEl.textContent = JSON.stringify(dashboard, null, 2);
  renderApps(dashboard.apps || []);
}

async function askGateway() {
  const token = window.prompt("Operator token", "local-operator-token");
  const input = promptEl.value || "Say NOVA App Platform is online and list its core surfaces.";
  const result = await json("/api/ai/respond", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-nova-operator-token": token || ""
    },
    body: JSON.stringify({ input })
  });
  gatewayEl.textContent = JSON.stringify(result, null, 2);
}

document.getElementById("refresh").addEventListener("click", refresh);
document.getElementById("ask").addEventListener("click", askGateway);
refresh();
