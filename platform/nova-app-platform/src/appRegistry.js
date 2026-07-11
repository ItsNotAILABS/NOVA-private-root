export const DEFAULT_APPS = [
  {
    id: 'nova-operator-console',
    name: 'NOVA Operator Console',
    kind: 'console',
    status: 'local',
    description: 'Primary operator surface for apps, sessions, receipts, and AI gateway status.'
  },
  {
    id: 'parallax-control',
    name: 'PARALLAX Control',
    kind: 'finance-research',
    status: 'registered',
    description: 'PARALLAX market, wallet, registry, and exchange control surface.'
  },
  {
    id: 'nova-agent-council',
    name: 'NOVA Agent Council',
    kind: 'agent-orchestration',
    status: 'registered',
    description: 'Agent council and MCP spine interface for local-first agent tools.'
  }
];

export class AppRegistry {
  constructor(apps = DEFAULT_APPS) {
    this.apps = new Map(apps.map((app) => [app.id, { ...app }]));
  }

  list() {
    return [...this.apps.values()].sort((a, b) => a.name.localeCompare(b.name));
  }

  get(id) {
    return this.apps.get(id) || null;
  }

  register(app) {
    if (!app || !app.id || !app.name) throw new Error('app id and name are required');
    if (!/^[a-z0-9][a-z0-9-]{2,80}$/.test(app.id)) throw new Error('invalid app id');
    const record = { status: 'registered', kind: 'app', description: '', ...app, updatedAt: new Date().toISOString() };
    this.apps.set(record.id, record);
    return record;
  }

  snapshot() {
    return { schema: 'nova-app-registry-v0.1', apps: this.list() };
  }
}
