import test from 'node:test';
import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { setTimeout as sleep } from 'node:timers/promises';

const port = 8967;
const base = `http://127.0.0.1:${port}`;

async function request(path, options = {}) {
  const response = await fetch(`${base}${path}`, {
    ...options,
    headers:{ 'content-type':'application/json', ...(options.headers || {}) }
  });
  const payload = await response.json();
  return { response, payload };
}

test('backend-first API wires connections jobs events and reconciliation', async () => {
  const child = spawn(process.execPath, ['server.js'], {
    cwd:new URL('..', import.meta.url),
    env:{ ...process.env, PARALLAX_PORT:String(port), PARALLAX_HOST:'127.0.0.1', PARALLAX_API_KEY:'test-owner-key', PARALLAX_DATA_DIR:`data-test-${process.pid}` },
    stdio:'ignore'
  });

  try {
    await sleep(900);
    const auth = { authorization:'Bearer test-owner-key' };

    const platform = await request('/api/v1/platform', { headers:auth });
    assert.equal(platform.response.status, 200);
    assert.equal(platform.payload.platform.live_enabled, false);
    assert.equal(platform.payload.platform.custody_enabled, false);

    const unauthorized = await request('/api/v1/platform');
    assert.equal(unauthorized.response.status, 401);

    const connection = await request('/api/v1/connections', {
      method:'POST', headers:auth,
      body:JSON.stringify({ provider:'tradingview', label:'TradingView Test', environment:'paper', config:{ webhook_token_ref:'env:PARALLAX_TRADINGVIEW_TOKEN' } })
    });
    assert.equal(connection.response.status, 201);
    assert.equal(connection.payload.result.profile.provider, 'tradingview');

    const secretRejected = await request('/api/v1/connections', {
      method:'POST', headers:auth,
      body:JSON.stringify({ provider:'alpaca', config:{ api_secret:'raw-secret', api_key_ref:'env:KEY', base_url:'https://paper-api.alpaca.markets' } })
    });
    assert.equal(secretRejected.response.status, 400);

    const job = await request('/api/v1/jobs', {
      method:'POST', headers:auth,
      body:JSON.stringify({ name:'Backend Test Job', bot_id:'bot_alpha', schedule:'manual', payload:{ notional:1000 } })
    });
    assert.equal(job.response.status, 201);

    const run = await request(`/api/v1/jobs/${job.payload.result.id}/run`, { method:'POST', headers:auth, body:'{}' });
    assert.equal(run.response.status, 201);
    assert.equal(run.payload.result.status, 'completed');

    const reconciliation = await request('/api/v1/reconciliations', { method:'POST', headers:auth, body:'{}' });
    assert.equal(reconciliation.response.status, 201);
    assert.ok(['balanced','review-required'].includes(reconciliation.payload.result.status));

    const events = await request('/api/v1/events?limit=50', { headers:auth });
    assert.equal(events.response.status, 200);
    assert.ok(events.payload.events.some(event => event.topic === 'job.completed'));
  } finally {
    child.kill();
  }
});
