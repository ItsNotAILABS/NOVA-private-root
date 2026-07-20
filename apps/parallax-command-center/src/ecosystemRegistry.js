export const ecosystemServices = [
  {
    id: 'parallax-command-center',
    name: 'PARALLAX Agentic Command Center',
    role: 'orchestration-control-plane',
    protocol: 'http-json',
    healthPath: '/api/health',
    capabilities: ['agent-orchestration', 'strategy-runtime', 'automation', 'governance', 'receipts'],
    required: true,
    local: true
  },
  {
    id: 'parallax-hft-runtime',
    name: 'NOVA-HFT Runtime',
    role: 'signal-strategy-execution-lane',
    protocol: 'http-json',
    healthPath: '/api/health',
    capabilities: ['market-data', 'signals', 'backtests', 'paper-orders'],
    required: true,
    configKey: 'hft'
  },
  {
    id: 'parallax-clearinghouse',
    name: 'ARGOS-CLEAR Clearinghouse',
    role: 'clearing-settlement-proof-lane',
    protocol: 'http-json',
    healthPath: '/api/health',
    capabilities: ['fills', 'netting', 'settlement', 'proof-room', 'receipts'],
    required: true,
    configKey: 'clearinghouse'
  },
  {
    id: 'parallax-sns-governance',
    name: 'PLAX-SNS-GOV',
    role: 'governance-token-law-lane',
    protocol: 'http-json',
    healthPath: '/api/health',
    capabilities: ['proposals', 'voting', 'treasury-simulation', 'policy', 'notary-prep'],
    required: true,
    configKey: 'sns'
  }
];

export function resolveEcosystem(config) {
  return ecosystemServices.map((service) => ({
    ...service,
    baseUrl: service.local ? `http://${config.host}:${config.port}` : config.federation[service.configKey] || '',
    configured: service.local || Boolean(config.federation[service.configKey])
  }));
}
