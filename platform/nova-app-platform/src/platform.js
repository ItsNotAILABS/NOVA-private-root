import { defaultApps, normalizeApp } from "./appRegistry.js";

export function createNovaPlatform({ apps = defaultApps() } = {}) {
  const registeredApps = new Map();
  for (const app of apps) {
    const normalized = normalizeApp(app);
    registeredApps.set(normalized.id, normalized);
  }

  function status() {
    const values = [...registeredApps.values()];
    return {
      name: "NOVA App Platform",
      version: "0.1.0",
      mode: process.env.NODE_ENV || "local",
      appCount: values.length,
      enabledAppCount: values.filter((app) => app.enabled).length,
      surfaces: ["operator_console", "app_registry", "openai_gateway", "receipt_stream", "local_vault"]
    };
  }

  function listApps() {
    return [...registeredApps.values()].sort((a, b) => a.id.localeCompare(b.id));
  }

  function registerApp(app) {
    const normalized = normalizeApp(app);
    registeredApps.set(normalized.id, normalized);
    return normalized;
  }

  function getApp(id) {
    return registeredApps.get(id) || null;
  }

  function dashboard() {
    return {
      status: status(),
      apps: listApps(),
      lanes: [
        { id: "local", label: "Local", enabled: true },
        { id: "openai", label: "OpenAI Gateway", enabled: Boolean(process.env.OPENAI_API_KEY) },
        { id: "icp", label: "ICP Deploy Lane", enabled: false },
        { id: "edge", label: "Edge Deploy Lane", enabled: false }
      ],
      boundary: {
        noClientSideApiKeys: true,
        operatorTokenRequiredForWrites: true,
        receiptsRequired: true,
        liveDeployDisabledByDefault: true
      }
    };
  }

  return { status, listApps, registerApp, getApp, dashboard };
}
