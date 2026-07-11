import path from 'node:path';
import { fileURLToPath } from 'node:url';

export const __dirname = path.dirname(fileURLToPath(import.meta.url));
export const APP_ROOT = path.resolve(__dirname, '..');
export const REPO_ROOT = path.resolve(APP_ROOT, '../..');

export const config = Object.freeze({
  appName: 'NOVA Capsule Studio',
  version: '0.2.0',
  host: process.env.HOST || '127.0.0.1',
  port: Number(process.env.PORT || 8787),
  publicDir: path.join(APP_ROOT, 'public'),
  dataRoot: process.env.NOVA_CAPSULE_DATA || path.join(REPO_ROOT, '.nova-capsule-studio'),
  openaiModel: process.env.OPENAI_MODEL || 'gpt-4.1-mini',
  openaiConfigured: Boolean(process.env.OPENAI_API_KEY),
  maxPromptLength: Number(process.env.NOVA_MAX_PROMPT_LENGTH || 4000),
  runTimeoutMs: Number(process.env.NOVA_RUN_TIMEOUT_MS || 30000)
});

export const paths = Object.freeze({
  workspaces: path.join(config.dataRoot, 'workspaces'),
  deployments: path.join(config.dataRoot, 'deployments'),
  auditLog: path.join(config.dataRoot, 'audit.log.jsonl')
});
