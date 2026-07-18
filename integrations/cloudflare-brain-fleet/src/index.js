const JSON_HEADERS = {
  'content-type': 'application/json; charset=utf-8',
  'cache-control': 'no-store'
};

const MAX_BODY_BYTES = 64 * 1024;
const DEFAULT_LEASE_MS = 30_000;
const DEFAULT_HEARTBEAT_MS = 20_000;
const CAPABILITIES = new Set([
  'repo.monitor',
  'repo.ci',
  'repo.repair-plan',
  'release.validate',
  'docs.summarize',
  'edge.inference',
  'browser.mesh',
  'memory.recall',
  'receipt