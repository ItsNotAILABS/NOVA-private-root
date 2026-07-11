/* NOVA App Platform Browser Bridge
 * Include from NOVA Phone or Capsule Studio with:
 * <script src="http://127.0.0.1:8899/public/platform-bridge.js"></script>
 */
(function () {
  const defaultBaseUrl = "http://127.0.0.1:8899";
  const sessionKey = "nova.platform.session";

  function baseUrl() {
    return window.NOVA_PLATFORM_URL || defaultBaseUrl;
  }

  function readSession() {
    try { return JSON.parse(localStorage.getItem(sessionKey) || "null"); } catch (_) { return null; }
  }

  function writeSession(session) {
    localStorage.setItem(sessionKey, JSON.stringify(session));
    return session;
  }

  function authHeaders(token) {
    if (token) return { "x-nova-operator-token": token };
    const session = readSession();
    if (session && session.id) return { authorization: "Bearer " + session.id };
    if (window.NOVA_OPERATOR_TOKEN) return { "x-nova-operator-token": window.NOVA_OPERATOR_TOKEN };
    return {};
  }

  async function request(path, options = {}) {
    const res = await fetch(baseUrl() + path, {
      ...options,
      headers: {
        "content-type": "application/json",
        ...(options.headers || {})
      }
    });
    const payload = await res.json().catch(() => ({ ok: false, error: "invalid_json_response" }));
    return { ok: res.ok && payload.ok !== false, status: res.status, payload };
  }

  const bridge = {
    baseUrl,
    readSession,
    clearSession: () => localStorage.removeItem(sessionKey),
    health: () => request("/api/health"),
    dashboard: () => request("/api/dashboard"),
    apps: async () => {
      const result = await request("/api/apps");
      return { ...result, apps: result.payload.apps || result.payload };
    },
    surfaces: () => request("/api/surfaces"),
    login: async (operatorToken, label) => {
      const result = await request("/api/session", {
        method: "POST",
        body: JSON.stringify({ operatorToken, label })
      });
      if (result.ok && result.payload.session) writeSession(result.payload.session);
      return result;
    },
    receipt: (type, payload, token) => request("/api/operator/receipt", {
      method: "POST",
      headers: authHeaders(token),
      body: JSON.stringify({ type, payload })
    }),
    ask: (input, appId, token) => request("/api/ai/respond", {
      method: "POST",
      headers: authHeaders(token),
      body: JSON.stringify({ input, appId })
    }),
    mountStatus: async function mountStatus(targetSelector) {
      const target = document.querySelector(targetSelector);
      if (!target) return { ok: false, error: "target_not_found" };
      const status = await this.dashboard();
      target.textContent = JSON.stringify(status.payload, null, 2);
      return status;
    }
  };

  window.NOVAPlatformBridge = bridge;
  window.dispatchEvent(new CustomEvent("nova-platform-bridge-ready", { detail: { baseUrl: baseUrl() } }));
})();
