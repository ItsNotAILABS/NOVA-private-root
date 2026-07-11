/* NOVA App Platform Browser Bridge
 * Include from NOVA Phone or Capsule Studio with:
 * <script src="http://127.0.0.1:8899/public/platform-bridge.js"></script>
 */
(function () {
  const defaultBaseUrl = "http://127.0.0.1:8899";

  function baseUrl() {
    return window.NOVA_PLATFORM_URL || defaultBaseUrl;
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
    if (!res.ok) return { ok: false, status: res.status, payload };
    return { ok: true, status: res.status, payload };
  }

  function tokenHeader(token) {
    const resolved = token || window.NOVA_OPERATOR_TOKEN || "";
    return resolved ? { "x-nova-operator-token": resolved } : {};
  }

  window.NOVAPlatformBridge = {
    baseUrl,
    health: () => request("/api/health"),
    dashboard: () => request("/api/dashboard"),
    apps: () => request("/api/apps"),
    surfaces: () => request("/api/surfaces"),
    receipt: (type, payload, token) => request("/api/operator/receipt", {
      method: "POST",
      headers: tokenHeader(token),
      body: JSON.stringify({ type, payload })
    }),
    ask: (input, appId, token) => request("/api/ai/respond", {
      method: "POST",
      headers: tokenHeader(token),
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
})();
