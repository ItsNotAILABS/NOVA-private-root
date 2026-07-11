export const NOVA_APPS = [
  {
    id: 'operator-console',
    name: 'NOVA Operator Console',
    route: '/apps/operator-console',
    description: 'Command surface for platform status, app health, and AI gateway checks.',
    status: 'enabled',
    capabilities: ['status', 'chat', 'receipts']
  },
  {
    id: 'parallax-console',
    name: 'PARALLAX Console',
    route: '/apps/parallax-console',
    description: 'Exchange, wallet, market registry, and research workspace.',
    status: 'enabled',
    capabilities: ['markets', 'wallets', 'research']
  },
  {
    id: 'nova-agent-council',
    name: 'NOVA Agent Council',
    route: '/apps/agent-council',
    description: 'Agent orchestration workspace with permission and receipt boundaries.',
    status: 'enabled',
    capabilities: ['agents', 'permissions', 'mcp']
  }
];

export function listApps() {
  return NOVA_APPS.map((app) => ({ ...app }));
}

export function getApp(appId) {
  return NOVA_APPS.find((app) => app.id === appId) || null;
}

export function requireEnabledApp(appId) {
  const app = getApp(appId);
  if (!app) throw new Error(`unknown app: ${appId}`);
  if (app.status !== 'enabled') throw new Error(`app is not enabled: ${appId}`);
  return app;
}
