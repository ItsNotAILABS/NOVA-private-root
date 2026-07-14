import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));

export const config = {
  appName: 'PARALLAX Agentic Command Center',
  version: '0.1.0',
  host: process.env.PARALLAX_HOST || '127.0.0.1',
  port: Number(process.env.PARALLAX_PORT || 8940),
  root,
  publicDir: path.join(root, 'public'),
  dataDir: path.join(root, 'data'),
  stateFile: path.join(root, 'data', 'state.json'),
  maxBodyBytes: 1_000_000,
  federation: {
    clearinghouse: process.env.PARALLAX_CLEARINGHOUSE_URL || '',
    hft: process.env.PARALLAX_HFT_URL || '',
    sns: process.env.PARALLAX_SNS_URL || ''
  }
};
