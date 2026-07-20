import crypto from 'node:crypto';

const roles = {
  owner: new Set(['*']),
  operator: new Set(['read','strategy:write','bot:write','bot:run','order:approve','wallet:write','connection:write']),
  trader: new Set(['read','strategy:write','bot:write','bot:run','order:approve']),
  analyst: new Set(['read']),
  webhook: new Set(['tradingview:ingest'])
};

const safeEqual = (a, b) => {
  const left = Buffer.from(String(a || ''));
  const right = Buffer.from(String(b || ''));
  return left.length === right.length && crypto.timingSafeEqual(left, right);
};

const parseKeys = () => {
  const raw = process.env.PARALLAX_API_KEYS || '';
  const map = new Map();
  for (const entry of raw.split(',').map(x => x.trim()).filter(Boolean)) {
    const [token, role = 'operator', subject = 'api-client'] = entry.split(':');
    if (token) map.set(token, { role, subject });
  }
  if (process.env.PARALLAX_API_KEY) map.set(process.env.PARALLAX_API_KEY, { role:'owner', subject:'legacy-owner-key' });
  return map;
};

function bearer(headers = {}) {
  const value = headers.authorization || headers.Authorization || '';
  return String(value).startsWith('Bearer ') ? String(value).slice(7).trim() : '';
}

export function authenticateRequest(req, { optional = false } = {}) {
  const configured = parseKeys();
  if (!configured.size) return { ok:true, subject:'local-operator', role:'owner', permissions:['*'], auth:'local-development' };
  const token = bearer(req.headers) || req.headers['x-parallax-api-key'];
  for (const [candidate, identity] of configured.entries()) {
    if (safeEqual(token, candidate)) return { ok:true, ...identity, permissions:[...(roles[identity.role] || roles.analyst)], auth:'api-key' };
  }
  if (optional) return { ok:false, subject:'anonymous', role:'none', permissions:[], auth:'none' };
  const error = new Error('authentication required');
  error.status = 401;
  throw error;
}

export function authorize(identity, permission) {
  const allowed = roles[identity?.role] || new Set();
  if (allowed.has('*') || allowed.has(permission) || (permission.startsWith('read') && allowed.has('read'))) return true;
  const error = new Error(`permission denied: ${permission}`);
  error.status = 403;
  throw error;
}

export function requestContext(req, permission = 'read') {
  const identity = authenticateRequest(req);
  authorize(identity, permission);
  return {
    request_id: req.headers['x-request-id'] || crypto.randomUUID(),
    actor: identity.subject,
    role: identity.role,
    auth: identity.auth,
    permission
  };
}

export function redactSecrets(value) {
  if (!value || typeof value !== 'object') return value;
  const blocked = /token|secret|password|private.?key|seed|mnemonic/i;
  if (Array.isArray(value)) return value.map(redactSecrets);
  return Object.fromEntries(Object.entries(value).map(([key, item]) => [key, blocked.test(key) ? '[REDACTED]' : redactSecrets(item)]));
}
