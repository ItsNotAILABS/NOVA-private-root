const JSON_HEADERS = {
  'content-type': 'application/json; charset=utf-8',
  'cache-control': 'no-store'
};

const MAX_BODY_BYTES = 128 * 1024;
const DEFAULT_LEASE_MS = 30_000;
const DEFAULT_HEARTBEAT_MS = 20_000;
const DEFAULT_MAX_ATTEMPTS = 3;
const DEFAULT_RECEIPT_LIMIT = 500;
const DEFAULT_TASK_LIMIT = 500;

export const CAPABILITIES = new Set([
  'repo.monitor',
  'repo.ci',
  'repo.repair-plan',
  'repo.autofix-plan',
  'release.validate',
  'docs.summarize',
  'edge.inference',
  'browser.mesh',
  'memory.recall',
  'receipt.emit'
]);

const TERMINAL_TASK_STATES = new Set(['completed', 'failed', 'denied', 'dead-lettered']);

function json(body, status = 200) {
  return new Response(JSON.stringify(body, null, 2), { status, headers