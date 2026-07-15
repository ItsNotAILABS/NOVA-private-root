export const ecosystemServices = [
  {
    id: 'parallax-command-center',
    name: 'PARALLAX Agentic Command Center',
    role: 'orchestration-control-plane',
    protocol: 'http-json',
    healthPath: '/api/health',
    capabilities: ['agent-orchestration','strategy-runtime','automation','governance','receipts'],
    required: true
  },
  {
    id: 'parallax-hft-runtime',
    name