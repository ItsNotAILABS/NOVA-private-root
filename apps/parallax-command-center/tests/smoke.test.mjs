import test from 'node:test';
import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { setTimeout as sleep } from 'node:timers/promises';

test('PARALLAX command center serves UI and executes governed agent workflow', async () => {
  const child = spawn(process.execPath, ['server.js'], { cwd: new URL('..', import.meta.url), env: { ...process.env, PARALLAX_PORT: '8942' }, stdio: 'ignore' });
  try {
    await sleep(700);
    const base = 'http://127.0.0.1:8942';
    const health = await fetch(`${base}/api/health`).then(r => r.json());
    assert.equal(health.ok, true);
    const ui = await fetch(base).then(r => r.text());
    assert.match(ui, /PARALLAX Agentic Command Center/);

    const strategy = await fetch(`${base}/api/strategies`, {
      method:'POST', headers:{'content-type':'application/json'},
      body:JSON.stringify({ name:'Smoke Strategy', market:'BTC-USD', risk_limit:0.01, default_notional:5000, mode:'paper' })
    }).then(r => r.json());
    assert.equal(strategy.ok, true);

    const run = await fetch(`${base}/api/automation/run`, {
      method:'POST', headers:{'content-type':'application/json'},
      body:JSON.stringify({ strategy_id:strategy.result.id, symbol:'BTC-USD', notional:5000, mode:'paper' })
    }).then(r => r.json());
    assert.equal(run.ok, true);
    assert.equal(run.result.agents.length, 3);
    assert.ok(['settled-paper','no-trade','pending-human-approval'].includes(run.result.status));
    assert.ok(run.receipt.hash);

    const denied = await fetch(`${base}/api/orders`, {
      method:'POST', headers:{'content-type':'application/json'},
      body:JSON.stringify({ symbol:'BTC-USD', quantity:10, price:64000, mode:'paper' })
    });
    assert.equal(denied.status, 403);

    const liveDenied = await fetch(`${base}/api/automation/run`, {
      method:'POST', headers:{'content-type':'application/json'},
      body:JSON.stringify({ strategy_id:strategy.result.id, mode:'live' })
    });
    assert.equal(liveDenied.status, 500);
  } finally { child.kill(); }
});
