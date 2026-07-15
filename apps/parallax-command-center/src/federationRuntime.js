import crypto from 'node:crypto';
import { resolveEcosystem } from './ecosystemRegistry.js';

const timeoutMs = 2500;

function headers(config, body = '') {
  const timestamp = new Date().toISOString();
  const secret = process.env.PARALLAX_FEDERATION_SECRET || '';
  const signature = secret
    ? crypto.createHmac('sha256', secret).update(`${timestamp}.${body}`).digest('hex')
    : '';
  return {
    'content-type': 'application/json',
    'x-parallax-timestamp': timestamp,
    'x-parallax-signature': signature,
    'x-parallax-runtime': config.appName
  };
}

async function request(url, options = {}) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const response = await fetch(url, { ...options, signal: controller.signal });
    const text = await response.text();
    let payload;
    try { payload = text ? JSON.parse(text) : {}; }
    catch { payload = { raw: text }; }
    return { ok: response.ok, status: response.status, payload };
  } catch (error) {
    return { ok: false, status: 0, error: error.name === 'AbortError' ? 'timeout' : error.message };
  } finally {
    clearTimeout(timer);
  }
}

export async function probeEcosystem(config) {
  const services = resolveEcosystem(config);
  return Promise.all(services.map(async (service) => {
    if (service.local) return { ...service, reachable: true, status: 200, state: 'local' };
    if (!service.baseUrl) return { ...service, reachable: false, status: 0, state: 'not-configured' };
    const result = await request(`${service.baseUrl.replace(/\/$/, '')}${service.healthPath}`, {
      headers: headers(config)
    });
    return {
      ...service,
      reachable: result.ok,
      status: result.status,
      state: result.ok ? 'online' : 'offline',
      health: result.payload || null,
      error: result.error || null
    };
  }));
}

export async function dispatchFederatedAction(config, input) {
  const allowedActions = new Set([
    'hft.backtest.request',
    'hft.signal.request',
    'clearing.paper-settlement.request',
    'sns.policy-evaluation.request',
    'sns.proposal.request'
  ]);
  if (!allowedActions.has(input?.action)) throw new Error('federated action is not allowed');
  const service = resolveEcosystem(config).find((item) => item.id === input.service_id);
  if (!service) throw new Error('ecosystem service not found');
  if (service.local) throw new Error('local service actions must use local APIs');
  if (!service.baseUrl) throw new Error('ecosystem service is not configured');
  const body = JSON.stringify({
    action: input.action,
    payload: input.payload || {},
    mode: 'paper-testnet',
    requested_at: new Date().toISOString()
  });
  const result = await request(`${service.baseUrl.replace(/\/$/, '')}/api/federation/actions`, {
    method: 'POST',
    headers: headers(config, body),
    body
  });
  return {
    service_id: service.id,
    action: input.action,
    delivered: result.ok,
    status: result.status,
    response: result.payload || null,
    error: result.error || null,
    mode: 'paper-testnet'
  };
}
