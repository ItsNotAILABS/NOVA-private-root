export const DEFAULT_APPS = [
  {
    id: "nova-operator-console",
    name: "NOVA Operator Console",
    kind: "console",
    status: "local",
    description: "Primary operator surface for apps, sessions, receipts, and AI gateway status."
  },
  {
    id: "parallax-control",
    name: "PARALLAX Control",
    kind: "finance-research",
    status: "registered",
    description: "PARALLAX market, wallet, registry, and exchange control surface."
  },
  {
    id: "nova-agent-council",
    name: "NOVA Agent Council",
    kind: "agent-orchestration",
    status: "registered",
    description: "Agent council and MCP spine interface for local-first agent tools."
  },
  {
    id: "capsule-studio",
    name: "NOVA Capsule Studio",
    kind: "builder-app",
    status: "registered",
    description: "Capsule workspace and app builder surface connected through the NOVA App Platform bridge."
  },
  {
    id: "nova-phone",
    name: "NOVA Phone",
    kind: "pwa",
    status: "registered",
    description: "Installable NOVA phone surface connected through the platform dashboard and bridge contract."
  }
];

export function defaultApps() {
  return DEFAULT_APPS.map((app) => ({ ...app }));
}

export function normalizeApp(app) {
  if (!app || !app.id || !app.name) throw new Error("app_id_and_name_required");
  if (!/^[a-z0-9][a-z0-9-]{2,80}$/.test(app.id)) throw new Error("invalid_app_id");
  return {
    id: app.id,
    name: app.name,
    kind: app.kind || "app",
    status: app.status || "registered",
    description: app.description || "",
    enabled: app.enabled !== false,
    updatedAt: app.updatedAt || new Date().toISOString(),
    metadata: app.metadata || {}
  };
}

export class AppRegistry {
  constructor(apps = defaultApps()) {
    this.apps = new Map(apps.map((app) => {
      const normalized = normalizeApp(app);
      return [normalized.id, normalized];
    }));
  }

  list() {
    return [...this.apps.values()].sort((a, b) => a.name.localeCompare(b.name));
  }

  get(id) {
    return this.apps.get(id) || null;
  }

  register(app) {
    const record = normalizeApp(app);
    this.apps.set(record.id, record);
    return record;
  }

  snapshot() {
    return { schema: "nova-app-registry-v0.1", apps: this.list() };
  }
}
