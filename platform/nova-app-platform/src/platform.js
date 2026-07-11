import crypto from 'node:crypto';

export const PLATFORM_VERSION = '0.1.0';

export const DEFAULT_APPS = [
  {
    id: 'parallax-exchange',
    name: 'PARALLAX Exchange',
    category: 'finance',
    route: '/apps/parallax-exchange',
    status: 'builder_ready',
    capabilities: ['market_registry', 'operator_console', 'research_assistant', 'execution_gate'],
    requiresOpenAI: true
  },
  {
    id: 'nova-agent-council',
    name: 'NOVA Agent Council',
    category: 'agent_os',
    route: '/apps/nova-agent-council',
    status: 'builder_ready',
    capabilities: ['mcp_tools', 'task_routing', 'receipts', 'local_runtime'],
    requiresOpenAI: true
  },
  {
    id: 'nova-phone',
    name: 'NOVA Phone',
    category: 'pwa',
    route: '/apps/nova-phone',
    status: 'existing_surface',
    capabilities: ['mobile_shell', 'dashboard', 'operator_tabs'],
    requiresOpenAI: false
  }
];

export function sha256(value) {
  return crypto.createHash('sha256').update(typeof value === 'string' ? value : JSON.stringify(value)).digest('hex');
}

export function createPlatformState({ apps = DEFAULT_APPS } = {}) {
  const now = new Date().toISOString();
  const openaiConfigured = Boolean(process.env.OPENAI_API_KEY);
  const state = {
    schema: 'nova-app-platform-state-v0.1',
    version: PLATFORM_VERSION,
    brand: 'NOVA / ItsNotAILabs',
    createdAt: now,
    openai: {
      configured: openaiConfigured,
      keyPolicy: 'environment_only',
      publicKeyExposure: false
    },
    apps,
    routes: apps.map((app) => ({ id: app.id, route: app.route, status: app.status })),
    operatorLaw: [
      'no_secret_in_source',
      'server_side_ai_gateway_only',
      'receipt_required_for_external_actions',
      'human_approval_required_for_deployments',
      'app_boundary_enforced'
    ]
  };
  state.stateHash = sha256(state);
  return state;
}

export function platformHealth() {
  const state = createPlatformState();
  return {
    ok: true,
    service: 'nova-app-platform',
    version: PLATFORM_VERSION,
    openaiConfigured: state.openai.configured,
    appCount: state.apps.length,
    stateHash: state.stateHash
  };
}

export function getApp(appId, state = createPlatformState()) {
  return state.apps.find((app) => app.id === appId) || null;
}

export function assertKnownApp(appId, state = createPlatformState()) {
  const app = getApp(appId, state);
  if (!app) throw new Error(`unknown app: ${appId}`);
  return app;
}
