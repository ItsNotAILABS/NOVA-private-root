import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));

export const config = {
  appName: 'PARALLAX Agentic Command Center',
  version: '0.3.0',
  host: process.env.PARALLAX_HOST || '127.0.0.1',
  port: Number(process.env.PARALLAX_PORT || 8940),
  root,
  publicDir: path.join(root, 'public'),
  dataDir: path.join(root, 'data'),
  stateFile: path.join(root, 'data', 'state.json'),
  maxBodyBytes: 1_000_000,
  automation: {
    enabled: process.env.PARALLAX_AUTOMATION_ENABLED !== 'false',
    intervalMs: Math.max(5000, Number(process.env.PARALLAX_AUTOMATION_INTERVAL_MS || 60000))
  },
  tradingView: {
    webhookToken: process.env.PARALLAX_TRADINGVIEW_TOKEN || '',
    webhookSecret: process.env.PARALLAX_TRADINGVIEW_SECRET || '',
    requireAuthentication: process.env.PARALLAX_TRADINGVIEW_ALLOW_UNSIGNED !== 'true'
  },
  federation: {
    secret: process.env.PARALLAX_FEDERATION_SECRET || '',
    clearinghouse: process.env.PARALLAX_CLEARINGHOUSE_URL || '',
    hft: process.env.PARALLAX_HFT_URL || '',
    sns: process.env.PARALLAX_SNS_URL || ''
  }
};
