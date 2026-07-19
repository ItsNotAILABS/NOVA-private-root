import crypto from 'node:crypto';

const now = () => new Date().toISOString();
const id = prefix => `${prefix}_${crypto.randomUUID().replaceAll('-', '').slice(0, 20)}`;

const adapters = {
  tradingview: {
    type:'signal-and-chart',
    capabilities:['chart-embed','webhook-ingest','symbol-deep-link'],
    required:['webhook_token_ref'],
    live_execution:false
  },
  alpaca: {
    type:'broker',
    capabilities:['account','positions','orders','paper-execution'],
    required:['api_key_ref','api_secret_ref','base_url'],
    live_execution:false
  },
  ibkr: {
    type:'broker',
    capabilities:['account','positions','orders','market-data'],
    required:['gateway_url','account_id_ref'],
    live_execution:false
  },
  coinbase: {
    type:'exchange',
    capabilities:['accounts','products','orders','fills'],
    required:['api_key_ref','api_secret_ref'],
    live_execution:false
  },
  kraken: {
    type:'exchange',
    capabilities:['balance','orders','trades'],
    required:['api_key_ref','api_secret_ref'],
    live_execution:false
  },
  mt5: {
    type:'bridge',
    capabilities:['forex-quotes','positions','orders','expert-advisor-bridge'],
    required:['bridge_url','account_id_ref'],
    live_execution:false
  }
};

export function adapterCatalog() {
  return Object.entries(adapters).map(([id, value]) => ({ id, ...value }));
}

export function tradingViewUrl({ symbol = 'COINBASE:BTCUSD', interval = '15' } = {}) {
  const safeSymbol = encodeURIComponent(String(symbol).toUpperCase());
  const safeInterval = encodeURIComponent(String(interval));
  return `https://www.tradingview.com/chart/?symbol=${safeSymbol}&interval=${safeInterval}`;
}

export function upsertConnection(state, input, actor = 'operator') {
  const provider = String(input.provider || '').toLowerCase();
  const spec = adapters[provider];
  if (!spec) throw Object.assign(new Error('unsupported connection provider'), { status:400 });
  state.connection_profiles ||= [];
  let profile = state.connection_profiles.find(item => item.id === input.id || (item.provider === provider && item.workspace_id === (input.workspace_id || 'ws_primary')));
  const safeConfig = { ...(input.config || {}) };
  for (const [key, value] of Object.entries(safeConfig)) {
    if (/secret|token|password|private.?key|seed|mnemonic/i.test(key) && value && !String(key).endsWith('_ref')) {
      throw Object.assign(new Error(`raw credential rejected for ${key}; provide a secret reference`), { status:400 });
    }
  }
  const missing = spec.required.filter(key => !safeConfig[key]);
  const status = missing.length ? 'incomplete' : 'configured';
  if (!profile) {
    profile = {
      id:id('conn'),
      workspace_id:input.workspace_id || 'ws_primary',
      provider,
      label:input.label || provider.toUpperCase(),
      environment:input.environment || 'paper',
      config:safeConfig,
      capabilities:spec.capabilities,
      status,
      live_execution:false,
      created_by:actor,
      created_at:now(),
      updated_at:now(),
      last_test:null
    };
    state.connection_profiles.push(profile);
  } else {
    Object.assign(profile, {
      label:input.label || profile.label,
      environment:input.environment || profile.environment,
      config:{ ...profile.config, ...safeConfig },
      status,
      updated_at:now()
    });
  }
  return { profile, missing };
}

export async function testConnection(state, profile, { timeoutMs = 4000 } = {}) {
  const started = Date.now();
  let result;
  if (profile.provider === 'tradingview') {
    result = { ok:true, mode:'webhook-and-chart', details:'TradingView chart surface and webhook contract available' };
  } else {
    const url = profile.config?.base_url || profile.config?.gateway_url || profile.config?.bridge_url;
    if (!url) result = { ok:false, error:'connection URL is not configured' };
    else {
      const controller = new AbortController();
      const timer = setTimeout(() => controller.abort(), Math.min(Math.max(timeoutMs, 500), 10000));
      try {
        const response = await fetch(new URL('/health', url), { signal:controller.signal, headers:{ 'user-agent':'PARALLAX/1.0' } });
        result = { ok:response.ok, status:response.status, endpoint:new URL('/health', url).toString() };
      } catch (error) {
        result = { ok:false, error:error.name === 'AbortError' ? 'connection timeout' : error.message };
      } finally {
        clearTimeout(timer);
      }
    }
  }
  profile.last_test = { ...result, latency_ms:Date.now() - started, tested_at:now() };
  profile.status = result.ok ? 'online' : profile.status === 'incomplete' ? 'incomplete' : 'offline';
  profile.updated_at = now();
  return profile.last_test;
}

export function connectionSummary(state) {
  const profiles = state.connection_profiles || [];
  return {
    total:profiles.length,
    online:profiles.filter(x => x.status === 'online').length,
    configured:profiles.filter(x => ['configured','online'].includes(x.status)).length,
    incomplete:profiles.filter(x => x.status === 'incomplete').length,
    profiles
  };
}
