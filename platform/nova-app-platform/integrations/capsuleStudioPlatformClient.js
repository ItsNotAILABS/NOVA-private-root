export function createPlatformClient({ baseUrl = process.env.NOVA_PLATFORM_URL || "http://127.0.0.1:8899", operatorToken = process.env.NOVA_OPERATOR_TOKEN || "" } = {}) {
  async function request(path, options = {}) {
    const headers = {
      "content-type": "application/json",
      ...(options.headers || {})
    };
    if (operatorToken) headers["x-nova-operator-token"] = operatorToken;
    const response = await fetch(baseUrl + path, { ...options, headers });
    const payload = await response.json().catch(() => ({ ok: false, error: "invalid_json_response" }));
    return { ok: response.ok, status: response.status, payload };
  }

  return {
    baseUrl,
    health: () => request("/api/health"),
    dashboard: () => request("/api/dashboard"),
    apps: () => request("/api/apps"),
    surfaces: () => request("/api/surfaces"),
    writeReceipt: (type, payload) => request("/api/operator/receipt", {
      method: "POST",
      body: JSON.stringify({ type, payload })
    }),
    ask: (input, appId = "capsule-studio") => request("/api/ai/respond", {
      method: "POST",
      body: JSON.stringify({ input, appId })
    })
  };
}

export async function registerCapsuleStudioSession({ workspaceId, capsuleId, event = "capsule_studio_session" } = {}) {
  const client = createPlatformClient();
  return client.writeReceipt(event, {
    appId: "capsule-studio",
    workspaceId: workspaceId || null,
    capsuleId: capsuleId || null,
    timestamp: new Date().toISOString()
  });
}
